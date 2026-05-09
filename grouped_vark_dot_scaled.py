"""
Variable-K grouped GEMM using tl.dot_scaled for MI355X (gfx950).

Replaces the legacy v_mfma_f32_16x16x32_fp8_bf8 with v_mfma_f32_32x32x64_f8f6f4
via Triton's tl.dot_scaled API. The scaled MFMA processes 2x the K elements per
instruction, giving ~60% higher throughput on the wgrad GEMM shapes.

Key detail: tl.dot_scaled interprets FP8 bytes as OCP format (bias=7 for e4m3,
bias=15 for e5m2), but primus/torch data uses fnuz (bias=8, bias=16). Each
operand reads as 2x the intended value, so the product is 4x too large.
Fix: multiply combined_scale by 0.25.

Interface matches primus_turbo's variable-K kernel:
  LHS, RHS, C, LHS_scale_ptr, RHS_scale_ptr, group_offs_ptr,
  G, OUT_M, OUT_N, stride_lhs_m, stride_rhs_m, stride_cg, stride_cm, stride_cn
"""
import triton
import triton.language as tl


@triton.jit
def grouped_variable_k_dot_scaled_kernel(
    LHS, RHS, C,
    LHS_scale_ptr, RHS_scale_ptr,
    group_offs_ptr,
    G, OUT_M, OUT_N,
    stride_lhs_m, stride_rhs_m,
    stride_cg, stride_cm, stride_cn,
    NUM_SMS: tl.constexpr,
    BLOCK_M: tl.constexpr, BLOCK_N: tl.constexpr, BLOCK_K: tl.constexpr,
    GROUP_M: tl.constexpr,
):
    pid = tl.program_id(0)

    # XCD-aware tile reordering (8 XCDs on MI355X)
    NUM_XCDS: tl.constexpr = 8
    if pid < NUM_SMS:
        xcd = pid % NUM_XCDS
        local_pid = pid // NUM_XCDS
        tiles_per_xcd = NUM_SMS // NUM_XCDS
        pid = xcd * tiles_per_xcd + local_pid % tiles_per_xcd

    tiles_m = tl.cdiv(OUT_M, BLOCK_M)
    tiles_n = tl.cdiv(OUT_N, BLOCK_N)
    tiles_per_group = tiles_m * tiles_n
    total_tiles = G * tiles_per_group

    lhs_scale = tl.load(LHS_scale_ptr).to(tl.float32)
    rhs_scale = tl.load(RHS_scale_ptr).to(tl.float32)
    # fnuz->OCP correction: each operand interpreted as 2x, product is 4x
    combined_scale = lhs_scale * rhs_scale * 0.25

    num_pid_in_group = tiles_n * GROUP_M

    # Persistent loop: each CU processes multiple tiles
    for global_tile in range(pid, total_tiles, NUM_SMS):
        group_idx = global_tile // tiles_per_group
        local_tile = global_tile - group_idx * tiles_per_group

        # Swizzle for L2 locality
        swizzle_group = local_tile // num_pid_in_group
        first_pid_m = swizzle_group * GROUP_M
        group_size_m = min(tiles_m - first_pid_m, GROUP_M)
        pid_in_group = local_tile % num_pid_in_group
        pid_m = first_pid_m + pid_in_group % group_size_m
        pid_n = pid_in_group // group_size_m

        # Group boundaries from offset table
        k_start = tl.load(group_offs_ptr + group_idx).to(tl.int32)
        k_end = tl.load(group_offs_ptr + group_idx + 1).to(tl.int32)
        k_len = k_end - k_start

        rm = pid_m * BLOCK_M + tl.arange(0, BLOCK_M)
        rn = pid_n * BLOCK_N + tl.arange(0, BLOCK_N)
        rk = tl.arange(0, BLOCK_K)

        mask_m = rm < OUT_M
        mask_n = rn < OUT_N

        # Transposed access: A[m, k] = LHS[k_start+k, m]
        A_BASE = LHS + k_start * stride_lhs_m + rm[:, None] + rk[None, :] * stride_lhs_m
        # Normal access: B[k, n] = RHS[k_start+k, n]
        B_BASE = RHS + k_start * stride_rhs_m + rk[:, None] * stride_rhs_m + rn[None, :]

        acc = tl.zeros((BLOCK_M, BLOCK_N), dtype=tl.float32)
        k_stride_a = BLOCK_K * stride_lhs_m
        k_stride_b = BLOCK_K * stride_rhs_m

        loop_k = tl.cdiv(k_len, BLOCK_K)
        for k in range(loop_k):
            k_remaining = k_len - k * BLOCK_K
            mask_k = rk < k_remaining
            a = tl.load(A_BASE, mask=mask_m[:, None] & mask_k[None, :], other=0.0)
            b = tl.load(B_BASE, mask=mask_k[:, None] & mask_n[None, :], other=0.0)
            acc = tl.dot_scaled(a, None, "e4m3", b, None, "e5m2", acc=acc)
            A_BASE += k_stride_a
            B_BASE += k_stride_b

        acc = acc * combined_scale

        c_ptr = C + group_idx * stride_cg + rm[:, None] * stride_cm + rn[None, :] * stride_cn
        c_mask = mask_m[:, None] & mask_n[None, :]
        tl.store(c_ptr, acc.to(tl.bfloat16), mask=c_mask)
