#!/usr/bin/env python3
"""
Benchmark harness for dot_scaled grouped GEMM.

Runs correctness check against torch reference and benchmarks against the
Triton reference .co (primus v26.2, v_mfma_f32_16x16x32_fp8_bf8).

Usage:
  # Correctness + benchmark (needs ref .co)
  python3 bench.py --ref-co kernels/variable_k_gemm_ref.co

  # Benchmark only (no ref .co needed)
  python3 bench.py --benchmark

  # Specific site
  python3 bench.py --site down_wgrad --benchmark
"""
import argparse
import ctypes
import os
import time

import torch

from grouped_vark_dot_scaled import grouped_variable_k_dot_scaled_kernel


# ── HIP ctypes ──

_hip = None

def _load_hip():
    global _hip
    if _hip is not None:
        return _hip
    for name in ["libamdhip64.so", "libamdhip64.so.6"]:
        try:
            _hip = ctypes.CDLL(name)
            break
        except OSError:
            continue
    if _hip is None:
        _hip = ctypes.CDLL("/opt/rocm/lib/libamdhip64.so")
    _hip.hipModuleLoadData.restype = ctypes.c_int
    _hip.hipModuleLoadData.argtypes = [ctypes.POINTER(ctypes.c_void_p), ctypes.c_void_p]
    _hip.hipModuleGetFunction.restype = ctypes.c_int
    _hip.hipModuleGetFunction.argtypes = [ctypes.POINTER(ctypes.c_void_p), ctypes.c_void_p, ctypes.c_char_p]
    _hip.hipModuleLaunchKernel.restype = ctypes.c_int
    _hip.hipModuleLaunchKernel.argtypes = [
        ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint, ctypes.c_uint,
        ctypes.c_uint, ctypes.c_uint, ctypes.c_uint,
        ctypes.c_uint, ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_void_p), ctypes.c_void_p]
    _hip.hipDeviceSynchronize.restype = ctypes.c_int
    _hip.hipGetErrorString.restype = ctypes.c_char_p
    _hip.hipGetErrorString.argtypes = [ctypes.c_int]
    return _hip


def _check(err, msg=""):
    if err != 0:
        hip = _load_hip()
        raise RuntimeError(f"HIP error {err} ({hip.hipGetErrorString(err)}): {msg}")


def _ptr(t):
    return ctypes.c_void_p(t.data_ptr())


def _i32(v):
    return ctypes.c_int32(int(v))


def _pack(*args):
    arr = (ctypes.c_void_p * len(args))()
    storage = []
    for i, a in enumerate(args):
        if isinstance(a, ctypes.c_void_p):
            p = ctypes.c_uint64(a.value if a.value else 0)
        else:
            p = ctypes.c_int32(a.value)
        storage.append(p)
        arr[i] = ctypes.cast(ctypes.pointer(storage[-1]), ctypes.c_void_p)
    return arr, storage


# ── Shapes ──

E = 32
M_TOTAL = 131072
F_DIM = 2880
F2_DIM = 5760

SITES = {
    "gate_up_wgrad": {"OUT_M": F_DIM, "OUT_N": F2_DIM, "desc": "dW_gu = x^T @ dy_gu"},
    "down_wgrad":    {"OUT_M": F_DIM, "OUT_N": F_DIM,  "desc": "dW_d = swiglu^T @ dy_d"},
}

# Best config from sweep
BEST_CONFIG = {"BLOCK_M": 256, "BLOCK_N": 256, "BLOCK_K": 128, "num_warps": 16, "GROUP_M": 4, "num_stages": 2}


def make_group_lens(E, M_total, seed=42):
    rng = torch.Generator().manual_seed(seed)
    raw = torch.empty(E).exponential_(generator=rng)
    raw = raw / raw.sum() * M_total
    lens = raw.long()
    lens[-1] = M_total - lens[:-1].sum()
    assert lens.sum() == M_total and (lens > 0).all()
    return lens.cuda()


def make_group_offs(group_lens):
    offs = torch.zeros(len(group_lens) + 1, dtype=torch.int64, device=group_lens.device)
    offs[1:] = torch.cumsum(group_lens.long(), dim=0)
    return offs


