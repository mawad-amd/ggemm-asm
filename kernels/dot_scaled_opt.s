.amdgcn_target "amdgcn-amd-amdhsa--gfx950"

.text
.globl grouped_variable_k_dot_scaled_kernel
.p2align 8
.type grouped_variable_k_dot_scaled_kernel,@function
grouped_variable_k_dot_scaled_kernel:
	s_load_dwordx2 s[2:3], s[0:1], 0x0
	s_load_dwordx8 s[4:11], s[0:1], 0x8
	s_load_dwordx4 s[12:15], s[0:1], 0x28
	s_waitcnt lgkmcnt(0)
	s_branch .L0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
.L0:
	s_load_dword s17, s[0:1], 0x38
	s_mov_b64 s[20:21], s[6:7]
	s_mov_b64 s[24:25], s[2:3]
	s_cmpk_gt_i32 s16, 0xff
	v_readfirstlane_b32 s3, v0
	s_cbranch_scc1 .L1
	s_ashr_i32 s2, s16, 31
	s_lshr_b32 s2, s2, 29
	s_add_i32 s2, s16, s2
	s_ashr_i32 s6, s2, 3
	s_and_b32 s7, s2, 0x7fffff8
	s_ashr_i32 s2, s2, 31
	s_lshr_b32 s2, s2, 27
	s_add_i32 s2, s6, s2
	s_sub_i32 s7, s16, s7
	s_andn2_b32 s2, s2, 31
	s_lshl_b32 s7, s7, 5
	s_sub_i32 s2, s6, s2
	s_add_i32 s16, s7, s2
.L1:
	s_add_i32 s2, s15, 0xff
	s_ashr_i32 s6, s2, 31
	s_lshr_b32 s6, s6, 24
	s_add_i32 s2, s2, s6
	s_ashr_i32 s33, s2, 8
	s_waitcnt lgkmcnt(0)
	s_add_i32 s2, s17, 0xff
	s_ashr_i32 s6, s2, 31
	s_lshr_b32 s6, s6, 24
	s_add_i32 s2, s2, s6
	s_ashr_i32 s2, s2, 8
	s_mul_i32 s34, s2, s33
	s_mul_i32 s14, s34, s14
	s_cmp_ge_i32 s16, s14
	s_cbranch_scc1 .L7
	s_load_dwordx4 s[28:31], s[0:1], 0x3c
	s_lshr_b32 s0, s3, 3
	v_lshlrev_b32_e32 v1, 4, v0
	s_and_b32 s40, s0, 0x60
	s_lshr_b32 s0, s3, 1
	v_and_b32_e32 v6, 0xf0, v1
	s_and_b32 s41, s0, 0x60
	v_lshrrev_b32_e32 v1, 2, v0
	v_and_or_b32 v75, v1, 8, s41
	v_and_b32_e32 v1, 48, v0
	s_lshr_b32 s0, s3, 6
	v_and_or_b32 v80, s0, 15, v1
	s_load_dword s0, s[10:11], 0x0
	s_load_dword s1, s[8:9], 0x0
	v_or_b32_e32 v81, 64, v80
	v_and_or_b32 v76, v0, 31, s40
	v_or_b32_e32 v77, 16, v75
	s_waitcnt lgkmcnt(0)
	v_mov_b32_e32 v1, s0
	v_mul_f32_e32 v1, s1, v1
	v_mad_u64_u32 v[2:3], s[0:1], v80, s28, v[6:7]
	scratch_store_dwordx2 off, v[2:3], off
	v_mad_u64_u32 v[2:3], s[0:1], v81, s28, v[6:7]
	scratch_store_dwordx2 off, v[2:3], off offset:8
	v_mad_u64_u32 v[2:3], s[0:1], v80, s29, v[6:7]
	scratch_store_dwordx2 off, v[2:3], off offset:16
	v_mad_u64_u32 v[2:3], s[0:1], v81, s29, v[6:7]
	s_lshl_b32 s0, s3, 4
	s_and_b32 s0, s0, 0x3c00
	v_mul_f32_e32 v124, 0x3e800000, v1
	s_lshr_b32 s44, s0, 5
	v_lshlrev_b32_e32 v1, 9, v0
	scratch_store_dwordx2 off, v[2:3], off offset:24
	s_or_b32 s44, s44, s0
	v_and_b32_e32 v1, 0x1c00, v1
	v_lshlrev_b32_e32 v2, 3, v0
	v_and_b32_e32 v72, 16, v0
	s_movk_i32 s0, 0x108
	v_mul_lo_u32 v0, v76, s31
	v_or_b32_e32 v78, 0x80, v75
	v_or_b32_e32 v79, 0x90, v75
	v_and_or_b32 v64, v2, s0, v1
	v_add_u32_e32 v2, v77, v0
	v_add_u32_e32 v127, v0, v75
	scratch_store_dword off, v2, off offset:40
	v_add_u32_e32 v2, v78, v0
	v_add_u32_e32 v0, v79, v0
	s_abs_i32 s49, s34
	v_or_b32_e32 v74, 0x80, v76
	scratch_store_dword off, v0, off offset:48
	v_cvt_f32_u32_e32 v0, s49
	v_lshrrev_b32_e32 v73, 5, v1
	v_mul_lo_u32 v1, v74, s31
	scratch_store_dword off, v2, off offset:44
	v_add_u32_e32 v2, v1, v75
	s_lshl_b32 s35, s2, 2
	scratch_store_dword off, v2, off offset:52
	v_add_u32_e32 v2, v1, v77
	scratch_store_dword off, v2, off offset:56
	v_add_u32_e32 v2, v1, v78
	v_rcp_iflag_f32_e32 v0, v0
	v_add_u32_e32 v1, v1, v79
	s_abs_i32 s50, s35
	scratch_store_dword off, v1, off offset:64
	v_cvt_f32_u32_e32 v1, s50
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	s_sub_i32 s0, 0, s49
	v_rcp_iflag_f32_e32 v1, v1
	s_mov_b32 s27, 0x27000
	v_readfirstlane_b32 s1, v0
	s_mul_i32 s0, s0, s1
	v_mul_f32_e32 v0, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v0, v0
	s_mul_hi_u32 s0, s1, s0
	s_add_i32 s52, s1, s0
	s_sub_i32 s0, 0, s50
	v_readfirstlane_b32 s1, v0
	s_mul_i32 s0, s0, s1
	s_mov_b32 s26, 0x7ffffffe
	s_add_i32 s45, s44, 0
	s_and_b32 s5, s5, 0xffff
	s_mul_hi_u32 s0, s1, s0
	s_lshl_b32 s42, s28, 7
	s_lshl_b32 s43, s29, 7
	s_and_b32 s25, s25, 0xffff
	s_add_i32 s46, s45, 0x4200
	s_add_i32 s47, s45, 0x107e0
	s_add_i32 s48, s45, 0x149e0
	s_and_b32 s21, s21, 0xffff
	v_mov_b32_e32 v125, v124
	s_ashr_i32 s51, s34, 31
	s_bfe_i32 s53, s2, 0x1001d
	s_add_i32 s54, s1, s0
	v_bfrev_b32_e32 v90, 1
	s_mov_b32 s36, s4
	s_mov_b32 s37, s5
	s_mov_b32 s38, s26
	s_mov_b32 s39, s27
	v_mov_b32_e32 v126, v64
	v_mov_b32_e32 v0, v6
	scratch_store_dword off, v2, off offset:60
	scratch_store_dwordx2 off, v[0:1], off offset:32
	scratch_store_dword off, v76, off offset:68
	scratch_store_dword off, v77, off offset:72
	scratch_store_dword off, v78, off offset:76
	scratch_store_dword off, v79, off offset:80
	scratch_store_dword off, v75, off offset:84
	scratch_store_dword off, v74, off offset:88
	scratch_store_dword off, v127, off offset:92
	s_branch .L3
