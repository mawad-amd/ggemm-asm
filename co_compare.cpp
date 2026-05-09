#include <hip/hip_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstring>
#include <random>

#define HIP_CHECK(call) do { \
    hipError_t err = (call); \
    if (err != hipSuccess) { \
        fprintf(stderr, "HIP error %d at %s:%d: %s\n", err, __FILE__, __LINE__, hipGetErrorString(err)); \
        exit(1); \
    } \
} while(0)

static const char* KERNEL_NAMES[] = {
    "_grouped_fp8_persistent_gemm_kernel",
    "_grouped_variable_k_gemm_kernel",
    nullptr
};

hipFunction_t load_kernel(const char* path, hipModule_t* mod) {
    FILE* f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Cannot open %s\n", path); exit(1); }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = (char*)malloc(sz);
    fread(buf, 1, sz, f);
    fclose(f);
    HIP_CHECK(hipModuleLoadData(mod, buf));
    free(buf);
    hipFunction_t func;
    for (int i = 0; KERNEL_NAMES[i]; i++) {
        hipError_t err = hipModuleGetFunction(&func, *mod, KERNEL_NAMES[i]);
        if (err == hipSuccess) {
            printf("  kernel: %s\n", KERNEL_NAMES[i]);
            return func;
        }
    }
    fprintf(stderr, "No known kernel found in %s\n", path);
    exit(1);
}

// Flat kernarg buffer layout (96 bytes):
// offset  size  content
//   0       8   ptr lhs
//   8       8   ptr rhs
//  16       8   ptr out
//  24       8   ptr lhs_scale
//  32       8   ptr rhs_scale
//  40       8   ptr group_offs
//  48       4   i32 G (num experts)
//  52       4   i32 OUT_M / N
//  56       4   i32 OUT_N / K
//  60       4   i32 stride_lhs
//  64       4   i32 stride_rhs
//  68       4   i32 stride_out0
//  72       4   i32 stride_out1
//  76       4   i32 stride_out2
//  80       8   ptr global_scratch
//  88       8   ptr profile_scratch

void launch_kernel(hipFunction_t func,
                   void* a, void* b, void* out,
                   void* a_scale, void* b_scale, void* group_offs,
                   int G, int dim1, int dim2,
                   int stride_a, int stride_b, int stride_c0,
                   int stride_c1, int stride_c2,
                   int num_sms) {
    uint8_t args[96];
    memset(args, 0, 96);
    *(uint64_t*)(args + 0)  = (uint64_t)a;
    *(uint64_t*)(args + 8)  = (uint64_t)b;
    *(uint64_t*)(args + 16) = (uint64_t)out;
    *(uint64_t*)(args + 24) = (uint64_t)a_scale;
    *(uint64_t*)(args + 32) = (uint64_t)b_scale;
    *(uint64_t*)(args + 40) = (uint64_t)group_offs;
    *(int32_t*)(args + 48) = G;
    *(int32_t*)(args + 52) = dim1;
    *(int32_t*)(args + 56) = dim2;
    *(int32_t*)(args + 60) = stride_a;
    *(int32_t*)(args + 64) = stride_b;
    *(int32_t*)(args + 68) = stride_c0;
    *(int32_t*)(args + 72) = stride_c1;
    *(int32_t*)(args + 76) = stride_c2;
    *(uint64_t*)(args + 80) = 0;
    *(uint64_t*)(args + 88) = 0;
    size_t arg_size = 96;
    void* config[] = {
        HIP_LAUNCH_PARAM_BUFFER_POINTER, args,
        HIP_LAUNCH_PARAM_BUFFER_SIZE, &arg_size,
        HIP_LAUNCH_PARAM_END
    };
    HIP_CHECK(hipModuleLaunchKernel(func, num_sms, 1, 1, 512, 1, 1, 65536,
                                     nullptr, nullptr, config));
    HIP_CHECK(hipDeviceSynchronize());
}

