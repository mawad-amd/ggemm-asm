#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <vector>

#define HIP_CHECK(x) do { \
    hipError_t err = (x); \
    if (err != hipSuccess) { \
        fprintf(stderr, "HIP error %d: %s at %s:%d\n", err, hipGetErrorString(err), __FILE__, __LINE__); \
        exit(1); \
    } \
} while(0)

struct KernelArgs {
    void*    lhs;
    void*    rhs;
    void*    out;
    void*    lhs_scale;
    void*    rhs_scale;
    void*    group_offs;
    int32_t  G;
    int32_t  OUT_M;
    int32_t  OUT_N;
    int32_t  stride_lhs_m;
    int32_t  stride_rhs_m;
    int32_t  stride_cg;
    int32_t  stride_cm;
    int32_t  stride_cn;
    void*    global_scratch;
    void*    profile_scratch;
};

static std::vector<char> read_file(const char* path) {
    FILE* f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Cannot open %s\n", path); exit(1); }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    std::vector<char> buf(sz);
    fread(buf.data(), 1, sz, f);
    fclose(f);
    return buf;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <kernel.co> [--warmup N] [--iters N] [--site gate_up_wgrad|down_wgrad]\n", argv[0]);
        return 1;
    }

    const char* co_path = argv[1];
    int warmup = 20;
    int iters = 100;
    const char* site = "gate_up_wgrad";

    for (int i = 2; i < argc; i++) {
        if (!strcmp(argv[i], "--warmup") && i+1 < argc) warmup = atoi(argv[++i]);
        else if (!strcmp(argv[i], "--iters") && i+1 < argc) iters = atoi(argv[++i]);
        else if (!strcmp(argv[i], "--site") && i+1 < argc) site = argv[++i];
    }

    const int E = 32;
    const int M_TOTAL = 131072;
    int OUT_M, OUT_N;
    if (!strcmp(site, "gate_up_wgrad")) {
        OUT_M = 2880; OUT_N = 5760;
    } else if (!strcmp(site, "down_wgrad")) {
        OUT_M = 2880; OUT_N = 2880;
    } else {
        fprintf(stderr, "Unknown site: %s\n", site);
        return 1;
    }

    double flops = 2.0 * M_TOTAL * OUT_M * OUT_N;

    int num_cus = 0;
    hipDeviceProp_t props;
    HIP_CHECK(hipGetDeviceProperties(&props, 0));
    num_cus = props.multiProcessorCount;

    printf("GPU: %s (%d CUs)\n", props.name, num_cus);
    printf("Site: %s  E=%d M=%d OUT_M=%d OUT_N=%d\n", site, E, M_TOTAL, OUT_M, OUT_N);
    printf("Warmup: %d  Iters: %d\n", warmup, iters);

    // allocate
    void *d_lhs, *d_rhs, *d_out, *d_lhs_scale, *d_rhs_scale, *d_group_offs;

    HIP_CHECK(hipMalloc(&d_lhs, (size_t)M_TOTAL * OUT_M));       // fp8 = 1 byte
    HIP_CHECK(hipMalloc(&d_rhs, (size_t)M_TOTAL * OUT_N));       // fp8 = 1 byte
    HIP_CHECK(hipMalloc(&d_out, (size_t)E * OUT_M * OUT_N * 2)); // bf16 = 2 bytes
    HIP_CHECK(hipMalloc(&d_lhs_scale, 4));                        // float32
    HIP_CHECK(hipMalloc(&d_rhs_scale, 4));                        // float32
    HIP_CHECK(hipMalloc(&d_group_offs, (E + 1) * 8));            // int64

    // fill with random data (not matching python RNG - just for timing)
    // group_offs: uniform split
    std::vector<int64_t> h_offs(E + 1);
    h_offs[0] = 0;
    for (int i = 1; i <= E; i++)
        h_offs[i] = (int64_t)M_TOTAL * i / E;
    HIP_CHECK(hipMemcpy(d_group_offs, h_offs.data(), (E+1)*8, hipMemcpyHostToDevice));

    // fill inputs with 1s (won't match triton output but kernel will execute the same codepath)
    HIP_CHECK(hipMemset(d_lhs, 0x38, (size_t)M_TOTAL * OUT_M));  // 0x38 = 0.5 in e4m3
    HIP_CHECK(hipMemset(d_rhs, 0x38, (size_t)M_TOTAL * OUT_N));
    HIP_CHECK(hipMemset(d_out, 0, (size_t)E * OUT_M * OUT_N * 2));

    float scale_val = 0.1f;
    HIP_CHECK(hipMemcpy(d_lhs_scale, &scale_val, 4, hipMemcpyHostToDevice));
    HIP_CHECK(hipMemcpy(d_rhs_scale, &scale_val, 4, hipMemcpyHostToDevice));

    // load kernel
    auto co_data = read_file(co_path);
    hipModule_t module;
    hipFunction_t func;
    HIP_CHECK(hipModuleLoadData(&module, co_data.data()));
    HIP_CHECK(hipModuleGetFunction(&func, module, "_grouped_variable_k_gemm_kernel"));

    printf("Loaded: %s (%zu bytes)\n\n", co_path, co_data.size());

    // pack args
    KernelArgs args;
    args.lhs          = d_lhs;
    args.rhs          = d_rhs;
    args.out          = d_out;
    args.lhs_scale    = d_lhs_scale;
    args.rhs_scale    = d_rhs_scale;
    args.group_offs   = d_group_offs;
    args.G            = E;
    args.OUT_M        = OUT_M;
    args.OUT_N        = OUT_N;
    args.stride_lhs_m = OUT_M;
    args.stride_rhs_m = OUT_N;
    args.stride_cg    = OUT_M * OUT_N;
    args.stride_cm    = OUT_N;
    args.stride_cn    = 1;
    args.global_scratch  = nullptr;
    args.profile_scratch = nullptr;

    size_t arg_size = sizeof(KernelArgs);
    void* config[] = {
        HIP_LAUNCH_PARAM_BUFFER_POINTER, &args,
        HIP_LAUNCH_PARAM_BUFFER_SIZE, &arg_size,
        HIP_LAUNCH_PARAM_END
    };

    // warmup
    for (int i = 0; i < warmup; i++) {
        HIP_CHECK(hipModuleLaunchKernel(func,
            num_cus, 1, 1,
            512, 1, 1,
            65536, nullptr, nullptr, config));
    }
    HIP_CHECK(hipDeviceSynchronize());

    // timed runs
    hipEvent_t start, stop;
    HIP_CHECK(hipEventCreate(&start));
    HIP_CHECK(hipEventCreate(&stop));

    HIP_CHECK(hipEventRecord(start, nullptr));
    for (int i = 0; i < iters; i++) {
        HIP_CHECK(hipModuleLaunchKernel(func,
            num_cus, 1, 1,
            512, 1, 1,
            65536, nullptr, nullptr, config));
    }
    HIP_CHECK(hipEventRecord(stop, nullptr));
    HIP_CHECK(hipEventSynchronize(stop));

    float total_ms = 0;
    HIP_CHECK(hipEventElapsedTime(&total_ms, start, stop));
    double avg_ms = total_ms / iters;
    double tflops = flops / (avg_ms * 1e-3) / 1e12;

    printf("  Kernel:  %.3f ms  %.1f TFLOPS\n", avg_ms, tflops);

    // cleanup
    HIP_CHECK(hipEventDestroy(start));
    HIP_CHECK(hipEventDestroy(stop));
    HIP_CHECK(hipModuleUnload(module));
    HIP_CHECK(hipFree(d_lhs));
    HIP_CHECK(hipFree(d_rhs));
    HIP_CHECK(hipFree(d_out));
    HIP_CHECK(hipFree(d_lhs_scale));
    HIP_CHECK(hipFree(d_rhs_scale));
    HIP_CHECK(hipFree(d_group_offs));

    return 0;
}