.L2:
	s_mul_i32 s18, s18, s30
	v_or_b32_e32 v68, s19, v76
	v_or_b32_e32 v82, s19, v74
	v_or_b32_e32 v83, s55, v75
	s_mul_i32 s19, s19, s31
	s_add_i32 s18, s55, s18
	v_or_b32_e32 v84, s55, v77
	v_or_b32_e32 v85, s55, v78
	v_or_b32_e32 v86, s55, v79
	v_cmp_gt_i32_e64 s[10:11], s15, v68
	v_cmp_gt_i32_e64 s[8:9], s17, v83
	v_pk_mul_f32 v[32:33], v[124:125], v[32:33]
	v_pk_mul_f32 v[34:35], v[124:125], v[34:35]
	v_pk_mul_f32 v[36:37], v[124:125], v[36:37]
	v_pk_mul_f32 v[38:39], v[124:125], v[38:39]
	s_add_i32 s55, s18, s19
	v_cmp_gt_i32_e32 vcc, s15, v82
	v_cmp_gt_i32_e64 s[6:7], s17, v84
	v_cmp_gt_i32_e64 s[2:3], s17, v85
	v_pk_mul_f32 v[82:83], v[124:125], v[0:1]
	v_pk_mul_f32 v[84:85], v[124:125], v[2:3]
	v_cvt_pk_bf16_f32 v0, v32, v33
	v_cvt_pk_bf16_f32 v1, v34, v35
	v_cvt_pk_bf16_f32 v2, v36, v37
	v_cvt_pk_bf16_f32 v3, v38, v39
	v_add_lshl_u32 v32, s55, v127, 1
	s_and_b64 s[18:19], s[10:11], s[8:9]
	v_permlane32_swap_b32_e32 v0, v2
	v_permlane32_swap_b32_e32 v1, v3
	v_cndmask_b32_e64 v32, v90, v32, s[18:19]
	s_mov_b32 s22, s26
	s_mov_b32 s23, s27
	buffer_store_dwordx4 v[0:3], v32, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:40
	v_pk_mul_f32 v[40:41], v[124:125], v[40:41]
	v_pk_mul_f32 v[42:43], v[124:125], v[42:43]
	v_pk_mul_f32 v[44:45], v[124:125], v[44:45]
	v_pk_mul_f32 v[46:47], v[124:125], v[46:47]
	v_cmp_gt_i32_e64 s[0:1], s17, v86
	v_pk_mul_f32 v[86:87], v[124:125], v[4:5]
	v_pk_mul_f32 v[88:89], v[124:125], v[6:7]
	v_cvt_pk_bf16_f32 v4, v40, v41
	v_cvt_pk_bf16_f32 v5, v42, v43
	v_cvt_pk_bf16_f32 v6, v44, v45
	v_cvt_pk_bf16_f32 v7, v46, v47
	s_and_b64 s[18:19], s[10:11], s[6:7]
	v_permlane32_swap_b32_e32 v4, v6
	v_permlane32_swap_b32_e32 v5, v7
	v_pk_mul_f32 v[48:49], v[124:125], v[48:49]
	v_pk_mul_f32 v[50:51], v[124:125], v[50:51]
	v_pk_mul_f32 v[52:53], v[124:125], v[52:53]
	v_pk_mul_f32 v[54:55], v[124:125], v[54:55]
	v_pk_mul_f32 v[92:93], v[124:125], v[8:9]
	v_pk_mul_f32 v[94:95], v[124:125], v[10:11]
	v_cvt_pk_bf16_f32 v8, v48, v49
	v_cvt_pk_bf16_f32 v9, v50, v51
	v_cvt_pk_bf16_f32 v10, v52, v53
	v_cvt_pk_bf16_f32 v11, v54, v55
	s_nop 0
	v_permlane32_swap_b32_e32 v8, v10
	v_permlane32_swap_b32_e32 v9, v11
	v_pk_mul_f32 v[56:57], v[124:125], v[56:57]
	v_pk_mul_f32 v[58:59], v[124:125], v[58:59]
	v_pk_mul_f32 v[60:61], v[124:125], v[60:61]
	v_pk_mul_f32 v[62:63], v[124:125], v[62:63]
	v_pk_mul_f32 v[96:97], v[124:125], v[12:13]
	v_pk_mul_f32 v[98:99], v[124:125], v[14:15]
	v_cvt_pk_bf16_f32 v12, v56, v57
	v_cvt_pk_bf16_f32 v13, v58, v59
	v_cvt_pk_bf16_f32 v14, v60, v61
	v_cvt_pk_bf16_f32 v15, v62, v63
	s_nop 0
	v_permlane32_swap_b32_e32 v12, v14
	v_permlane32_swap_b32_e32 v13, v15
	v_pk_mul_f32 v[16:17], v[124:125], v[16:17]
	v_pk_mul_f32 v[18:19], v[124:125], v[18:19]
	v_pk_mul_f32 v[20:21], v[124:125], v[20:21]
	v_pk_mul_f32 v[22:23], v[124:125], v[22:23]
	v_cvt_pk_bf16_f32 v16, v16, v17
	v_cvt_pk_bf16_f32 v17, v18, v19
	v_cvt_pk_bf16_f32 v18, v20, v21
	v_cvt_pk_bf16_f32 v19, v22, v23
	s_and_b64 s[8:9], vcc, s[8:9]
	v_permlane32_swap_b32_e32 v16, v18
	v_permlane32_swap_b32_e32 v17, v19
	v_pk_mul_f32 v[24:25], v[124:125], v[24:25]
	v_pk_mul_f32 v[26:27], v[124:125], v[26:27]
	v_pk_mul_f32 v[28:29], v[124:125], v[28:29]
	v_pk_mul_f32 v[30:31], v[124:125], v[30:31]
	v_cvt_pk_bf16_f32 v20, v24, v25
	v_cvt_pk_bf16_f32 v21, v26, v27
	v_cvt_pk_bf16_f32 v22, v28, v29
	v_cvt_pk_bf16_f32 v23, v30, v31
	s_and_b64 s[6:7], vcc, s[6:7]
	v_permlane32_swap_b32_e32 v20, v22
	v_permlane32_swap_b32_e32 v21, v23
	v_cvt_pk_bf16_f32 v24, v82, v83
	v_cvt_pk_bf16_f32 v25, v84, v85
	v_cvt_pk_bf16_f32 v26, v86, v87
	v_cvt_pk_bf16_f32 v27, v88, v89
	s_nop 0
	v_permlane32_swap_b32_e32 v24, v26
	v_permlane32_swap_b32_e32 v25, v27
	v_cvt_pk_bf16_f32 v28, v92, v93
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, v0, s55, 1
	v_cndmask_b32_e64 v0, v90, v0, s[18:19]
	buffer_store_dwordx4 v[4:7], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:44
	s_and_b64 s[18:19], s[10:11], s[2:3]
	scratch_load_dwordx2 v[6:7], off, off offset:32
	s_and_b64 s[10:11], s[10:11], s[0:1]
	s_and_b64 s[2:3], vcc, s[2:3]
	v_cvt_pk_bf16_f32 v29, v94, v95
	v_cvt_pk_bf16_f32 v30, v96, v97
	v_cvt_pk_bf16_f32 v31, v98, v99
	s_and_b64 vcc, vcc, s[0:1]
	s_addk_i32 s16, 0x100
	v_permlane32_swap_b32_e32 v28, v30
	v_permlane32_swap_b32_e32 v29, v31
	s_cmp_lt_i32 s16, s14
	s_waitcnt vmcnt(1)
	v_add_lshl_u32 v0, v0, s55, 1
	v_cndmask_b32_e64 v0, v90, v0, s[18:19]
	buffer_store_dwordx4 v[8:11], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:48
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, v0, s55, 1
	v_cndmask_b32_e64 v0, v90, v0, s[10:11]
	buffer_store_dwordx4 v[12:15], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:52
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, s55, v0, 1
	v_cndmask_b32_e64 v0, v90, v0, s[8:9]
	buffer_store_dwordx4 v[16:19], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:56
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, s55, v0, 1
	v_cndmask_b32_e64 v0, v90, v0, s[6:7]
	buffer_store_dwordx4 v[20:23], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:60
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, s55, v0, 1
	v_cndmask_b32_e64 v0, v90, v0, s[2:3]
	buffer_store_dwordx4 v[24:27], v0, s[20:23], 0 offen
	scratch_load_dword v0, off, off offset:64
	s_waitcnt vmcnt(0)
	v_add_lshl_u32 v0, s55, v0, 1
	v_cndmask_b32_e32 v0, v90, v0, vcc
	buffer_store_dwordx4 v[28:31], v0, s[20:23], 0 offen
	s_cbranch_scc0 .L7