def torch_reference(lhs_fp8, rhs_fp8, group_offs, OUT_M, OUT_N, G, lhs_scale, rhs_scale):
    out = torch.zeros(G, OUT_M, OUT_N, device='cuda', dtype=torch.bfloat16)
    scale = lhs_scale.item() * rhs_scale.item()
    for g in range(G):
        k_start = group_offs[g].item()
        k_end = group_offs[g + 1].item()
        a = lhs_fp8[k_start:k_end, :OUT_M].float()
        b = rhs_fp8[k_start:k_end, :OUT_N].float()
        out[g] = (a.T @ b * scale).to(torch.bfloat16)
    return out


def run_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, G, cfg=None):
    if cfg is None:
        cfg = BEST_CONFIG
    NUM_SMS = torch.cuda.get_device_properties(0).multi_processor_count
    out = torch.zeros(G, OUT_M, OUT_N, device='cuda', dtype=torch.bfloat16)
    grouped_variable_k_dot_scaled_kernel[(NUM_SMS,)](
        lhs, rhs, out,
        lhs_scale, rhs_scale, group_offs,
        G, OUT_M, OUT_N,
        lhs.stride(0), rhs.stride(0),
        out.stride(0), out.stride(1), out.stride(2),
        NUM_SMS=NUM_SMS,
        BLOCK_M=cfg["BLOCK_M"], BLOCK_N=cfg["BLOCK_N"],
        BLOCK_K=cfg["BLOCK_K"], GROUP_M=cfg["GROUP_M"],
        num_warps=cfg["num_warps"], num_stages=cfg.get("num_stages", 2),
    )
    return out


def bench_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, G,
                     warmup=20, iters=50, cfg=None):
    for _ in range(warmup):
        run_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, G, cfg)
    torch.cuda.synchronize()

    se = torch.cuda.Event(enable_timing=True)
    ee = torch.cuda.Event(enable_timing=True)
    se.record()
    for _ in range(iters):
        run_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, G, cfg)
    ee.record()
    torch.cuda.synchronize()
    return se.elapsed_time(ee) / iters


def bench_ref_co(ref_func, lhs, rhs, ref_out, lhs_scale, rhs_scale, group_offs,
                 OUT_M, OUT_N, warmup=20, iters=50):
    hip = _load_hip()
    NUM_SMS = torch.cuda.get_device_properties(0).multi_processor_count
    args = [
        _ptr(lhs), _ptr(rhs), _ptr(ref_out),
        _ptr(lhs_scale), _ptr(rhs_scale), _ptr(group_offs),
        _i32(E), _i32(OUT_M), _i32(OUT_N),
        _i32(lhs.stride(0)), _i32(rhs.stride(0)),
        _i32(ref_out.stride(0)), _i32(ref_out.stride(1)), _i32(ref_out.stride(2)),
        ctypes.c_void_p(0), ctypes.c_void_p(0),
    ]
    packed, _s = _pack(*args)

    def launch():
        _check(hip.hipModuleLaunchKernel(
            ref_func, NUM_SMS, 1, 1, 512, 1, 1, 65536, None, packed, None))

    for _ in range(warmup):
        launch()
    hip.hipDeviceSynchronize()

    se = torch.cuda.Event(enable_timing=True)
    ee = torch.cuda.Event(enable_timing=True)
    se.record()
    for _ in range(iters):
        launch()
    ee.record()
    torch.cuda.synchronize()
    return se.elapsed_time(ee) / iters


def assemble_kernel(s_path, ref_co_path):
    import subprocess, struct
    co_path = s_path.replace('.s', '.co')
    o_path = s_path.replace('.s', '.o')
    tmp_co = s_path.replace('.s', '_tmp.co')
    r = subprocess.run(['/opt/rocm/llvm/bin/llvm-mc', '-triple=amdgcn-amd-amdhsa', '-mcpu=gfx950',
                        '-filetype=obj', '-o', o_path, s_path], capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"Assembly failed: {r.stderr}")
    r = subprocess.run(['/opt/rocm/llvm/bin/ld.lld', '-shared', '-o', tmp_co, o_path],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"Link failed: {r.stderr}")
    text_bin = s_path.replace('.s', '_text.bin')
    r = subprocess.run(['/opt/rocm/llvm/bin/llvm-objcopy', '-O', 'binary',
                        '--only-section=.text', tmp_co, text_bin],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"objcopy failed: {r.stderr}")
    with open(ref_co_path, 'rb') as f:
        ref_data = bytearray(f.read())
    with open(text_bin, 'rb') as f:
        custom_text = f.read()
    r2 = subprocess.run(['/opt/rocm/llvm/bin/llvm-readelf', '-S', '--wide', ref_co_path],
                        capture_output=True, text=True)
    ref_text_off = -1
    for line in r2.stdout.splitlines():
        if '.text' in line and 'PROGBITS' in line:
            parts = line.split()
            for i, p in enumerate(parts):
                if p == 'PROGBITS':
                    ref_text_off = int(parts[i+2], 16)
                    break
            break
    if ref_text_off < 0:
        raise RuntimeError("Could not find .text section in ref .co")
    ref_text_size = len(custom_text)
    ref_data[ref_text_off:ref_text_off + ref_text_size] = custom_text
    with open(co_path, 'wb') as f:
        f.write(bytes(ref_data))
    print(f"Assembled {s_path} -> {co_path}")
    print(f"  Patched {ref_text_size} bytes into {ref_co_path} (metadata preserved)")
    return co_path


