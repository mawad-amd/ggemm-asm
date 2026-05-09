# ggemm-asm

Hand-optimized FP8 grouped GEMM kernels for MI355X (gfx950).

Target: GPT-OSS 20B MoE wgrad sites (variable-K kernel, `v_mfma_f32_16x16x32_fp8_bf8`).

## Setup

Docker container: `rocm/primus:v26.2` on MI355X (gfx950).

```bash
docker run --rm --network=host --device=/dev/kfd --device=/dev/dri \
  --group-add video --ipc=host --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -v $(pwd):/workspace/ggemm-asm \
  --entrypoint /bin/bash rocm/primus:v26.2 -c "
cd /workspace/ggemm-asm
export HIP_VISIBLE_DEVICES=0
python3 bench.py --kernel kernels/variable_k_wgrad_opt.s \
  --ref-co kernels/variable_k_gemm_ref.co --site gate_up_wgrad --c-bench
"
```

## Usage

```bash
# Correctness + benchmark with C launcher (recommended)
python3 bench.py --kernel kernels/variable_k_wgrad_opt.s \
  --ref-co kernels/variable_k_gemm_ref.co --site gate_up_wgrad --c-bench

# Correctness only
python3 bench.py --kernel kernels/variable_k_wgrad_opt.s \
  --ref-co kernels/variable_k_gemm_ref.co --site gate_up_wgrad --correctness

# Standalone C launcher (timing only, no correctness)
hipcc -O3 -o launcher launcher.cpp
./launcher kernels/variable_k_wgrad_opt.co --site gate_up_wgrad --warmup 50 --iters 200

# Triton baseline
python3 bench.py --triton-only --site all_wgrad
```

## Wgrad Call Sites

| Site | Shape | Dtypes | MFMA |
|------|-------|--------|------|
| gate_up_wgrad | M=131072 OUT_M=2880 OUT_N=5760 | e4m3 x e5m2 | 16x16x32_fp8_bf8 |
| down_wgrad | M=131072 OUT_M=2880 OUT_N=2880 | e4m3 x e5m2 | 16x16x32_fp8_bf8 |

E=32 experts, M_total=131072 tokens.

## Performance (MI355X, gfx950, Primus Turbo v26.2)

gate_up_wgrad, C launcher, warmup=50, iters=200.

| Kernel | ms | TFLOPS | vs Ref |
|--------|----|--------|--------|
| Triton (Python bench loop) | 3.875 | 1122 | — |
| Ref ASM (C launcher) | 3.567 | 1219 | baseline |
| **Opt ASM (C launcher)** | **3.515** | **1237** | **+1.5%** |

Correctness: PASS (cos=1.000002, bit-identical to Triton reference).

## Files

```
kernels/
  variable_k_gemm_ref.co   # Triton-compiled reference (Primus Turbo v26.2)
  variable_k_gemm_ref.s    # Disassembled reference
  variable_k_wgrad_opt.s   # Optimized: ds_read_b64_tr_b8 hoist to hide LDS latency
bench.py                   # Correctness + benchmark harness (Python, uses Triton ref)
launcher.cpp               # Standalone C benchmark (HIP, no Python overhead)
tools/
  disasm_to_asm.py          # llvm-objdump output -> assembleable .s
  patch_co.py               # Splice new .text into reference .co
```

## Workflow

1. Edit `kernels/variable_k_wgrad_opt.s`
2. `bench.py --kernel opt.s --ref-co ref.co --site gate_up_wgrad --c-bench`
   - Assembles .s via llvm-mc
   - Patches .text into ref .co (preserves kernel descriptor)
   - Runs correctness vs Triton
   - Benchmarks via compiled C launcher
3. Iterate

## Arg Layout (variable-K kernel)

```
LHS (ptr), RHS (ptr), C (ptr), LHS_scale (ptr), RHS_scale (ptr), group_offs (ptr),
G (i32), OUT_M (i32), OUT_N (i32), stride_lhs_m (i32), stride_rhs_m (i32),
stride_cg (i32), stride_cm (i32), stride_cn (i32),
global_scratch (ptr, nullptr), profile_scratch (ptr, nullptr)
```

Grid: `(num_cus, 1, 1)`, Block: `(512, 1, 1)`, Shared: `65536`