.L3:
	s_abs_i32 s1, s16
	s_mul_hi_u32 s2, s1, s52
	s_mul_i32 s3, s2, s49
	s_ashr_i32 s0, s16, 31
	s_sub_i32 s1, s1, s3
	s_xor_b32 s0, s0, s51
	s_add_i32 s3, s2, 1
	s_sub_i32 s6, s1, s49
	s_cmp_ge_u32 s1, s49
	s_cselect_b32 s2, s3, s2
	s_cselect_b32 s1, s6, s1
	s_add_i32 s3, s2, 1
	s_cmp_ge_u32 s1, s49
	s_cselect_b32 s1, s3, s2
	s_xor_b32 s1, s1, s0
	s_sub_i32 s18, s1, s0
	s_mul_i32 s0, s18, s34
	s_sub_i32 s0, s16, s0
	s_abs_i32 s2, s0
	s_mul_hi_u32 s3, s2, s54
	s_mul_i32 s6, s3, s50
	s_ashr_i32 s1, s0, 31
	s_sub_i32 s2, s2, s6
	s_xor_b32 s1, s1, s53
	s_add_i32 s6, s3, 1
	s_sub_i32 s7, s2, s50
	s_cmp_ge_u32 s2, s50
	s_cselect_b32 s3, s6, s3
	s_cselect_b32 s2, s7, s2
	s_add_i32 s6, s3, 1
	s_cmp_ge_u32 s2, s50
	s_cselect_b32 s2, s6, s3
	s_xor_b32 s2, s2, s1
	s_sub_i32 s1, s2, s1
	s_lshl_b32 s2, s1, 2
	s_sub_i32 s3, s33, s2
	s_min_i32 s3, s3, 4
	s_abs_i32 s6, s3
	v_cvt_f32_u32_e32 v0, s6
	s_mul_i32 s1, s1, s35
	s_sub_i32 s7, 0, s6
	s_sub_i32 s0, s0, s1
	v_rcp_iflag_f32_e32 v0, v0
	s_xor_b32 s1, s0, s3
	s_ashr_i32 s8, s1, 31
	s_abs_i32 s1, s0
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	s_mov_b32 m0, s45
	scratch_load_dwordx2 v[4:5], off, off offset:24
	v_readfirstlane_b32 s9, v0
	s_mul_i32 s7, s7, s9
	s_mul_hi_u32 s7, s9, s7
	s_add_i32 s9, s9, s7
	s_mul_hi_u32 s7, s1, s9
	s_mul_i32 s9, s7, s6
	s_sub_i32 s1, s1, s9
	s_add_i32 s9, s7, 1
	s_sub_i32 s10, s1, s6
	s_cmp_ge_u32 s1, s6
	s_cselect_b32 s7, s9, s7
	s_cselect_b32 s1, s10, s1
	s_add_i32 s9, s7, 1
	s_cmp_ge_u32 s1, s6
	s_cselect_b32 s1, s9, s7
	s_xor_b32 s9, s1, s8
	s_sub_i32 s6, s9, s8
	s_mul_i32 s1, s6, s3
	s_sub_i32 s0, s0, s1
	s_ashr_i32 s19, s18, 31
	s_add_i32 s2, s0, s2
	s_lshl_b64 s[0:1], s[18:19], 3
	s_add_u32 s0, s12, s0
	s_addc_u32 s1, s13, s1
	v_mov_b32_e32 v0, 0
	global_load_dwordx4 v[0:3], v0, s[0:1]
	s_lshl_b32 s19, s2, 8
	s_lshl_b32 s55, s6, 8
	s_waitcnt vmcnt(0)
	v_or_b32_e32 v1, s19, v6
	v_or_b32_e32 v3, s55, v6
	v_cmp_gt_i32_e32 vcc, s15, v1
	v_cmp_gt_i32_e64 s[0:1], s17, v3
	v_readfirstlane_b32 s11, v0
	v_readfirstlane_b32 s2, v2
	scratch_load_dwordx2 v[0:1], off, off
	scratch_load_dwordx2 v[2:3], off, off offset:8
	s_sub_i32 s10, s2, s11
	s_mul_i32 s2, s11, s28
	s_add_i32 s22, s2, s19
	s_mul_i32 s3, s11, s29
	s_add_i32 s23, s3, s55
	s_add_i32 s56, s10, 0x7f
	v_cmp_gt_i32_e64 s[2:3], s10, v80
	s_cmpk_gt_i32 s56, 0x7f
	v_cmp_gt_i32_e64 s[6:7], s10, v81
	s_waitcnt vmcnt(1)
	v_add_u32_e32 v0, s22, v0
	s_waitcnt vmcnt(0)
	v_add_u32_e32 v1, s22, v2
	scratch_load_dwordx2 v[2:3], off, off offset:16
	s_waitcnt vmcnt(0)
	v_add_u32_e32 v3, s23, v4
	v_add_u32_e32 v2, s23, v2
	s_cselect_b64 s[22:23], -1, 0
	s_and_b64 s[58:59], vcc, s[2:3]
	s_and_b64 s[60:61], vcc, s[6:7]
	s_and_b64 s[62:63], s[0:1], s[2:3]
	s_and_b64 s[2:3], s[22:23], s[58:59]
	v_cndmask_b32_e64 v0, v90, v0, s[2:3]
	s_and_b64 s[2:3], s[22:23], s[60:61]
	s_and_b64 s[6:7], s[0:1], s[6:7]
	v_cndmask_b32_e64 v1, v90, v1, s[2:3]
	s_and_b64 s[2:3], s[22:23], s[62:63]
	buffer_load_dwordx4 v0, s[24:27], 0 offen lds
	s_mov_b32 m0, s46
	v_cndmask_b32_e64 v2, v90, v2, s[2:3]
	s_and_b64 s[2:3], s[22:23], s[6:7]
	buffer_load_dwordx4 v1, s[24:27], 0 offen lds
	s_mov_b32 m0, s47
	v_cndmask_b32_e64 v3, v90, v3, s[2:3]
	buffer_load_dwordx4 v2, s[36:39], 0 offen lds
	s_mov_b32 m0, s48
	s_cmpk_lt_i32 s56, 0x100
	buffer_load_dwordx4 v3, s[36:39], 0 offen lds
	s_cbranch_scc1 .L5
	v_lshl_or_b32 v1, s9, 8, v6
	s_lshl_b32 s3, s8, 8
	v_or_b32_e32 v0, 0xc0, v80
	v_subrev_u32_e32 v92, s3, v1
	v_or_b32_e32 v1, 0x80, v80
	s_lshr_b32 s2, s56, 7
	v_add_u32_e32 v0, s11, v0
	v_add_u32_e32 v1, s11, v1
	v_mov_b32_e32 v32, 0
	v_mul_lo_u32 v91, s29, v0
	v_mul_lo_u32 v93, s29, v1
	v_mul_lo_u32 v94, s28, v0
	v_add_u32_e32 v95, s19, v6
	v_mul_lo_u32 v96, s28, v1
	s_add_i32 s56, s2, -1
	s_mov_b32 s3, 0
	s_add_i32 s2, 0, 0x107e0
	s_add_i32 s57, s10, 0xffffff80
	s_mov_b32 s58, 0
	v_mov_b32_e32 v33, v32
	v_mov_b32_e32 v34, v32
	v_mov_b32_e32 v35, v32
	v_mov_b32_e32 v36, v32
	v_mov_b32_e32 v37, v32
	v_mov_b32_e32 v38, v32
	v_mov_b32_e32 v39, v32
	v_mov_b32_e32 v40, v32
	v_mov_b32_e32 v41, v32
	v_mov_b32_e32 v42, v32
	v_mov_b32_e32 v43, v32
	v_mov_b32_e32 v44, v32
	v_mov_b32_e32 v45, v32
	v_mov_b32_e32 v46, v32
	v_mov_b32_e32 v47, v32
	v_mov_b32_e32 v48, v32
	v_mov_b32_e32 v49, v32
	v_mov_b32_e32 v50, v32
	v_mov_b32_e32 v51, v32
	v_mov_b32_e32 v52, v32
	v_mov_b32_e32 v53, v32
	v_mov_b32_e32 v54, v32
	v_mov_b32_e32 v55, v32
	v_mov_b32_e32 v56, v32
	v_mov_b32_e32 v57, v32
	v_mov_b32_e32 v58, v32
	v_mov_b32_e32 v59, v32
	v_mov_b32_e32 v60, v32
	v_mov_b32_e32 v61, v32
	v_mov_b32_e32 v62, v32
	v_mov_b32_e32 v63, v32
	v_mov_b32_e32 v16, v32
	v_mov_b32_e32 v17, v32
	v_mov_b32_e32 v18, v32
	v_mov_b32_e32 v19, v32
	v_mov_b32_e32 v20, v32
	v_mov_b32_e32 v21, v32
	v_mov_b32_e32 v22, v32
	v_mov_b32_e32 v23, v32
	v_mov_b32_e32 v24, v32
	v_mov_b32_e32 v25, v32
	v_mov_b32_e32 v26, v32
	v_mov_b32_e32 v27, v32
	v_mov_b32_e32 v28, v32
	v_mov_b32_e32 v29, v32
	v_mov_b32_e32 v30, v32
	v_mov_b32_e32 v31, v32
	v_mov_b32_e32 v0, v32
	v_mov_b32_e32 v1, v32
	v_mov_b32_e32 v2, v32
	v_mov_b32_e32 v3, v32
	v_mov_b32_e32 v4, v32
	v_mov_b32_e32 v5, v32
	v_mov_b32_e32 v6, v32
	v_mov_b32_e32 v7, v32
	v_mov_b32_e32 v8, v32
	v_mov_b32_e32 v9, v32
	v_mov_b32_e32 v10, v32
	v_mov_b32_e32 v11, v32
	v_mov_b32_e32 v12, v32
	v_mov_b32_e32 v13, v32
	v_mov_b32_e32 v14, v32
	v_mov_b32_e32 v15, v32
	v_mov_b32_e32 v127, v80
	v_mov_b32_e32 v123, v81