def bench_custom_co(custom_func, lhs, rhs, custom_out, lhs_scale, rhs_scale, group_offs,
                    OUT_M, OUT_N, warmup=20, iters=50, block_size=1024):
    hip = _load_hip()
    NUM_SMS = torch.cuda.get_device_properties(0).multi_processor_count
    args = [
        _ptr(lhs), _ptr(rhs), _ptr(custom_out),
        _ptr(lhs_scale), _ptr(rhs_scale), _ptr(group_offs),
        _i32(E), _i32(OUT_M), _i32(OUT_N),
        _i32(lhs.stride(0)), _i32(rhs.stride(0)),
        _i32(custom_out.stride(0)), _i32(custom_out.stride(1)), _i32(custom_out.stride(2)),
        ctypes.c_void_p(0), ctypes.c_void_p(0),
    ]
    packed, _s = _pack(*args)

    def launch():
        custom_out.zero_()
        _check(hip.hipModuleLaunchKernel(
            custom_func, NUM_SMS, 1, 1, block_size, 1, 1, 65536, None, packed, None))

    for _ in range(warmup):
        launch()
    hip.hipDeviceSynchronize()

    se = torch.cuda.Event(enable_timing=True)
    ee = torch.cuda.Event(enable_timing=True)
    se.record()
    for _ in range(iters):
        launch()
    ee.record()
    torch.cuda.synchronize()
    return se.elapsed_time(ee) / iters