int main(int argc, char** argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s ref.co test.co [--benchmark] [--warmup N] [--iters N] [--site NAME]\n", argv[0]);
        fprintf(stderr, "Sites: gate_up_fwd, down_fwd, down_dgrad, gate_up_dgrad, gate_up_wgrad, down_wgrad\n");
        return 1;
    }

    const char* ref_path = argv[1];
    const char* test_path = argv[2];
    bool do_benchmark = false;
    int warmup = 50, niters = 200;
    const char* site_filter = nullptr;

    for (int i = 3; i < argc; i++) {
        if (strcmp(argv[i], "--benchmark") == 0) do_benchmark = true;
        else if (strcmp(argv[i], "--warmup") == 0 && i+1 < argc) warmup = atoi(argv[++i]);
        else if (strcmp(argv[i], "--iters") == 0 && i+1 < argc) niters = atoi(argv[++i]);
        else if (strcmp(argv[i], "--site") == 0 && i+1 < argc) site_filter = argv[++i];
    }

    HIP_CHECK(hipSetDevice(0));
    hipDeviceProp_t props;
    HIP_CHECK(hipGetDeviceProperties(&props, 0));
    int num_sms = props.multiProcessorCount;
    printf("Device: %s (%d CUs)\n", props.name, num_sms);

    hipModule_t ref_mod, test_mod;
    hipFunction_t ref_func = load_kernel(ref_path, &ref_mod);
    hipFunction_t test_func;
    bool same_co = (strcmp(ref_path, test_path) == 0);
    if (same_co) { test_mod = ref_mod; test_func = ref_func; }
    else { test_func = load_kernel(test_path, &test_mod); }
    printf("\n");

    // FWD/DGRAD: lhs=(M,K) rhs=(E,N,K) out=(M,N)
    //   args: G, N, K, stride_lhs=K, stride_rhs=N*K, stride_out0=K, stride_out1=N, stride_out2=1
    //   a_bytes=M*K, b_bytes=E*N*K, out_bytes=M*N*2, out_elems=M*N, flops=2*M*N*K
    //
    // WGRAD: lhs=(M,OUT_M) rhs=(M,OUT_N) out=(E,OUT_M,OUT_N)
    //   args: G, OUT_M, OUT_N, stride_lhs=OUT_M, stride_rhs=OUT_N, stride_out0=OUT_M*OUT_N, stride_out1=OUT_N, stride_out2=1
    //   a_bytes=M*OUT_M, b_bytes=M*OUT_N, out_bytes=E*OUT_M*OUT_N*2, out_elems=E*OUT_M*OUT_N, flops=2*M*OUT_M*OUT_N

    struct Site {
        const char* name;
        int dim1, dim2;
        bool is_wgrad;
    };
    Site sites[] = {
        {"gate_up_fwd",   2880, 5760, false},
        {"down_fwd",      2880, 2880, false},
        {"down_dgrad",    2880, 2880, false},
        {"gate_up_dgrad", 5760, 2880, false},
        {"gate_up_wgrad", 2880, 5760, true},
        {"down_wgrad",    2880, 2880, true},
    };

    const int E = 32;
    const int M_TOTAL = 131072;

    int64_t h_offs[E + 1];
    int per_expert = M_TOTAL / E;
    for (int i = 0; i <= E; i++) h_offs[i] = (int64_t)i * per_expert;
    int64_t* d_offs;
    HIP_CHECK(hipMalloc(&d_offs, (E + 1) * sizeof(int64_t)));
    HIP_CHECK(hipMemcpy(d_offs, h_offs, (E + 1) * sizeof(int64_t), hipMemcpyHostToDevice));

    for (auto& site : sites) {
        if (site_filter && strcmp(site_filter, site.name) != 0) continue;

        int D1 = site.dim1, D2 = site.dim2;
        size_t a_bytes, b_bytes, out_bytes;
        size_t out_elems;
        int stride_a, stride_b, stride_c0, stride_c1, stride_c2;
        double flops;

        if (site.is_wgrad) {
            // lhs=(M,OUT_M) rhs=(M,OUT_N) out=(E,OUT_M,OUT_N)
            a_bytes = (size_t)M_TOTAL * D1;
            b_bytes = (size_t)M_TOTAL * D2;
            out_bytes = (size_t)E * D1 * D2 * 2;
            out_elems = (size_t)E * D1 * D2;
            stride_a = D1;
            stride_b = D2;
            stride_c0 = D1 * D2;
            stride_c1 = D2;
            stride_c2 = 1;
            flops = 2.0 * M_TOTAL * D1 * D2;
        } else {
            // lhs=(M,K) rhs=(E,N,K) out=(M,N)
            int K = D1, N = D2;
            a_bytes = (size_t)M_TOTAL * K;
            b_bytes = (size_t)E * N * K;
            out_bytes = (size_t)M_TOTAL * N * 2;
            out_elems = (size_t)M_TOTAL * N;
            stride_a = K;
            stride_b = N * K;
            stride_c0 = K;
            stride_c1 = N;
            stride_c2 = 1;
            flops = 2.0 * M_TOTAL * N * K;
        }

        printf("%-16s M=%d D1=%d D2=%d  A=%.0fMB B=%.0fMB Out=%.0fMB\n",
               site.name, M_TOTAL, D1, D2, a_bytes/1e6, b_bytes/1e6, out_bytes/1e6);

        void *d_a, *d_b, *d_ref_out, *d_test_out;
        float *d_a_scale, *d_b_scale;
        HIP_CHECK(hipMalloc(&d_a, a_bytes));
        HIP_CHECK(hipMalloc(&d_b, b_bytes));
        HIP_CHECK(hipMalloc(&d_ref_out, out_bytes));
        HIP_CHECK(hipMalloc(&d_test_out, out_bytes));
        HIP_CHECK(hipMalloc(&d_a_scale, sizeof(float)));
        HIP_CHECK(hipMalloc(&d_b_scale, sizeof(float)));

        std::mt19937 rng(42);
        {
            size_t max_sz = a_bytes > b_bytes ? a_bytes : b_bytes;
            uint8_t* h_buf = (uint8_t*)malloc(max_sz);
            for (size_t j = 0; j < a_bytes; j++) h_buf[j] = rng() & 0x3F;
            HIP_CHECK(hipMemcpy(d_a, h_buf, a_bytes, hipMemcpyHostToDevice));
            for (size_t j = 0; j < b_bytes; j++) h_buf[j] = rng() & 0x3F;
            HIP_CHECK(hipMemcpy(d_b, h_buf, b_bytes, hipMemcpyHostToDevice));
            free(h_buf);
        }
        float scale_val = 1.0f;
        HIP_CHECK(hipMemcpy(d_a_scale, &scale_val, sizeof(float), hipMemcpyHostToDevice));
        HIP_CHECK(hipMemcpy(d_b_scale, &scale_val, sizeof(float), hipMemcpyHostToDevice));
        HIP_CHECK(hipMemset(d_ref_out, 0, out_bytes));
        HIP_CHECK(hipMemset(d_test_out, 0, out_bytes));

        launch_kernel(ref_func, d_a, d_b, d_ref_out, d_a_scale, d_b_scale, d_offs,
                      E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);
        launch_kernel(test_func, d_a, d_b, d_test_out, d_a_scale, d_b_scale, d_offs,
                      E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);

        uint16_t* h_ref = (uint16_t*)malloc(out_bytes);
        uint16_t* h_test = (uint16_t*)malloc(out_bytes);
        HIP_CHECK(hipMemcpy(h_ref, d_ref_out, out_bytes, hipMemcpyDeviceToHost));
        HIP_CHECK(hipMemcpy(h_test, d_test_out, out_bytes, hipMemcpyDeviceToHost));

        double dot = 0, norm_r = 0, norm_t = 0;
        size_t ref_nz = 0, test_nz = 0, nan_count = 0;
        float max_diff = 0;
        for (size_t j = 0; j < out_elems; j++) {
            float rv, tv;
            uint32_t r32 = (uint32_t)h_ref[j] << 16;
            uint32_t t32 = (uint32_t)h_test[j] << 16;
            memcpy(&rv, &r32, 4);
            memcpy(&tv, &t32, 4);
            if (std::isnan(rv) || std::isnan(tv)) { nan_count++; continue; }
            dot += (double)rv * tv;
            norm_r += (double)rv * rv;
            norm_t += (double)tv * tv;
            float diff = fabsf(rv - tv);
            if (diff > max_diff) max_diff = diff;
            if (h_ref[j] != 0) ref_nz++;
            if (h_test[j] != 0) test_nz++;
        }
        double cos_sim = dot / (sqrt(norm_r) * sqrt(norm_t) + 1e-12);
        const char* status = cos_sim >= 0.999 ? "PASS" : "FAIL";
        printf("  [%s] cos=%.6f  max_diff=%.6f  ref_nz=%zu/%zu  test_nz=%zu/%zu  nan=%zu\n",
               status, cos_sim, max_diff, ref_nz, out_elems, test_nz, out_elems, nan_count);

        if (do_benchmark) {
            hipEvent_t start, stop;
            HIP_CHECK(hipEventCreate(&start));
            HIP_CHECK(hipEventCreate(&stop));

            for (int i = 0; i < warmup; i++)
                launch_kernel(ref_func, d_a, d_b, d_ref_out, d_a_scale, d_b_scale, d_offs,
                              E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);
            HIP_CHECK(hipEventRecord(start));
            for (int i = 0; i < niters; i++)
                launch_kernel(ref_func, d_a, d_b, d_ref_out, d_a_scale, d_b_scale, d_offs,
                              E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);
            HIP_CHECK(hipEventRecord(stop));
            HIP_CHECK(hipEventSynchronize(stop));
            float ref_ms;
            HIP_CHECK(hipEventElapsedTime(&ref_ms, start, stop));
            ref_ms /= niters;

            for (int i = 0; i < warmup; i++)
                launch_kernel(test_func, d_a, d_b, d_test_out, d_a_scale, d_b_scale, d_offs,
                              E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);
            HIP_CHECK(hipEventRecord(start));
            for (int i = 0; i < niters; i++)
                launch_kernel(test_func, d_a, d_b, d_test_out, d_a_scale, d_b_scale, d_offs,
                              E, D1, D2, stride_a, stride_b, stride_c0, stride_c1, stride_c2, num_sms);
            HIP_CHECK(hipEventRecord(stop));
            HIP_CHECK(hipEventSynchronize(stop));
            float test_ms;
            HIP_CHECK(hipEventElapsedTime(&test_ms, start, stop));
            test_ms /= niters;

            double ref_tflops = flops / (ref_ms * 1e-3) / 1e12;
            double test_tflops = flops / (test_ms * 1e-3) / 1e12;
            printf("  ref=%.3f ms (%.1f TFLOPS)  test=%.3f ms (%.1f TFLOPS)  speedup=%.4fx\n",
                   ref_ms, ref_tflops, test_ms, test_tflops, ref_ms / test_ms);

            HIP_CHECK(hipEventDestroy(start));
            HIP_CHECK(hipEventDestroy(stop));
        }

        HIP_CHECK(hipFree(d_a));
        HIP_CHECK(hipFree(d_b));
        HIP_CHECK(hipFree(d_ref_out));
        HIP_CHECK(hipFree(d_test_out));
        HIP_CHECK(hipFree(d_a_scale));
        HIP_CHECK(hipFree(d_b_scale));
        free(h_ref);
        free(h_test);
    }

    HIP_CHECK(hipModuleUnload(ref_mod));
    if (!same_co) HIP_CHECK(hipModuleUnload(test_mod));
    return 0;
}