.L4:
	v_add3_u32 v82, s3, v72, v64
	v_add3_u32 v83, s2, v72, v64
	v_add3_u32 v97, v82, s40, v73
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_barrier
	v_add3_u32 v122, v83, s41, v73
	ds_read_b64_tr_b8 v[82:83], v97
	ds_read_b64_tr_b8 v[86:87], v97 offset:512
	ds_read_b64_tr_b8 v[102:103], v97 offset:640
	ds_read_b64_tr_b8 v[98:99], v97 offset:128
	ds_read_b64_tr_b8 v[106:107], v122
	ds_read_b64_tr_b8 v[110:111], v122 offset:512
	ds_read_b64_tr_b8 v[108:109], v122 offset:8448
	ds_read_b64_tr_b8 v[112:113], v122 offset:8960
	ds_read_b64_tr_b8 v[84:85], v97 offset:8448
	ds_read_b64_tr_b8 v[88:89], v97 offset:8960
	ds_read_b64_tr_b8 v[104:105], v97 offset:9088
	ds_read_b64_tr_b8 v[100:101], v97 offset:8576
	ds_read_b64_tr_b8 v[118:119], v122 offset:640
	ds_read_b64_tr_b8 v[114:115], v122 offset:128
	ds_read_b64_tr_b8 v[120:121], v122 offset:9088
	ds_read_b64_tr_b8 v[116:117], v122 offset:8576
	s_add_i32 s10, s58, 1
	v_cmp_gt_i32_e64 s[2:3], s57, v127
	s_cmp_lt_i32 s10, 2
	s_waitcnt lgkmcnt(6)
	v_mfma_f32_32x32x64_f8f6f4 v[32:47], v[106:113], v[82:89], v[32:47] cbsz:1
	s_cselect_b32 s58, s10, 0
	s_and_b64 s[10:11], vcc, s[2:3]
	s_and_b64 s[2:3], s[0:1], s[2:3]
	v_cmp_gt_i32_e64 s[8:9], s57, v123
	s_mov_b32 s6, s26
	s_mov_b32 s7, s27
	s_add_i32 s56, s56, -1
	s_addk_i32 s57, 0xff80
	s_waitcnt lgkmcnt(4)
	v_mfma_f32_32x32x64_f8f6f4 v[16:31], v[106:113], v[98:105], v[16:31] cbsz:1
	v_add_u32_e32 v108, v93, v92
	v_add_u32_e32 v106, v96, v95
	ds_read_b64_tr_b8 v[110:111], v97 offset:16896
	v_add_u32_e32 v107, v94, v95
	v_add_u32_e32 v95, s42, v95
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_32x32x64_f8f6f4 v[0:15], v[114:121], v[98:105], v[0:15] cbsz:1
	v_cndmask_b32_e64 v100, v90, v108, s[2:3]
	s_lshl_b32 s2, s58, 15
	s_lshr_b32 s3, s2, 5
	s_add_i32 s3, s3, s2
	v_cndmask_b32_e64 v98, v90, v106, s[10:11]
	s_and_b64 s[10:11], vcc, s[8:9]
	s_and_b64 s[8:9], s[0:1], s[8:9]
	s_add_i32 s3, s3, 0
	s_add_i32 s2, s3, 0x107e0
	v_cndmask_b32_e64 v99, v90, v107, s[10:11]
	ds_read_b64_tr_b8 v[74:75], v122 offset:16896
	ds_read_b64_tr_b8 v[78:79], v122 offset:17408
	ds_read_b64_tr_b8 v[76:77], v122 offset:25344
	ds_read_b64_tr_b8 v[80:81], v122 offset:25856
	ds_read_b64_tr_b8 v[68:69], v122 offset:17536
	ds_read_b64_tr_b8 v[64:65], v122 offset:17024
	ds_read_b64_tr_b8 v[70:71], v122 offset:25984
	ds_read_b64_tr_b8 v[66:67], v122 offset:25472
	v_mfma_f32_32x32x64_f8f6f4 v[48:63], v[114:121], v[82:89], v[48:63] cbsz:1
	ds_read_b64_tr_b8 v[114:115], v97 offset:17408
	ds_read_b64_tr_b8 v[86:87], v97 offset:17536
	ds_read_b64_tr_b8 v[82:83], v97 offset:17024
	ds_read_b64_tr_b8 v[112:113], v97 offset:25344
	ds_read_b64_tr_b8 v[116:117], v97 offset:25856
	ds_read_b64_tr_b8 v[88:89], v97 offset:25984
	ds_read_b64_tr_b8 v[84:85], v97 offset:25472
	v_add_u32_e32 v97, v91, v92
	v_cndmask_b32_e64 v97, v90, v97, s[8:9]
	s_add_i32 s8, s3, s44
	s_mov_b32 m0, s8
	s_add_i32 s9, s2, s44
	buffer_load_dwordx4 v98, s[24:27], 0 offen lds
	s_add_i32 m0, s8, 0x4200
	v_add_u32_e32 v92, s43, v92
	buffer_load_dwordx4 v99, s[24:27], 0 offen lds
	s_mov_b32 m0, s9
	s_nop 0
	buffer_load_dwordx4 v100, s[4:7], 0 offen lds
	s_add_i32 m0, s9, 0x4200
	s_cmp_lg_u32 s56, 0
	buffer_load_dwordx4 v97, s[4:7], 0 offen lds
	s_waitcnt lgkmcnt(6)
	v_mfma_f32_32x32x64_f8f6f4 v[32:47], v[74:81], v[110:117], v[32:47] cbsz:1
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x64_f8f6f4 v[48:63], v[64:71], v[110:117], v[48:63] cbsz:1
	v_mfma_f32_32x32x64_f8f6f4 v[16:31], v[74:81], v[82:89], v[16:31] cbsz:1
	v_mfma_f32_32x32x64_f8f6f4 v[0:15], v[64:71], v[82:89], v[0:15] cbsz:1
	v_mov_b32_e32 v64, v126
	s_cbranch_scc1 .L4
	scratch_load_dword v74, off, off offset:88
	scratch_load_dword v75, off, off offset:84
	scratch_load_dword v76, off, off offset:68
	scratch_load_dword v77, off, off offset:72
	scratch_load_dword v78, off, off offset:76
	scratch_load_dword v79, off, off offset:80
	v_mov_b32_e32 v80, v127
	scratch_load_dword v127, off, off offset:92
	v_mov_b32_e32 v81, v123
	s_branch .L6