def main():
    parser = argparse.ArgumentParser(description="dot_scaled grouped GEMM benchmark")
    parser.add_argument("--ref-co", type=str, default=None,
                        help="Reference .co for comparison (primus v26.2)")
    parser.add_argument("--custom-co", type=str, default=None,
                        help="Custom .co to benchmark (must have same kernel interface)")
    parser.add_argument("--kernel", type=str, default=None,
                        help="Custom .s file to assemble and benchmark")
    parser.add_argument("--site", type=str, default="all",
                        choices=list(SITES.keys()) + ["all"])
    parser.add_argument("--correctness", action="store_true")
    parser.add_argument("--benchmark", action="store_true")
    parser.add_argument("--warmup", type=int, default=20)
    parser.add_argument("--iters", type=int, default=50)
    args = parser.parse_args()

    if not args.correctness and not args.benchmark:
        args.correctness = True
        args.benchmark = True

    sites = list(SITES.keys()) if args.site == "all" else [args.site]

    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"CUs: {torch.cuda.get_device_properties(0).multi_processor_count}")
    print(f"E={E}, M_total={M_TOTAL}, F={F_DIM}, 2F={F2_DIM}")
    print(f"Config: {BEST_CONFIG}")

    group_lens = make_group_lens(E, M_TOTAL)
    group_offs = make_group_offs(group_lens)

    # Load ref .co if provided
    ref_func = None
    if args.ref_co:
        hip = _load_hip()
        with open(args.ref_co, 'rb') as f:
            data = f.read()
        mod = ctypes.c_void_p()
        _check(hip.hipModuleLoadData(ctypes.byref(mod), data), f"loading {args.ref_co}")
        ref_func = ctypes.c_void_p()
        _check(hip.hipModuleGetFunction(
            ctypes.byref(ref_func), mod, b"_grouped_variable_k_gemm_kernel"))
        print(f"Loaded ref: {args.ref_co}")

    # Load custom .co if provided (or assemble from .s)
    custom_func = None
    custom_block_size = 1024
    if args.kernel:
        patch_base = args.ref_co if args.ref_co else "kernels/dot_scaled_compiled.co"
        co_path = assemble_kernel(args.kernel, patch_base)
        args.custom_co = co_path
    if args.custom_co:
        hip = _load_hip()
        with open(args.custom_co, 'rb') as f:
            data = f.read()
        mod = ctypes.c_void_p()
        _check(hip.hipModuleLoadData(ctypes.byref(mod), data), f"loading {args.custom_co}")
        custom_func = ctypes.c_void_p()
        import subprocess as _sp
        _elf = _sp.run(["/opt/rocm/llvm/bin/llvm-readelf", "-s", "--wide", args.custom_co],
                       capture_output=True, text=True)
        _sym = None
        for _line in _elf.stdout.splitlines():
            if "FUNC" in _line and "GLOBAL" in _line:
                _sym = _line.split()[-1].encode()
                break
        if _sym is None:
            _sym = b"grouped_variable_k_dot_scaled_kernel"
        _check(hip.hipModuleGetFunction(ctypes.byref(custom_func), mod, _sym))
        if b"dot_scaled" not in _sym:
            custom_block_size = 512
        print(f"Loaded custom: {args.custom_co} (kernel={_sym.decode()})")

    results = []

    for site_name in sites:
        site = SITES[site_name]
        OUT_M, OUT_N = site["OUT_M"], site["OUT_N"]
        flops = 2 * M_TOTAL * OUT_M * OUT_N

        print(f"\n{'='*70}")
        print(f"{site_name}: {site['desc']}")
        print(f"M={M_TOTAL}, OUT_M={OUT_M}, OUT_N={OUT_N}, FLOPs={flops/1e12:.2f} TFLOP")
        print(f"{'='*70}")

        torch.manual_seed(42)
        lhs_fp8 = torch.randn(M_TOTAL, OUT_M, device='cuda', dtype=torch.bfloat16).to(torch.float8_e4m3fnuz)
        rhs_fp8 = torch.randn(M_TOTAL, OUT_N, device='cuda', dtype=torch.bfloat16).to(torch.float8_e5m2fnuz)
        lhs = lhs_fp8.view(torch.uint8)
        rhs = rhs_fp8.view(torch.uint8)
        lhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
        rhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")

        # ── Correctness ──
        if args.correctness:
            out = run_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, E)
            torch.cuda.synchronize()

            ref = torch_reference(lhs_fp8, rhs_fp8, group_offs, OUT_M, OUT_N, E, lhs_scale, rhs_scale)
            af = out.float().flatten()
            bf = ref.float().flatten()
            cos = (torch.dot(af, bf) / (af.norm() * bf.norm() + 1e-12)).item()
            max_diff = (out.float() - ref.float()).abs().max().item()
            status = "PASS" if cos >= 0.999 else "FAIL"
            print(f"\n  Correctness vs torch: [{status}] cos={cos:.6f}  max_diff={max_diff:.6f}")

        # ── Benchmark ──
        if args.benchmark:
            ds_ms = bench_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs,
                                     OUT_M, OUT_N, E, args.warmup, args.iters)
            ds_tflops = flops / (ds_ms * 1e-3) / 1e12

            ref_ms, ref_tflops = None, None
            if ref_func is not None:
                ref_out = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=torch.bfloat16)
                ref_ms = bench_ref_co(ref_func, lhs, rhs, ref_out, lhs_scale, rhs_scale,
                                      group_offs, OUT_M, OUT_N, args.warmup, args.iters)
                ref_tflops = flops / (ref_ms * 1e-3) / 1e12

            custom_ms, custom_tflops = None, None
            if custom_func is not None:
                custom_out = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=torch.bfloat16)
                custom_ms = bench_custom_co(custom_func, lhs, rhs, custom_out, lhs_scale, rhs_scale,
                                            group_offs, OUT_M, OUT_N, args.warmup, args.iters,
                                            block_size=custom_block_size)
                custom_tflops = flops / (custom_ms * 1e-3) / 1e12
                if args.correctness:
                    custom_out2 = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=torch.bfloat16)
                    custom_out2.zero_()
                    hip = _load_hip()
                    cargs = [
                        _ptr(lhs), _ptr(rhs), _ptr(custom_out2),
                        _ptr(lhs_scale), _ptr(rhs_scale), _ptr(group_offs),
                        _i32(E), _i32(OUT_M), _i32(OUT_N),
                        _i32(lhs.stride(0)), _i32(rhs.stride(0)),
                        _i32(custom_out2.stride(0)), _i32(custom_out2.stride(1)), _i32(custom_out2.stride(2)),
                        ctypes.c_void_p(0), ctypes.c_void_p(0),
                    ]
                    cpacked, _cs = _pack(*cargs)
                    _check(hip.hipModuleLaunchKernel(
                        custom_func, torch.cuda.get_device_properties(0).multi_processor_count,
                        1, 1, custom_block_size, 1, 1, 65536, None, cpacked, None))
                    hip.hipDeviceSynchronize()
                    if ref_func is not None and custom_block_size == 512:
                        compare_out = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=torch.bfloat16)
                        ref_args = [
                            _ptr(lhs), _ptr(rhs), _ptr(compare_out),
                            _ptr(lhs_scale), _ptr(rhs_scale), _ptr(group_offs),
                            _i32(E), _i32(OUT_M), _i32(OUT_N),
                            _i32(lhs.stride(0)), _i32(rhs.stride(0)),
                            _i32(compare_out.stride(0)), _i32(compare_out.stride(1)), _i32(compare_out.stride(2)),
                            ctypes.c_void_p(0), ctypes.c_void_p(0),
                        ]
                        rpacked, _rs = _pack(*ref_args)
                        _check(hip.hipModuleLaunchKernel(
                            ref_func, torch.cuda.get_device_properties(0).multi_processor_count,
                            1, 1, 512, 1, 1, 65536, None, rpacked, None))
                        hip.hipDeviceSynchronize()
                        compare_label = "Custom vs ref .co"
                    else:
                        compare_out = run_dot_scaled(lhs, rhs, lhs_scale, rhs_scale, group_offs, OUT_M, OUT_N, E)
                        torch.cuda.synchronize()
                        compare_label = "Custom vs Triton"
                    af = custom_out2.float().flatten()
                    bf = compare_out.float().flatten()
                    cos = (torch.dot(af, bf) / (af.norm() * bf.norm() + 1e-12)).item()
                    max_diff = (custom_out2.float() - compare_out.float()).abs().max().item()
                    status = "PASS" if cos >= 0.999 else "FAIL"
                    print(f"  {compare_label}: [{status}] cos={cos:.6f}  max_diff={max_diff:.6f}")

            print(f"\n  dot_scaled:    {ds_ms:8.3f} ms  {ds_tflops:7.1f} TFLOPS")
            if custom_ms is not None:
                speedup_custom = ds_ms / custom_ms
                print(f"  custom ASM:    {custom_ms:8.3f} ms  {custom_tflops:7.1f} TFLOPS  ({speedup_custom:.3f}x vs Triton)")
            if ref_ms is not None:
                speedup = ref_ms / ds_ms
                print(f"  ref .co:       {ref_ms:8.3f} ms  {ref_tflops:7.1f} TFLOPS")
                print(f"  speedup:       {speedup:.3f}x")
                results.append({"site": site_name, "ds_ms": ds_ms, "ds_tflops": ds_tflops,
                                "ref_ms": ref_ms, "ref_tflops": ref_tflops, "speedup": speedup})
            else:
                results.append({"site": site_name, "ds_ms": ds_ms, "ds_tflops": ds_tflops,
                                "custom_ms": custom_ms, "custom_tflops": custom_tflops})

    # ── Summary ──
    if len(results) > 1 and args.benchmark:
        print(f"\n{'='*70}")
        print(f"{'Site':<20s} {'dot_scaled ms':>14s} {'TFLOPS':>8s}", end="")
        if ref_func:
            print(f" {'ref ms':>10s} {'TFLOPS':>8s} {'speedup':>8s}")
        else:
            print()
        print("-" * 70)
        for r in results:
            print(f"{r['site']:<20s} {r['ds_ms']:14.3f} {r['ds_tflops']:8.1f}", end="")
            if 'ref_ms' in r:
                print(f" {r['ref_ms']:10.3f} {r['ref_tflops']:8.1f} {r['speedup']:7.3f}x")
            else:
                print()
        print(f"{'='*70}")


if __name__ == "__main__":
    main()