.L5:
	v_mov_b32_e32 v15, 0
	s_add_i32 s2, 0, 0x107e0
	v_mov_b32_e32 v14, v15
	v_mov_b32_e32 v13, v15
	v_mov_b32_e32 v12, v15
	v_mov_b32_e32 v11, v15
	v_mov_b32_e32 v10, v15
	v_mov_b32_e32 v9, v15
	v_mov_b32_e32 v8, v15
	v_mov_b32_e32 v7, v15
	v_mov_b32_e32 v6, v15
	v_mov_b32_e32 v5, v15
	v_mov_b32_e32 v4, v15
	v_mov_b32_e32 v3, v15
	v_mov_b32_e32 v2, v15
	v_mov_b32_e32 v1, v15
	v_mov_b32_e32 v0, v15
	v_mov_b32_e32 v31, v15
	v_mov_b32_e32 v30, v15
	v_mov_b32_e32 v29, v15
	v_mov_b32_e32 v28, v15
	v_mov_b32_e32 v27, v15
	v_mov_b32_e32 v26, v15
	v_mov_b32_e32 v25, v15
	v_mov_b32_e32 v24, v15
	v_mov_b32_e32 v23, v15
	v_mov_b32_e32 v22, v15
	v_mov_b32_e32 v21, v15
	v_mov_b32_e32 v20, v15
	v_mov_b32_e32 v19, v15
	v_mov_b32_e32 v18, v15
	v_mov_b32_e32 v17, v15
	v_mov_b32_e32 v16, v15
	v_mov_b32_e32 v63, v15
	v_mov_b32_e32 v62, v15
	v_mov_b32_e32 v61, v15
	v_mov_b32_e32 v60, v15
	v_mov_b32_e32 v59, v15
	v_mov_b32_e32 v58, v15
	v_mov_b32_e32 v57, v15
	v_mov_b32_e32 v56, v15
	v_mov_b32_e32 v55, v15
	v_mov_b32_e32 v54, v15
	v_mov_b32_e32 v53, v15
	v_mov_b32_e32 v52, v15
	v_mov_b32_e32 v51, v15
	v_mov_b32_e32 v50, v15
	v_mov_b32_e32 v49, v15
	v_mov_b32_e32 v48, v15
	v_mov_b32_e32 v47, v15
	v_mov_b32_e32 v46, v15
	v_mov_b32_e32 v45, v15
	v_mov_b32_e32 v44, v15
	v_mov_b32_e32 v43, v15
	v_mov_b32_e32 v42, v15
	v_mov_b32_e32 v41, v15
	v_mov_b32_e32 v40, v15
	v_mov_b32_e32 v39, v15
	v_mov_b32_e32 v38, v15
	v_mov_b32_e32 v37, v15
	v_mov_b32_e32 v36, v15
	v_mov_b32_e32 v35, v15
	v_mov_b32_e32 v34, v15
	v_mov_b32_e32 v33, v15
	v_mov_b32_e32 v32, v15
	s_mov_b32 s3, 0
.L6:
	s_andn2_b64 vcc, exec, s[22:23]
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_barrier
	s_cbranch_vccnz .L2
	v_add3_u32 v82, s3, v72, v64
	v_add3_u32 v91, v82, s40, v73
	v_add3_u32 v82, s2, v72, v64
	v_add3_u32 v68, v82, s41, v73
	ds_read_b64_tr_b8 v[108:109], v68
	ds_read_b64_tr_b8 v[110:111], v68 offset:8448
	ds_read_b64_tr_b8 v[112:113], v68 offset:512
	ds_read_b64_tr_b8 v[114:115], v68 offset:8960
	ds_read_b64_tr_b8 v[116:117], v91
	ds_read_b64_tr_b8 v[118:119], v91 offset:8448
	ds_read_b64_tr_b8 v[120:121], v91 offset:512
	ds_read_b64_tr_b8 v[122:123], v91 offset:8960
	ds_read_b64_tr_b8 v[92:93], v68 offset:128
	ds_read_b64_tr_b8 v[94:95], v68 offset:8576
	ds_read_b64_tr_b8 v[96:97], v68 offset:640
	ds_read_b64_tr_b8 v[98:99], v68 offset:9088
	ds_read_b64_tr_b8 v[100:101], v68 offset:16896
	ds_read_b64_tr_b8 v[102:103], v68 offset:25344
	ds_read_b64_tr_b8 v[104:105], v68 offset:17408
	ds_read_b64_tr_b8 v[106:107], v68 offset:25856
	ds_read_b64_tr_b8 v[82:83], v91 offset:16896
	ds_read_b64_tr_b8 v[84:85], v91 offset:25344
	ds_read_b64_tr_b8 v[86:87], v91 offset:17408
	ds_read_b64_tr_b8 v[88:89], v91 offset:25856
	s_waitcnt lgkmcnt(12)
	v_mfma_f32_32x32x64_f8f6f4 v[32:47], v[108:115], v[116:123], v[32:47] cbsz:1
	s_waitcnt lgkmcnt(8)
	v_mfma_f32_32x32x64_f8f6f4 v[48:63], v[92:99], v[116:123], v[48:63] cbsz:1
	ds_read_b64_tr_b8 v[116:117], v68 offset:17024
	ds_read_b64_tr_b8 v[118:119], v68 offset:25472
	ds_read_b64_tr_b8 v[120:121], v68 offset:17536
	ds_read_b64_tr_b8 v[122:123], v68 offset:25984
	ds_read_b64_tr_b8 v[64:65], v91 offset:17024
	ds_read_b64_tr_b8 v[66:67], v91 offset:25472
	ds_read_b64_tr_b8 v[68:69], v91 offset:17536
	ds_read_b64_tr_b8 v[70:71], v91 offset:25984
	s_waitcnt lgkmcnt(8)
	v_mfma_f32_32x32x64_f8f6f4 v[32:47], v[100:107], v[82:89], v[32:47] cbsz:1
	s_waitcnt lgkmcnt(4)
	v_mfma_f32_32x32x64_f8f6f4 v[48:63], v[116:123], v[82:89], v[48:63] cbsz:1
	ds_read_b64_tr_b8 v[82:83], v91 offset:128
	ds_read_b64_tr_b8 v[84:85], v91 offset:8576
	ds_read_b64_tr_b8 v[86:87], v91 offset:640
	ds_read_b64_tr_b8 v[88:89], v91 offset:9088
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x64_f8f6f4 v[16:31], v[108:115], v[82:89], v[16:31] cbsz:1
	v_mfma_f32_32x32x64_f8f6f4 v[0:15], v[92:99], v[82:89], v[0:15] cbsz:1
	v_mfma_f32_32x32x64_f8f6f4 v[16:31], v[100:107], v[64:71], v[16:31] cbsz:1
	v_mfma_f32_32x32x64_f8f6f4 v[0:15], v[116:123], v[64:71], v[0:15] cbsz:1
	v_mov_b32_e32 v64, v126
	s_branch .L2
.L7:
	s_endpgm
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
.Lfunc_end:
.size grouped_variable_k_dot_scaled_kernel, .Lfunc_end-grouped_variable_k_dot_scaled_kernel

.rodata
.p2align 6
.amdhsa_kernel grouped_variable_k_dot_scaled_kernel
  .amdhsa_group_segment_fixed_size 0
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_kernarg_size 96
  .amdhsa_next_free_vgpr 224
  .amdhsa_next_free_sgpr 59
  .amdhsa_accum_offset 224
  .amdhsa_float_round_mode_32 3
  .amdhsa_float_round_mode_16_64 3
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_ieee_mode 1
  .amdhsa_dx10_clamp 1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_system_sgpr_workgroup_id_x 1
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.kernels:
  - .name: grouped_variable_k_dot_scaled_kernel
    .symbol: grouped_variable_k_dot_scaled_kernel.kd
    .kernarg_segment_size: 96
    .group_segment_fixed_size: 0
    .private_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .wavefront_size: 64
    .sgpr_count: 59
    .vgpr_count: 221
    .agpr_count: 0
    .max_flat_workgroup_size: 1024
    .sgpr_spill_count: 0
    .vgpr_spill_count: 0
    .uses_dynamic_stack: false
    .uniform_work_group_size: 1
    .args:
      - .offset: 0
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 8
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 16
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 24
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 32
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 40
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 48
        .size: 4
        .value_kind: by_value
      - .offset: 52
        .size: 4
        .value_kind: by_value
      - .offset: 56
        .size: 4
        .value_kind: by_value
      - .offset: 60
        .size: 4
        .value_kind: by_value
      - .offset: 64
        .size: 4
        .value_kind: by_value
      - .offset: 68
        .size: 4
        .value_kind: by_value
      - .offset: 72
        .size: 4
        .value_kind: by_value
      - .offset: 80
        .size: 8
        .value_kind: global_buffer
        .address_space: global
      - .offset: 88
        .size: 8
        .value_kind: global_buffer
        .address_space: global
amdhsa.target: amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
.end_amdgpu_metadata
