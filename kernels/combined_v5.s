.amdgcn_target "amdgcn-amd-amdhsa--gfx950"

.text
.globl _grouped_fp8_persistent_gemm_kernel
.p2align 8
.type _grouped_fp8_persistent_gemm_kernel,@function
_grouped_fp8_persistent_gemm_kernel:
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
	s_mov_b64 s[20:21], s[6:7]
	s_mov_b64 s[24:25], s[2:3]
	s_cmpk_gt_i32 s16, 0x100
	s_cbranch_scc1 .L1
	s_ashr_i32 s2, s16, 31
	s_lshr_b32 s3, s2, 29
	s_add_i32 s3, s16, s3
	s_ashr_i32 s7, s3, 31
	s_ashr_i32 s6, s3, 3
	s_lshr_b32 s2, s2, 24
	s_lshr_b32 s7, s7, 27
	s_and_b32 s3, s3, 0x7fffff8
	s_add_i32 s2, s16, s2
	s_add_i32 s7, s6, s7
	s_sub_i32 s3, s16, s3
	s_andn2_b32 s7, s7, 31
	s_and_b32 s2, s2, 0xffffff00
	s_lshl_b32 s3, s3, 5
	s_sub_i32 s6, s6, s7
	s_add_i32 s2, s2, s3
	s_add_i32 s16, s2, s6
.L1:
	s_add_i32 s2, s15, 0xff
	s_ashr_i32 s3, s2, 31
	s_lshr_b32 s3, s3, 24
	s_add_i32 s2, s2, s3
	s_ashr_i32 s17, s2, 8
	s_cmp_gt_i32 s14, 0
	s_cselect_b64 s[2:3], -1, 0
	s_cmp_lt_i32 s14, 1
	s_mov_b32 s33, 0
	s_cbranch_scc1 .L3
	s_load_dwordx2 s[18:19], s[12:13], 0x0
	s_add_u32 s6, s12, 8
	s_addc_u32 s7, s13, 0
	s_mov_b32 s22, s14
.L2:
	s_load_dwordx2 s[26:27], s[6:7], 0x0
	s_waitcnt lgkmcnt(0)
	s_sub_i32 s18, s26, s18
	s_addk_i32 s18, 0xff
	s_ashr_i32 s19, s18, 31
	s_lshr_b32 s19, s19, 24
	s_add_i32 s18, s18, s19
	s_ashr_i32 s18, s18, 8
	s_mul_i32 s18, s18, s17
	s_add_i32 s33, s18, s33
	s_add_u32 s6, s6, 8
	s_addc_u32 s7, s7, 0
	s_add_i32 s22, s22, -1
	s_cmp_lg_u32 s22, 0
	s_mov_b64 s[18:19], s[26:27]
	s_cbranch_scc1 .L2
.L3:
	s_load_dwordx4 s[28:31], s[0:1], 0x38
	s_load_dword s38, s[0:1], 0x48
	s_cmp_ge_i32 s16, s33
	s_cbranch_scc1 .L10
	s_load_dword s0, s[10:11], 0x0
	s_load_dword s1, s[8:9], 0x0
	s_waitcnt lgkmcnt(0)
	s_add_i32 s9, s28, 0x7f
	v_lshrrev_b32_e32 v2, 4, v0
	s_lshl_b32 s39, s17, 2
	v_mov_b32_e32 v1, s0
	s_ashr_i32 s0, s9, 31
	v_mul_f32_e32 v200, s1, v1
	v_and_b32_e32 v1, 15, v0
	s_lshr_b32 s0, s0, 25
	v_and_or_b32 v210, v2, 16, v1
	v_lshrrev_b32_e32 v2, 2, v0
	s_add_i32 s0, s9, s0
	v_and_b32_e32 v211, 60, v2
	v_lshlrev_b32_e32 v2, 4, v0
	s_and_b32 s40, s0, 0xffffff80
	v_and_b32_e32 v202, 0x70, v2
	s_ashr_i32 s22, s0, 7
	s_addk_i32 s40, 0xff80
	s_and_b32 s25, s25, 0xffff
	s_and_b32 s5, s5, 0xffff
	v_or_b32_e32 v3, s40, v202
	s_cmpk_gt_i32 s9, 0x17f
	s_movk_i32 s8, 0x70
	v_cmp_gt_i32_e64 s[0:1], s28, v3
	s_cselect_b64 s[6:7], -1, 0
	v_lshlrev_b32_e32 v3, 3, v0
	v_and_b32_e32 v5, 48, v0
	s_cmpk_gt_i32 s9, 0xff
	v_lshrrev_b32_e32 v203, 3, v0
	v_bitop3_b32 v2, v2, v0, s8 bitop3:0x78
	v_and_b32_e32 v4, 0x870, v3
	v_lshlrev_b32_e32 v0, 5, v0
	v_bitop3_b32 v3, v3, v5, s8 bitop3:0x6c
	s_movk_i32 s8, 0x1800
	s_cselect_b64 s[10:11], -1, 0
	s_cmp_gt_i32 s15, -1
	v_lshlrev_b32_e32 v1, 7, v1
	v_and_or_b32 v0, v0, s8, v3
	s_cselect_b64 s[18:19], -1, 0
	s_abs_i32 s28, s39
	v_or_b32_e32 v214, v0, v1
	v_bitop3_b32 v215, v0, 64, v1 bitop3:0x36
	v_cvt_f32_u32_e32 v0, s28
	s_abs_i32 s15, s15
	v_bitop3_b32 v212, v1, v5, v4 bitop3:0x36
	v_cvt_f32_u32_e32 v1, s15
	v_rcp_iflag_f32_e32 v0, v0
	s_max_i32 s8, s22, 3
	s_sub_i32 s9, 0, s28
	v_rcp_iflag_f32_e32 v1, v1
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	s_and_b32 s21, s21, 0xffff
	s_bfe_i32 s41, s17, 0x1001d
	v_or_b32_e32 v207, 64, v203
	v_readfirstlane_b32 s22, v0
	v_mul_f32_e32 v0, 0x4f7ffffe, v1
	v_cvt_u32_f32_e32 v0, v0
	s_mul_i32 s9, s9, s22
	s_mul_hi_u32 s9, s22, s9
	s_add_i32 s42, s22, s9
	s_sub_i32 s9, 0, s15
	v_mul_lo_u32 v1, s9, v0
	v_mul_hi_u32 v1, v0, v1
	v_add_u32_e32 v216, v0, v1
	s_add_u32 s34, s12, 8
	v_cndmask_b32_e64 v0, 0, 1, s[2:3]
	s_addc_u32 s35, s13, 0
	s_lshl_b32 s43, s8, 7
	v_cmp_ne_u32_e64 s[2:3], 1, v0
	v_cndmask_b32_e64 v0, 0, 1, s[6:7]
	v_or_b32_e32 v208, 0x80, v203
	v_or_b32_e32 v209, 0xc0, v203
	s_mov_b32 s27, 0x27000
	s_mov_b32 s26, 0x7ffffffe
	v_xor_b32_e32 v213, 64, v212
	v_mov_b32_e32 v204, v200
	v_mov_b32_e32 v205, v200
	v_mov_b32_e32 v217, 0
	v_or_b32_e32 v206, 0x80, v202
	s_addk_i32 s43, 0xff00
	v_add_u32_e32 v218, 0, v2
	v_cmp_ne_u32_e64 s[8:9], 1, v0
	v_bfrev_b32_e32 v219, 1
	s_branch .L5
.L4:
	v_add_u32_e32 v0, s40, v192
	s_add_i32 s44, s44, s40
	v_add_u32_e32 v1, v56, v0
	v_add_u32_e32 v2, v58, v0
	v_add_u32_e32 v8, v60, v0
	v_add_u32_e32 v9, v62, v0
	v_add_u32_e32 v16, s44, v57
	v_cndmask_b32_e64 v0, v219, v1, s[0:1]
	v_cndmask_b32_e64 v4, v219, v2, s[0:1]
	v_cndmask_b32_e64 v8, v219, v8, s[0:1]
	v_cndmask_b32_e64 v12, v219, v9, s[0:1]
	s_mov_b32 s6, s26
	s_mov_b32 s7, s27
	v_add_u32_e32 v17, s44, v59
	v_add_u32_e32 v18, s44, v61
	v_add_u32_e32 v19, s44, v63
	v_cndmask_b32_e64 v16, v219, v16, s[0:1]
	buffer_load_dwordx4 v[0:3], v0, s[24:27], 0 offen
	s_nop 0
	buffer_load_dwordx4 v[4:7], v4, s[24:27], 0 offen
	s_nop 0
	buffer_load_dwordx4 v[8:11], v8, s[24:27], 0 offen
	s_nop 0
	buffer_load_dwordx4 v[12:15], v12, s[24:27], 0 offen
	v_cndmask_b32_e64 v17, v219, v17, s[0:1]
	v_cndmask_b32_e64 v18, v219, v18, s[0:1]
	v_cndmask_b32_e64 v19, v219, v19, s[0:1]
	buffer_load_dwordx4 v[24:27], v16, s[4:7], 0 offen
	buffer_load_dwordx4 v[28:31], v17, s[4:7], 0 offen
	buffer_load_dwordx4 v[50:53], v18, s[4:7], 0 offen
	buffer_load_dwordx4 v[192:195], v19, s[4:7], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_ashr_i32 s6, s37, 31
	s_waitcnt vmcnt(7)
	ds_write_b128 v218, v[0:3]
	s_waitcnt vmcnt(6)
	ds_write_b128 v218, v[4:7] offset:8192
	s_waitcnt vmcnt(5)
	ds_write_b128 v218, v[8:11] offset:16384
	s_waitcnt vmcnt(4)
	ds_write_b128 v218, v[12:15] offset:24576
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[224:227], v36
	ds_read_b128 v[232:235], v36 offset:4096
	ds_read_b128 v[240:243], v36 offset:8192
	ds_read_b128 v[64:67], v36 offset:12288
	ds_read_b128 v[56:59], v36 offset:16384
	ds_read_b128 v[32:35], v36 offset:20480
	ds_read_b128 v[16:19], v36 offset:24576
	ds_read_b128 v[0:3], v36 offset:28672
	ds_read_b128 v[228:231], v48
	ds_read_b128 v[236:239], v48 offset:4096
	ds_read_b128 v[244:247], v48 offset:8192
	ds_read_b128 v[68:71], v48 offset:12288
	ds_read_b128 v[60:63], v48 offset:16384
	ds_read_b128 v[36:39], v48 offset:20480
	ds_read_b128 v[20:23], v48 offset:24576
	ds_read_b128 v[4:7], v48 offset:28672
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(3)
	ds_write_b128 v218, v[24:27]
	s_waitcnt vmcnt(2)
	ds_write_b128 v218, v[28:31] offset:8192
	s_waitcnt vmcnt(1)
	ds_write_b128 v218, v[50:53] offset:16384
	s_waitcnt vmcnt(0)
	ds_write_b128 v218, v[192:195] offset:24576
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b128 v[28:31], v221
	ds_read_b128 v[24:27], v222
	ds_read_b128 v[8:11], v222 offset:8192
	ds_read_b128 v[12:15], v221 offset:8192
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[196:199], v[24:31], v[224:231], v[44:47]
	ds_read_b128 v[52:55], v221 offset:16384
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_16x16x128_f8f6f4 v[192:195], v[8:15], v[224:231], v[40:43]
	ds_read_b128 v[48:51], v222 offset:16384
	s_nop 5
	ds_read_b128 v[40:43], v222 offset:24576
	ds_read_b128 v[44:47], v221 offset:24576
	v_or_b32_e32 v221, s37, v210
	v_add_u32_e32 v221, s6, v221
	v_xor_b32_e32 v222, s6, v221
	v_mul_hi_u32 v223, v222, v220
	v_mul_lo_u32 v223, v223, s23
	v_sub_u32_e32 v222, v222, v223
	v_subrev_u32_e32 v223, s23, v222
	v_cmp_le_u32_e32 vcc, s23, v222
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[188:191], v[48:55], v[224:231], v[188:191]
	v_cndmask_b32_e32 v222, v222, v223, vcc
	v_subrev_u32_e32 v223, s23, v222
	v_cmp_le_u32_e32 vcc, s23, v222
	s_nop 1
	v_cndmask_b32_e32 v222, v222, v223, vcc
	v_add_u32_e32 v223, 32, v221
	v_xor_b32_e32 v223, s6, v223
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[184:187], v[40:47], v[224:231], v[184:187]
	v_mul_hi_u32 v224, v223, v220
	v_mul_lo_u32 v224, v224, s23
	v_sub_u32_e32 v223, v223, v224
	v_subrev_u32_e32 v224, s23, v223
	v_cmp_le_u32_e32 vcc, s23, v223
	v_xor_b32_e32 v222, s6, v222
	v_subrev_u32_e32 v222, s6, v222
	v_cndmask_b32_e32 v223, v223, v224, vcc
	v_subrev_u32_e32 v224, s23, v223
	v_cmp_le_u32_e32 vcc, s23, v223
	v_mfma_f32_16x16x128_f8f6f4 v[148:151], v[24:31], v[64:71], v[148:151]
	s_nop 0
	v_cndmask_b32_e32 v223, v223, v224, vcc
	v_add_u32_e32 v224, 64, v221
	v_xor_b32_e32 v224, s6, v224
	v_mul_hi_u32 v225, v224, v220
	v_mul_lo_u32 v225, v225, s23
	v_sub_u32_e32 v224, v224, v225
	v_subrev_u32_e32 v225, s23, v224
	v_cmp_le_u32_e32 vcc, s23, v224
	v_mfma_f32_16x16x128_f8f6f4 v[144:147], v[8:15], v[64:71], v[144:147]
	v_xor_b32_e32 v223, s6, v223
	v_cndmask_b32_e32 v224, v224, v225, vcc
	v_subrev_u32_e32 v225, s23, v224
	v_cmp_le_u32_e32 vcc, s23, v224
	v_subrev_u32_e32 v223, s6, v223
	s_nop 0
	v_cndmask_b32_e32 v224, v224, v225, vcc
	v_add_u32_e32 v225, 0x60, v221
	v_xor_b32_e32 v225, s6, v225
	v_mul_hi_u32 v226, v225, v220
	v_mul_lo_u32 v226, v226, s23
	v_mfma_f32_16x16x128_f8f6f4 v[140:143], v[48:55], v[64:71], v[140:143]
	v_xor_b32_e32 v224, s6, v224
	v_subrev_u32_e32 v224, s6, v224
	v_mfma_f32_16x16x128_f8f6f4 v[64:67], v[40:47], v[64:71], v[136:139]
	v_sub_u32_e32 v68, v225, v226
	v_subrev_u32_e32 v69, s23, v68
	v_cmp_le_u32_e32 vcc, s23, v68
	s_nop 1
	v_cndmask_b32_e32 v68, v68, v69, vcc
	v_subrev_u32_e32 v69, s23, v68
	v_cmp_le_u32_e32 vcc, s23, v68
	v_mfma_f32_16x16x128_f8f6f4 v[128:131], v[8:15], v[56:63], v[128:131]
	s_nop 0
	v_cndmask_b32_e32 v136, v68, v69, vcc
	v_mfma_f32_16x16x128_f8f6f4 v[68:71], v[24:31], v[56:63], v[132:135]
	s_nop 6
	v_add_u32_e32 v133, 0x80, v221
	v_xor_b32_e32 v133, s6, v133
	v_mul_hi_u32 v134, v133, v220
	v_mul_lo_u32 v134, v134, s23
	v_sub_u32_e32 v133, v133, v134
	v_subrev_u32_e32 v134, s23, v133
	v_cmp_le_u32_e32 vcc, s23, v133
	v_mfma_f32_16x16x128_f8f6f4 v[124:127], v[48:55], v[56:63], v[124:127]
	v_xor_b32_e32 v132, s6, v136
	v_cndmask_b32_e32 v133, v133, v134, vcc
	v_subrev_u32_e32 v134, s23, v133
	v_cmp_le_u32_e32 vcc, s23, v133
	v_subrev_u32_e32 v132, s6, v132
	s_nop 0
	v_cndmask_b32_e32 v133, v133, v134, vcc
	v_add_u32_e32 v134, 0xa0, v221
	v_xor_b32_e32 v134, s6, v134
	v_mul_hi_u32 v135, v134, v220
	v_mul_lo_u32 v135, v135, s23
	v_sub_u32_e32 v134, v134, v135
	v_subrev_u32_e32 v135, s23, v134
	v_cmp_le_u32_e32 vcc, s23, v134
	v_mfma_f32_16x16x128_f8f6f4 v[56:59], v[40:47], v[56:63], v[120:123]
	v_xor_b32_e32 v133, s6, v133
	v_cndmask_b32_e32 v60, v134, v135, vcc
	v_subrev_u32_e32 v61, s23, v60
	v_cmp_le_u32_e32 vcc, s23, v60
	v_subrev_u32_e32 v133, s6, v133
	s_nop 1
	v_add_u32_e32 v121, 0xc0, v221
	v_cndmask_b32_e32 v60, v60, v61, vcc
	v_xor_b32_e32 v60, s6, v60
	v_subrev_u32_e32 v120, s6, v60
	v_mfma_f32_16x16x128_f8f6f4 v[60:63], v[24:31], v[32:39], v[116:119]
	s_nop 6
	v_xor_b32_e32 v116, s6, v121
	v_mul_hi_u32 v117, v116, v220
	v_mul_lo_u32 v117, v117, s23
	v_sub_u32_e32 v116, v116, v117
	v_subrev_u32_e32 v117, s23, v116
	v_cmp_le_u32_e32 vcc, s23, v116
	v_mfma_f32_16x16x128_f8f6f4 v[112:115], v[8:15], v[32:39], v[112:115]
	s_nop 0
	v_cndmask_b32_e32 v116, v116, v117, vcc
	v_subrev_u32_e32 v117, s23, v116
	v_cmp_le_u32_e32 vcc, s23, v116
	s_nop 1
	v_cndmask_b32_e32 v116, v116, v117, vcc
	v_add_u32_e32 v117, 0xe0, v221
	v_xor_b32_e32 v117, s6, v117
	v_mul_hi_u32 v118, v117, v220
	v_mul_lo_u32 v118, v118, s23
	v_sub_u32_e32 v117, v117, v118
	v_subrev_u32_e32 v118, s23, v117
	v_cmp_le_u32_e32 vcc, s23, v117
	v_mfma_f32_16x16x128_f8f6f4 v[108:111], v[48:55], v[32:39], v[108:111]
	v_xor_b32_e32 v116, s6, v116
	v_cndmask_b32_e32 v117, v117, v118, vcc
	v_subrev_u32_e32 v118, s23, v117
	v_cmp_le_u32_e32 vcc, s23, v117
	v_subrev_u32_e32 v116, s6, v116
	s_mov_b32 s23, s27
	v_mfma_f32_16x16x128_f8f6f4 v[32:35], v[40:47], v[32:39], v[104:107]
	v_cndmask_b32_e32 v36, v117, v118, vcc
	v_xor_b32_e32 v36, s6, v36
	s_nop 4
	v_subrev_u32_e32 v104, s6, v36
	v_or_b32_e32 v36, s36, v211
	s_ashr_i32 s6, s36, 31
	v_add_u32_e32 v105, s6, v36
	v_xor_b32_e32 v106, s6, v105
	v_mfma_f32_16x16x128_f8f6f4 v[36:39], v[24:31], v[16:23], v[100:103]
	s_cmp_gt_i32 s22, -1
	s_mov_b32 s22, s26
	s_nop 4
	v_mul_hi_u32 v100, v106, v216
	v_mul_lo_u32 v100, v100, s15
	v_sub_u32_e32 v100, v106, v100
	v_subrev_u32_e32 v101, s15, v100
	v_cmp_le_u32_e32 vcc, s15, v100
	v_mfma_f32_16x16x128_f8f6f4 v[96:99], v[8:15], v[16:23], v[96:99]
	s_nop 0
	v_cndmask_b32_e32 v100, v100, v101, vcc
	v_subrev_u32_e32 v101, s15, v100
	v_cmp_le_u32_e32 vcc, s15, v100
	s_nop 1
	v_cndmask_b32_e32 v100, v100, v101, vcc
	v_add_u32_e32 v101, 64, v105
	v_xor_b32_e32 v101, s6, v101
	v_mul_hi_u32 v102, v101, v216
	v_mul_lo_u32 v102, v102, s15
	v_sub_u32_e32 v101, v101, v102
	v_subrev_u32_e32 v102, s15, v101
	v_cmp_le_u32_e32 vcc, s15, v101
	v_mfma_f32_16x16x128_f8f6f4 v[92:95], v[48:55], v[16:23], v[92:95]
	v_xor_b32_e32 v100, s6, v100
	v_cndmask_b32_e32 v101, v101, v102, vcc
	v_subrev_u32_e32 v102, s15, v101
	v_cmp_le_u32_e32 vcc, s15, v101
	v_subrev_u32_e32 v100, s6, v100
	s_nop 0
	v_cndmask_b32_e32 v101, v101, v102, vcc
	v_mfma_f32_16x16x128_f8f6f4 v[16:19], v[40:47], v[16:23], v[88:91]
	v_xor_b32_e32 v20, s6, v101
	s_nop 5
	v_subrev_u32_e32 v88, s6, v20
	v_add_u32_e32 v20, 0x80, v105
	v_xor_b32_e32 v20, s6, v20
	v_mul_hi_u32 v21, v20, v216
	v_mul_lo_u32 v21, v21, s15
	v_mfma_f32_16x16x128_f8f6f4 v[176:179], v[8:15], v[232:239], v[176:179]
	v_sub_u32_e32 v89, v20, v21
	v_cmp_le_u32_e32 vcc, s15, v89
	v_mfma_f32_16x16x128_f8f6f4 v[160:163], v[8:15], v[240:247], v[160:163]
	v_mfma_f32_16x16x128_f8f6f4 v[8:11], v[8:15], v[0:7], v[80:83]
	v_add_u32_e32 v12, 0xc0, v105
	v_xor_b32_e32 v12, s6, v12
	v_mul_hi_u32 v13, v12, v216
	v_mul_lo_u32 v13, v13, s15
	v_mfma_f32_16x16x128_f8f6f4 v[180:183], v[24:31], v[232:239], v[180:183]
	v_mfma_f32_16x16x128_f8f6f4 v[164:167], v[24:31], v[240:247], v[164:167]
	v_mfma_f32_16x16x128_f8f6f4 v[20:23], v[24:31], v[0:7], v[84:87]
	v_subrev_u32_e32 v24, s15, v89
	v_cndmask_b32_e32 v24, v89, v24, vcc
	v_subrev_u32_e32 v25, s15, v24
	v_cmp_le_u32_e32 vcc, s15, v24
	s_nop 1
	v_cndmask_b32_e32 v24, v24, v25, vcc
	v_sub_u32_e32 v25, v12, v13
	v_subrev_u32_e32 v26, s15, v25
	v_cmp_le_u32_e32 vcc, s15, v25
	v_mfma_f32_16x16x128_f8f6f4 v[12:15], v[48:55], v[0:7], v[76:79]
	v_xor_b32_e32 v24, s6, v24
	v_cndmask_b32_e32 v25, v25, v26, vcc
	v_subrev_u32_e32 v26, s15, v25
	v_cmp_le_u32_e32 vcc, s15, v25
	v_subrev_u32_e32 v24, s6, v24
	s_nop 0
	v_cndmask_b32_e32 v25, v25, v26, vcc
	v_mfma_f32_16x16x128_f8f6f4 v[0:3], v[40:47], v[0:7], v[72:75]
	v_add_u32_e32 v4, v222, v201
	v_mul_lo_u32 v26, v4, s38
	v_add_u32_e32 v4, v223, v201
	v_mul_lo_u32 v27, v4, s38
	v_add_u32_e32 v4, v224, v201
	v_mul_lo_u32 v28, v4, s38
	v_add_u32_e32 v4, v132, v201
	v_mul_lo_u32 v29, v4, s38
	v_add_u32_e32 v4, v133, v201
	v_mul_lo_u32 v30, v4, s38
	v_add_u32_e32 v4, v120, v201
	v_mul_lo_u32 v31, v4, s38
	v_add_u32_e32 v4, v116, v201
	v_mfma_f32_16x16x128_f8f6f4 v[168:171], v[40:47], v[232:239], v[168:171]
	v_xor_b32_e32 v25, s6, v25
	v_subrev_u32_e32 v25, s6, v25
	s_cselect_b64 s[6:7], -1, 0
	v_mul_f32_e64 v6, v204, v196
	v_mul_f32_e64 v7, v205, v197
	s_and_b64 vcc, s[18:19], s[6:7]
	v_pk_mul_f32 v[0:1], v[204:205], v[0:1]
	s_addk_i32 s16, 0x100
	v_mfma_f32_16x16x128_f8f6f4 v[152:155], v[40:47], v[240:247], v[152:155]
	v_mul_lo_u32 v40, v4, s38
	v_add_u32_e32 v4, v104, v201
	v_mov_b32_e32 v201, v200
	v_mul_lo_u32 v41, v4, s38
	v_mul_f32_e64 v4, v200, v198
	v_mul_f32_e64 v5, v201, v199
	v_pk_mul_f32 v[2:3], v[200:201], v[2:3]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v26, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[194:195]
	v_pk_mul_f32 v[6:7], v[204:205], v[192:193]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v26, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[190:191]
	v_pk_mul_f32 v[6:7], v[204:205], v[188:189]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v26, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[186:187]
	v_pk_mul_f32 v[6:7], v[204:205], v[184:185]
	v_mfma_f32_16x16x128_f8f6f4 v[172:175], v[48:55], v[232:239], v[172:175]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v26, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[182:183]
	v_pk_mul_f32 v[6:7], v[204:205], v[180:181]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v27, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[178:179]
	v_pk_mul_f32 v[6:7], v[204:205], v[176:177]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v27, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[174:175]
	v_pk_mul_f32 v[6:7], v[204:205], v[172:173]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v27, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[170:171]
	v_pk_mul_f32 v[6:7], v[204:205], v[168:169]
	v_mfma_f32_16x16x128_f8f6f4 v[156:159], v[48:55], v[240:247], v[156:159]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v27, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[166:167]
	v_pk_mul_f32 v[6:7], v[204:205], v[164:165]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v28, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[162:163]
	v_pk_mul_f32 v[6:7], v[204:205], v[160:161]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v28, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[158:159]
	v_pk_mul_f32 v[6:7], v[204:205], v[156:157]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v28, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[154:155]
	v_pk_mul_f32 v[6:7], v[204:205], v[152:153]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v28, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[150:151]
	v_pk_mul_f32 v[6:7], v[204:205], v[148:149]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v29, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[146:147]
	v_pk_mul_f32 v[6:7], v[204:205], v[144:145]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v29, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[142:143]
	v_pk_mul_f32 v[6:7], v[204:205], v[140:141]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v29, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[66:67]
	v_pk_mul_f32 v[6:7], v[204:205], v[64:65]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v29, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[70:71]
	v_pk_mul_f32 v[6:7], v[204:205], v[68:69]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v30, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[130:131]
	v_pk_mul_f32 v[6:7], v[204:205], v[128:129]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v30, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[126:127]
	v_pk_mul_f32 v[6:7], v[204:205], v[124:125]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v30, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[58:59]
	v_pk_mul_f32 v[6:7], v[204:205], v[56:57]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v30, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[62:63]
	v_pk_mul_f32 v[6:7], v[204:205], v[60:61]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v31, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[114:115]
	v_pk_mul_f32 v[6:7], v[204:205], v[112:113]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v31, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[110:111]
	v_pk_mul_f32 v[6:7], v[204:205], v[108:109]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v31, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[34:35]
	v_pk_mul_f32 v[6:7], v[204:205], v[32:33]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v31, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[38:39]
	v_pk_mul_f32 v[6:7], v[204:205], v[36:37]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v40, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[98:99]
	v_pk_mul_f32 v[6:7], v[204:205], v[96:97]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v40, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[94:95]
	v_pk_mul_f32 v[6:7], v[204:205], v[92:93]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v40, v24, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[18:19]
	v_pk_mul_f32 v[6:7], v[204:205], v[16:17]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v40, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[22:23]
	v_pk_mul_f32 v[6:7], v[204:205], v[20:21]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v41, v100, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[10:11]
	v_pk_mul_f32 v[6:7], v[204:205], v[8:9]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v41, v88, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	v_pk_mul_f32 v[4:5], v[200:201], v[14:15]
	v_pk_mul_f32 v[6:7], v[204:205], v[12:13]
	v_cvt_pk_bf16_f32 v5, v4, v5
	v_cvt_pk_bf16_f32 v4, v6, v7
	v_add_lshl_u32 v6, v41, v24, 1
	v_cvt_pk_bf16_f32 v3, v2, v3
	v_cvt_pk_bf16_f32 v2, v0, v1
	v_add_lshl_u32 v0, v41, v25, 1
	v_cndmask_b32_e32 v6, v219, v6, vcc
	v_cndmask_b32_e32 v0, v219, v0, vcc
	s_cmp_lt_i32 s16, s33
	buffer_store_dwordx2 v[4:5], v6, s[20:23], 0 offen
	buffer_store_dwordx2 v[2:3], v0, s[20:23], 0 offen
	s_cbranch_scc0 .L10
.L5:
	s_and_b64 vcc, exec, s[2:3]
	s_mov_b32 s7, 0
	s_mov_b32 s6, 0
	s_cbranch_vccnz .L7
	global_load_dwordx2 v[0:1], v217, s[12:13]
	s_mov_b32 s44, 0
	s_mov_b64 s[22:23], s[34:35]
	s_mov_b32 s45, 0
	s_waitcnt vmcnt(0)
	v_readfirstlane_b32 s36, v0
.L6:
	global_load_dwordx2 v[0:1], v217, s[22:23]
	s_add_i32 s45, s45, 1
	s_waitcnt vmcnt(0)
	v_readfirstlane_b32 s46, v0
	s_sub_i32 s36, s46, s36
	s_addk_i32 s36, 0xff
	s_ashr_i32 s37, s36, 31
	s_lshr_b32 s37, s37, 24
	s_add_i32 s36, s36, s37
	s_ashr_i32 s36, s36, 8
	s_mul_i32 s36, s36, s17
	s_add_i32 s44, s36, s44
	s_cmp_lt_i32 s16, s44
	s_cselect_b32 s7, s7, s44
	s_cselect_b32 s6, s6, s45
	s_add_u32 s22, s22, 8
	s_addc_u32 s23, s23, 0
	s_cmp_lg_u32 s14, s45
	s_mov_b64 s[36:37], s[46:47]
	s_cbranch_scc1 .L6
.L7:
	s_sub_i32 s44, s16, s7
	s_ashr_i32 s7, s6, 31
	s_lshl_b64 s[22:23], s[6:7], 3
	s_add_u32 s22, s12, s22
	s_addc_u32 s23, s13, s23
	s_add_i32 s36, s6, 1
	s_ashr_i32 s37, s36, 31
	s_lshl_b64 s[36:37], s[36:37], 3
	s_add_u32 s36, s12, s36
	s_addc_u32 s37, s13, s37
	global_load_dword v0, v217, s[36:37]
	global_load_dword v201, v217, s[22:23]
	s_abs_i32 s22, s44
	s_mul_hi_u32 s23, s22, s42
	s_mul_i32 s36, s23, s28
	s_sub_i32 s36, s22, s36
	s_ashr_i32 s7, s44, 31
	s_xor_b32 s7, s7, s41
	s_add_i32 s37, s23, 1
	s_sub_i32 s45, s36, s28
	v_mov_b32_e32 v75, 0
	v_mov_b32_e32 v74, v75
	v_mov_b32_e32 v73, v75
	v_mov_b32_e32 v72, v75
	v_mov_b32_e32 v79, v75
	v_mov_b32_e32 v78, v75
	v_mov_b32_e32 v77, v75
	v_mov_b32_e32 v76, v75
	v_mov_b32_e32 v83, v75
	v_mov_b32_e32 v82, v75
	v_mov_b32_e32 v81, v75
	v_mov_b32_e32 v80, v75
	v_mov_b32_e32 v87, v75
	v_mov_b32_e32 v86, v75
	v_mov_b32_e32 v85, v75
	v_mov_b32_e32 v84, v75
	v_mov_b32_e32 v91, v75
	v_mov_b32_e32 v90, v75
	v_mov_b32_e32 v89, v75
	v_mov_b32_e32 v88, v75
	v_mov_b32_e32 v95, v75
	v_mov_b32_e32 v94, v75
	v_mov_b32_e32 v93, v75
	v_mov_b32_e32 v92, v75
	v_mov_b32_e32 v99, v75
	v_mov_b32_e32 v98, v75
	v_mov_b32_e32 v97, v75
	v_mov_b32_e32 v96, v75
	v_mov_b32_e32 v103, v75
	v_mov_b32_e32 v102, v75
	v_mov_b32_e32 v101, v75
	v_mov_b32_e32 v100, v75
	v_mov_b32_e32 v107, v75
	v_mov_b32_e32 v106, v75
	v_mov_b32_e32 v105, v75
	v_mov_b32_e32 v104, v75
	v_mov_b32_e32 v111, v75
	v_mov_b32_e32 v110, v75
	v_mov_b32_e32 v109, v75
	v_mov_b32_e32 v108, v75
	v_mov_b32_e32 v115, v75
	v_mov_b32_e32 v114, v75
	v_mov_b32_e32 v113, v75
	v_mov_b32_e32 v112, v75
	v_mov_b32_e32 v119, v75
	v_mov_b32_e32 v118, v75
	v_mov_b32_e32 v117, v75
	v_mov_b32_e32 v116, v75
	v_mov_b32_e32 v123, v75
	v_mov_b32_e32 v122, v75
	v_mov_b32_e32 v121, v75
	v_mov_b32_e32 v120, v75
	v_mov_b32_e32 v127, v75
	v_mov_b32_e32 v126, v75
	v_mov_b32_e32 v125, v75
	v_mov_b32_e32 v124, v75
	v_mov_b32_e32 v131, v75
	v_mov_b32_e32 v130, v75
	v_mov_b32_e32 v129, v75
	v_mov_b32_e32 v128, v75
	v_mov_b32_e32 v135, v75
	v_mov_b32_e32 v134, v75
	v_mov_b32_e32 v133, v75
	v_mov_b32_e32 v132, v75
	v_mov_b32_e32 v139, v75
	v_mov_b32_e32 v138, v75
	v_mov_b32_e32 v137, v75
	v_mov_b32_e32 v136, v75
	v_mov_b32_e32 v143, v75
	v_mov_b32_e32 v142, v75
	s_waitcnt vmcnt(1)
	v_readfirstlane_b32 s22, v0
	s_waitcnt vmcnt(0)
	v_readfirstlane_b32 s46, v201
	s_sub_i32 s22, s22, s46
	s_add_i32 s46, s22, 0xff
	s_ashr_i32 s47, s46, 31
	s_lshr_b32 s47, s47, 24
	s_add_i32 s46, s46, s47
	s_ashr_i32 s46, s46, 8
	s_cmp_ge_u32 s36, s28
	s_cselect_b32 s23, s37, s23
	s_cselect_b32 s36, s45, s36
	s_add_i32 s37, s23, 1
	s_cmp_ge_u32 s36, s28
	s_cselect_b32 s23, s37, s23
	s_xor_b32 s23, s23, s7
	s_sub_i32 s7, s23, s7
	s_lshl_b32 s37, s7, 2
	s_sub_i32 s23, s46, s37
	s_min_i32 s36, s23, 4
	s_abs_i32 s23, s36
	v_cvt_f32_u32_e32 v0, s23
	s_sub_i32 s46, 0, s23
	s_mul_i32 s7, s7, s39
	s_sub_i32 s7, s44, s7
	v_rcp_iflag_f32_e32 v0, v0
	s_abs_i32 s44, s7
	s_xor_b32 s45, s7, s36
	s_ashr_i32 s45, s45, 31
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_cvt_u32_f32_e32 v0, v0
	v_mul_lo_u32 v192, s29, v201
	v_mov_b32_e32 v141, v75
	v_mov_b32_e32 v140, v75
	v_readfirstlane_b32 s47, v0
	s_mul_i32 s46, s46, s47
	s_mul_hi_u32 s46, s47, s46
	s_add_i32 s47, s47, s46
	s_mul_hi_u32 s46, s44, s47
	s_mul_i32 s47, s46, s23
	s_sub_i32 s44, s44, s47
	s_add_i32 s48, s46, 1
	s_sub_i32 s47, s44, s23
	s_cmp_ge_u32 s44, s23
	s_cselect_b32 s46, s48, s46
	s_cselect_b32 s44, s47, s44
	s_add_i32 s47, s46, 1
	s_cmp_ge_u32 s44, s23
	s_cselect_b32 s44, s47, s46
	s_abs_i32 s23, s22
	v_cvt_f32_u32_e32 v0, s23
	s_xor_b32 s44, s44, s45
	s_sub_i32 s44, s44, s45
	s_mul_i32 s45, s44, s36
	s_lshl_b32 s36, s44, 8
	s_bfe_i32 s44, s44, 0x10017
	v_or_b32_e32 v1, s36, v203
	v_rcp_iflag_f32_e32 v0, v0
	v_add_u32_e32 v1, s44, v1
	v_xor_b32_e32 v1, s44, v1
	v_mul_hi_u32 v9, v1, v216
	v_mul_lo_u32 v9, v9, s15
	v_mul_f32_e32 v0, 0x4f7ffffe, v0
	v_sub_u32_e32 v1, v1, v9
	v_cvt_u32_f32_e32 v0, v0
	s_sub_i32 s7, s7, s45
	v_subrev_u32_e32 v9, s15, v1
	v_cmp_le_u32_e32 vcc, s15, v1
	s_add_i32 s7, s7, s37
	s_sub_i32 s46, 0, s23
	v_cndmask_b32_e32 v1, v1, v9, vcc
	v_or_b32_e32 v2, s36, v207
	s_lshl_b32 s37, s7, 8
	v_subrev_u32_e32 v9, s15, v1
	v_cmp_le_u32_e32 vcc, s15, v1
	v_add_u32_e32 v6, s44, v2
	s_bfe_i32 s45, s7, 0x10017
	v_or_b32_e32 v2, s37, v203
	v_cndmask_b32_e32 v1, v1, v9, vcc
	v_mul_lo_u32 v9, s46, v0
	v_or_b32_e32 v3, s37, v207
	v_or_b32_e32 v7, s37, v208
	v_add_u32_e32 v2, s45, v2
	v_mul_hi_u32 v9, v0, v9
	v_or_b32_e32 v8, s37, v209
	v_add_u32_e32 v3, s45, v3
	v_add_u32_e32 v7, s45, v7
	v_xor_b32_e32 v2, s45, v2
	v_add_u32_e32 v220, v0, v9
	v_add_u32_e32 v8, s45, v8
	v_xor_b32_e32 v3, s45, v3
	v_xor_b32_e32 v7, s45, v7
	v_xor_b32_e32 v1, s44, v1
	v_mul_hi_u32 v0, v2, v220
	v_xor_b32_e32 v8, s45, v8
	v_subrev_u32_e32 v10, s44, v1
	v_mul_hi_u32 v1, v3, v220
	v_mul_hi_u32 v9, v7, v220
	v_mul_lo_u32 v0, v0, s23
	v_mul_hi_u32 v11, v8, v220
	v_mul_lo_u32 v1, v1, s23
	v_mul_lo_u32 v9, v9, s23
	v_sub_u32_e32 v0, v2, v0
	v_mul_lo_u32 v11, v11, s23
	v_sub_u32_e32 v1, v3, v1
	v_sub_u32_e32 v2, v7, v9
	v_subrev_u32_e32 v7, s23, v0
	v_cmp_le_u32_e32 vcc, s23, v0
	v_sub_u32_e32 v3, v8, v11
	v_subrev_u32_e32 v8, s23, v1
	v_cndmask_b32_e32 v0, v0, v7, vcc
	v_cmp_le_u32_e32 vcc, s23, v1
	v_subrev_u32_e32 v9, s23, v2
	v_subrev_u32_e32 v11, s23, v3
	v_cndmask_b32_e32 v1, v1, v8, vcc
	v_cmp_le_u32_e32 vcc, s23, v2
	v_subrev_u32_e32 v7, s23, v0
	v_xor_b32_e32 v6, s44, v6
	v_cndmask_b32_e32 v2, v2, v9, vcc
	v_cmp_le_u32_e32 vcc, s23, v3
	v_subrev_u32_e32 v8, s23, v1
	v_mul_hi_u32 v12, v6, v216
	v_cndmask_b32_e32 v3, v3, v11, vcc
	v_cmp_le_u32_e32 vcc, s23, v0
	v_subrev_u32_e32 v9, s23, v2
	v_mul_lo_u32 v12, v12, s15
	v_cndmask_b32_e32 v0, v0, v7, vcc
	v_cmp_le_u32_e32 vcc, s23, v1
	v_subrev_u32_e32 v11, s23, v3
	v_sub_u32_e32 v6, v6, v12
	v_cndmask_b32_e32 v1, v1, v8, vcc
	v_cmp_le_u32_e32 vcc, s23, v2
	v_or_b32_e32 v4, s36, v208
	v_subrev_u32_e32 v12, s15, v6
	v_cndmask_b32_e32 v2, v2, v9, vcc
	v_cmp_le_u32_e32 vcc, s23, v3
	v_add_u32_e32 v4, s44, v4
	v_xor_b32_e32 v4, s44, v4
	v_cndmask_b32_e32 v3, v3, v11, vcc
	v_cmp_le_u32_e32 vcc, s15, v6
	v_or_b32_e32 v5, s36, v209
	v_xor_b32_e32 v0, s45, v0
	v_cndmask_b32_e32 v6, v6, v12, vcc
	v_subrev_u32_e32 v12, s15, v6
	v_cmp_le_u32_e32 vcc, s15, v6
	v_xor_b32_e32 v1, s45, v1
	v_xor_b32_e32 v2, s45, v2
	v_cndmask_b32_e32 v6, v6, v12, vcc
	v_mul_hi_u32 v12, v4, v216
	v_mul_lo_u32 v12, v12, s15
	v_sub_u32_e32 v4, v4, v12
	v_subrev_u32_e32 v12, s15, v4
	v_cmp_le_u32_e32 vcc, s15, v4
	v_xor_b32_e32 v3, s45, v3
	v_subrev_u32_e32 v7, s45, v0
	v_cndmask_b32_e32 v4, v4, v12, vcc
	v_subrev_u32_e32 v12, s15, v4
	v_cmp_le_u32_e32 vcc, s15, v4
	v_xor_b32_e32 v6, s44, v6
	v_subrev_u32_e32 v8, s45, v1
	v_cndmask_b32_e32 v4, v4, v12, vcc
	v_xor_b32_e32 v4, s44, v4
	v_subrev_u32_e32 v12, s44, v4
	v_add_u32_e32 v4, s44, v5
	v_xor_b32_e32 v4, s44, v4
	v_mul_hi_u32 v5, v4, v216
	v_mul_lo_u32 v5, v5, s15
	v_sub_u32_e32 v4, v4, v5
	v_subrev_u32_e32 v5, s15, v4
	v_cmp_le_u32_e32 vcc, s15, v4
	v_subrev_u32_e32 v9, s45, v2
	v_subrev_u32_e32 v11, s45, v3
	v_cndmask_b32_e32 v4, v4, v5, vcc
	v_subrev_u32_e32 v5, s15, v4
	v_cmp_le_u32_e32 vcc, s15, v4
	v_subrev_u32_e32 v6, s44, v6
	v_mov_b32_e32 v147, v75
	v_cndmask_b32_e32 v4, v4, v5, vcc
	v_xor_b32_e32 v4, s44, v4
	v_subrev_u32_e32 v13, s44, v4
	s_mul_i32 s44, s6, s30
	v_mad_u64_u32 v[56:57], s[6:7], v7, s29, v[202:203]
	v_mul_lo_u32 v4, v10, s31
	v_mad_u64_u32 v[58:59], s[6:7], v8, s29, v[202:203]
	v_mad_u64_u32 v[60:61], s[6:7], v9, s29, v[202:203]
	v_mad_u64_u32 v[62:63], s[6:7], v11, s29, v[202:203]
	v_mul_lo_u32 v5, v6, s31
	v_mul_lo_u32 v6, v12, s31
	v_mul_lo_u32 v7, v13, s31
	v_add_u32_e32 v57, v4, v202
	v_add_u32_e32 v59, v5, v202
	v_add_u32_e32 v61, v6, v202
	v_add_u32_e32 v63, v7, v202
	v_add_u32_e32 v44, s44, v57
	s_mov_b32 s6, s26
	s_mov_b32 s7, s27
	v_add_u32_e32 v40, v56, v192
	v_add_u32_e32 v41, v58, v192
	v_add_u32_e32 v42, v60, v192
	v_add_u32_e32 v43, v62, v192
	v_add_u32_e32 v45, s44, v59
	v_add_u32_e32 v46, s44, v61
	v_add_u32_e32 v47, s44, v63
	buffer_load_dwordx4 v[8:11], v44, s[4:7], 0 offen
	buffer_load_dwordx4 v[12:15], v45, s[4:7], 0 offen
	buffer_load_dwordx4 v[16:19], v46, s[4:7], 0 offen
	buffer_load_dwordx4 v[20:23], v40, s[24:27], 0 offen
	buffer_load_dwordx4 v[24:27], v41, s[24:27], 0 offen
	buffer_load_dwordx4 v[28:31], v42, s[24:27], 0 offen
	buffer_load_dwordx4 v[32:35], v43, s[24:27], 0 offen
	buffer_load_dwordx4 v[36:39], v47, s[4:7], 0 offen
	s_and_b64 vcc, exec, s[8:9]
	v_mov_b32_e32 v146, v75
	v_mov_b32_e32 v145, v75
	v_mov_b32_e32 v144, v75
	v_mov_b32_e32 v151, v75
	v_mov_b32_e32 v150, v75
	v_mov_b32_e32 v149, v75
	v_mov_b32_e32 v148, v75
	v_mov_b32_e32 v155, v75
	v_mov_b32_e32 v154, v75
	v_mov_b32_e32 v153, v75
	v_mov_b32_e32 v152, v75
	v_mov_b32_e32 v159, v75
	v_mov_b32_e32 v158, v75
	v_mov_b32_e32 v157, v75
	v_mov_b32_e32 v156, v75
	v_mov_b32_e32 v163, v75
	v_mov_b32_e32 v162, v75
	v_mov_b32_e32 v161, v75
	v_mov_b32_e32 v160, v75
	v_mov_b32_e32 v167, v75
	v_mov_b32_e32 v166, v75
	v_mov_b32_e32 v165, v75
	v_mov_b32_e32 v164, v75
	v_mov_b32_e32 v171, v75
	v_mov_b32_e32 v170, v75
	v_mov_b32_e32 v169, v75
	v_mov_b32_e32 v168, v75
	v_mov_b32_e32 v175, v75
	v_mov_b32_e32 v174, v75
	v_mov_b32_e32 v173, v75
	v_mov_b32_e32 v172, v75
	v_mov_b32_e32 v179, v75
	v_mov_b32_e32 v178, v75
	v_mov_b32_e32 v177, v75
	v_mov_b32_e32 v176, v75
	v_mov_b32_e32 v183, v75
	v_mov_b32_e32 v182, v75
	v_mov_b32_e32 v181, v75
	v_mov_b32_e32 v180, v75
	v_mov_b32_e32 v187, v75
	v_mov_b32_e32 v186, v75
	v_mov_b32_e32 v185, v75
	v_mov_b32_e32 v184, v75
	v_mov_b32_e32 v191, v75
	v_mov_b32_e32 v190, v75
	v_mov_b32_e32 v189, v75
	v_mov_b32_e32 v188, v75
	v_mov_b32_e32 v43, v75
	v_mov_b32_e32 v42, v75
	v_mov_b32_e32 v41, v75
	v_mov_b32_e32 v40, v75
	v_mov_b32_e32 v47, v75
	v_mov_b32_e32 v46, v75
	v_mov_b32_e32 v45, v75
	v_mov_b32_e32 v44, v75
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(7)
	ds_write_b128 v218, v[8:11] offset:32768
	s_waitcnt vmcnt(6)
	ds_write_b128 v218, v[12:15] offset:40960
	s_waitcnt vmcnt(5)
	ds_write_b128 v218, v[16:19] offset:49152
	s_waitcnt vmcnt(4)
	ds_write_b128 v218, v[20:23]
	s_waitcnt vmcnt(3)
	ds_write_b128 v218, v[24:27] offset:8192
	s_waitcnt vmcnt(2)
	ds_write_b128 v218, v[28:31] offset:16384
	s_waitcnt vmcnt(1)
	ds_write_b128 v218, v[32:35] offset:24576
	s_waitcnt vmcnt(0)
	ds_write_b128 v218, v[36:39] offset:57344
	s_cbranch_vccnz .L9
	v_add_u32_e32 v3, v201, v3
	v_add_u32_e32 v2, v201, v2
	v_add_u32_e32 v1, v201, v1
	v_add_u32_e32 v0, v201, v0
	v_add_u32_e32 v8, s44, v206
	v_subrev_u32_e32 v3, s45, v3
	v_subrev_u32_e32 v2, s45, v2
	v_subrev_u32_e32 v1, s45, v1
	v_subrev_u32_e32 v0, s45, v0
	v_mov_b32_e32 v44, 0
	v_add_u32_e32 v193, v8, v7
	v_add_u32_e32 v194, v8, v6
	v_add_u32_e32 v195, v8, v5
	v_add_u32_e32 v196, v8, v4
	v_mad_u64_u32 v[64:65], s[6:7], s29, v3, v[206:207]
	v_mad_u64_u32 v[66:67], s[6:7], s29, v2, v[206:207]
	v_mad_u64_u32 v[68:69], s[6:7], s29, v1, v[206:207]
	v_mad_u64_u32 v[70:71], s[6:7], s29, v0, v[206:207]
	s_mov_b32 s45, 0
	v_mov_b32_e32 v45, v44
	v_mov_b32_e32 v46, v44
	v_mov_b32_e32 v47, v44
	v_mov_b32_e32 v40, v44
	v_mov_b32_e32 v41, v44
	v_mov_b32_e32 v42, v44
	v_mov_b32_e32 v43, v44
	v_mov_b32_e32 v188, v44
	v_mov_b32_e32 v189, v44
	v_mov_b32_e32 v190, v44
	v_mov_b32_e32 v191, v44
	v_mov_b32_e32 v184, v44
	v_mov_b32_e32 v185, v44
	v_mov_b32_e32 v186, v44
	v_mov_b32_e32 v187, v44
	v_mov_b32_e32 v180, v44
	v_mov_b32_e32 v181, v44
	v_mov_b32_e32 v182, v44
	v_mov_b32_e32 v183, v44
	v_mov_b32_e32 v176, v44
	v_mov_b32_e32 v177, v44
	v_mov_b32_e32 v178, v44
	v_mov_b32_e32 v179, v44
	v_mov_b32_e32 v172, v44
	v_mov_b32_e32 v173, v44
	v_mov_b32_e32 v174, v44
	v_mov_b32_e32 v175, v44
	v_mov_b32_e32 v168, v44
	v_mov_b32_e32 v169, v44
	v_mov_b32_e32 v170, v44
	v_mov_b32_e32 v171, v44
	v_mov_b32_e32 v164, v44
	v_mov_b32_e32 v165, v44
	v_mov_b32_e32 v166, v44
	v_mov_b32_e32 v167, v44
	v_mov_b32_e32 v160, v44
	v_mov_b32_e32 v161, v44
	v_mov_b32_e32 v162, v44
	v_mov_b32_e32 v163, v44
	v_mov_b32_e32 v156, v44
	v_mov_b32_e32 v157, v44
	v_mov_b32_e32 v158, v44
	v_mov_b32_e32 v159, v44
	v_mov_b32_e32 v152, v44
	v_mov_b32_e32 v153, v44
	v_mov_b32_e32 v154, v44
	v_mov_b32_e32 v155, v44
	v_mov_b32_e32 v148, v44
	v_mov_b32_e32 v149, v44
	v_mov_b32_e32 v150, v44
	v_mov_b32_e32 v151, v44
	v_mov_b32_e32 v144, v44
	v_mov_b32_e32 v145, v44
	v_mov_b32_e32 v146, v44
	v_mov_b32_e32 v147, v44
	v_mov_b32_e32 v140, v44
	v_mov_b32_e32 v141, v44
	v_mov_b32_e32 v142, v44
	v_mov_b32_e32 v143, v44
	v_mov_b32_e32 v136, v44
	v_mov_b32_e32 v137, v44
	v_mov_b32_e32 v138, v44
	v_mov_b32_e32 v139, v44
	v_mov_b32_e32 v132, v44
	v_mov_b32_e32 v133, v44
	v_mov_b32_e32 v134, v44
	v_mov_b32_e32 v135, v44
	v_mov_b32_e32 v128, v44
	v_mov_b32_e32 v129, v44
	v_mov_b32_e32 v130, v44
	v_mov_b32_e32 v131, v44
	v_mov_b32_e32 v124, v44
	v_mov_b32_e32 v125, v44
	v_mov_b32_e32 v126, v44
	v_mov_b32_e32 v127, v44
	v_mov_b32_e32 v120, v44
	v_mov_b32_e32 v121, v44
	v_mov_b32_e32 v122, v44
	v_mov_b32_e32 v123, v44
	v_mov_b32_e32 v116, v44
	v_mov_b32_e32 v117, v44
	v_mov_b32_e32 v118, v44
	v_mov_b32_e32 v119, v44
	v_mov_b32_e32 v112, v44
	v_mov_b32_e32 v113, v44
	v_mov_b32_e32 v114, v44
	v_mov_b32_e32 v115, v44
	v_mov_b32_e32 v108, v44
	v_mov_b32_e32 v109, v44
	v_mov_b32_e32 v110, v44
	v_mov_b32_e32 v111, v44
	v_mov_b32_e32 v104, v44
	v_mov_b32_e32 v105, v44
	v_mov_b32_e32 v106, v44
	v_mov_b32_e32 v107, v44
	v_mov_b32_e32 v100, v44
	v_mov_b32_e32 v101, v44
	v_mov_b32_e32 v102, v44
	v_mov_b32_e32 v103, v44
	v_mov_b32_e32 v96, v44
	v_mov_b32_e32 v97, v44
	v_mov_b32_e32 v98, v44
	v_mov_b32_e32 v99, v44
	v_mov_b32_e32 v92, v44
	v_mov_b32_e32 v93, v44
	v_mov_b32_e32 v94, v44
	v_mov_b32_e32 v95, v44
	v_mov_b32_e32 v88, v44
	v_mov_b32_e32 v89, v44
	v_mov_b32_e32 v90, v44
	v_mov_b32_e32 v91, v44
	v_mov_b32_e32 v84, v44
	v_mov_b32_e32 v85, v44
	v_mov_b32_e32 v86, v44
	v_mov_b32_e32 v87, v44
	v_mov_b32_e32 v80, v44
	v_mov_b32_e32 v81, v44
	v_mov_b32_e32 v82, v44
	v_mov_b32_e32 v83, v44
	v_mov_b32_e32 v76, v44
	v_mov_b32_e32 v77, v44
	v_mov_b32_e32 v78, v44
	v_mov_b32_e32 v79, v44
	v_mov_b32_e32 v72, v44
	v_mov_b32_e32 v73, v44
	v_mov_b32_e32 v74, v44
	v_mov_b32_e32 v75, v44
.L8:
	v_add_u32_e32 v0, s45, v70
	v_add_u32_e32 v1, s45, v68
	v_add_u32_e32 v2, s45, v66
	v_add_u32_e32 v3, s45, v64
	s_setprio 0
	buffer_load_dwordx4 v[32:35], v0, s[24:27], 0 offen
	buffer_load_dwordx4 v[36:39], v1, s[24:27], 0 offen
	buffer_load_dwordx4 v[48:51], v2, s[24:27], 0 offen
	buffer_load_dwordx4 v[52:55], v3, s[24:27], 0 offen
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_setprio 3
	ds_read_b128 v[0:3], v214 offset:32768
	ds_read_b128 v[4:7], v215 offset:32768
	ds_read_b128 v[226:229], v213
	ds_read_b128 v[222:225], v212
	ds_read_b128 v[8:11], v214 offset:40960
	ds_read_b128 v[12:15], v215 offset:40960
	ds_read_b128 v[230:233], v212 offset:4096
	ds_read_b128 v[234:237], v213 offset:4096
	ds_read_b128 v[28:31], v215 offset:49152
	ds_read_b128 v[24:27], v214 offset:49152
	ds_read_b128 v[16:19], v214 offset:57344
	ds_read_b128 v[20:23], v215 offset:57344
	s_waitcnt lgkmcnt(8)
	v_mfma_f32_16x16x128_f8f6f4 v[44:47], v[0:7], v[222:229], v[44:47]
	s_mov_b32 s6, s26
	s_mov_b32 s7, s27
	s_waitcnt lgkmcnt(6)
	v_mfma_f32_16x16x128_f8f6f4 v[40:43], v[8:15], v[222:229], v[40:43]
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[188:191], v[24:31], v[222:229], v[188:191]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[184:187], v[16:23], v[222:229], v[184:187]
	v_mfma_f32_16x16x128_f8f6f4 v[180:183], v[0:7], v[230:237], v[180:183]
	v_mfma_f32_16x16x128_f8f6f4 v[176:179], v[8:15], v[230:237], v[176:179]
	v_mfma_f32_16x16x128_f8f6f4 v[172:175], v[24:31], v[230:237], v[172:175]
	v_mfma_f32_16x16x128_f8f6f4 v[168:171], v[16:23], v[230:237], v[168:171]
	v_add_u32_e32 v238, s45, v196
	v_add_u32_e32 v242, s45, v195
	buffer_load_dwordx4 v[238:241], v238, s[4:7], 0 offen
	buffer_load_dwordx4 v[242:245], v242, s[4:7], 0 offen
	ds_read_b128 v[226:229], v213 offset:8192
	ds_read_b128 v[222:225], v212 offset:8192
	ds_read_b128 v[230:233], v212 offset:12288
	ds_read_b128 v[234:237], v213 offset:12288
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[164:167], v[0:7], v[222:229], v[164:167]
	v_mfma_f32_16x16x128_f8f6f4 v[160:163], v[8:15], v[222:229], v[160:163]
	v_mfma_f32_16x16x128_f8f6f4 v[156:159], v[24:31], v[222:229], v[156:159]
	v_mfma_f32_16x16x128_f8f6f4 v[152:155], v[16:23], v[222:229], v[152:155]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[148:151], v[0:7], v[230:237], v[148:151]
	v_mfma_f32_16x16x128_f8f6f4 v[144:147], v[8:15], v[230:237], v[144:147]
	v_mfma_f32_16x16x128_f8f6f4 v[140:143], v[24:31], v[230:237], v[140:143]
	v_mfma_f32_16x16x128_f8f6f4 v[136:139], v[16:23], v[230:237], v[136:139]
	ds_read_b128 v[226:229], v213 offset:16384
	ds_read_b128 v[222:225], v212 offset:16384
	ds_read_b128 v[230:233], v212 offset:20480
	ds_read_b128 v[234:237], v213 offset:20480
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[132:135], v[0:7], v[222:229], v[132:135]
	v_mfma_f32_16x16x128_f8f6f4 v[128:131], v[8:15], v[222:229], v[128:131]
	v_mfma_f32_16x16x128_f8f6f4 v[124:127], v[24:31], v[222:229], v[124:127]
	v_mfma_f32_16x16x128_f8f6f4 v[120:123], v[16:23], v[222:229], v[120:123]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[116:119], v[0:7], v[230:237], v[116:119]
	v_mfma_f32_16x16x128_f8f6f4 v[112:115], v[8:15], v[230:237], v[112:115]
	v_mfma_f32_16x16x128_f8f6f4 v[108:111], v[24:31], v[230:237], v[108:111]
	v_mfma_f32_16x16x128_f8f6f4 v[104:107], v[16:23], v[230:237], v[104:107]
	ds_read_b128 v[226:229], v213 offset:24576
	ds_read_b128 v[222:225], v212 offset:24576
	ds_read_b128 v[230:233], v212 offset:28672
	ds_read_b128 v[234:237], v213 offset:28672
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[100:103], v[0:7], v[222:229], v[100:103]
	v_mfma_f32_16x16x128_f8f6f4 v[96:99], v[8:15], v[222:229], v[96:99]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[84:87], v[0:7], v[230:237], v[84:87]
	v_add_u32_e32 v0, s45, v194
	v_add_u32_e32 v4, s45, v193
	v_mfma_f32_16x16x128_f8f6f4 v[80:83], v[8:15], v[230:237], v[80:83]
	buffer_load_dwordx4 v[0:3], v0, s[4:7], 0 offen
	buffer_load_dwordx4 v[4:7], v4, s[4:7], 0 offen
	s_addk_i32 s45, 0x80
	s_cmp_lg_u32 s43, s45
	s_barrier
	s_setprio 3
	v_mfma_f32_16x16x128_f8f6f4 v[92:95], v[24:31], v[222:229], v[92:95]
	s_waitcnt vmcnt(7)
	ds_write_b128 v218, v[32:35]
	s_waitcnt vmcnt(6)
	ds_write_b128 v218, v[36:39] offset:8192
	v_mfma_f32_16x16x128_f8f6f4 v[88:91], v[16:23], v[222:229], v[88:91]
	s_waitcnt vmcnt(5)
	ds_write_b128 v218, v[48:51] offset:16384
	s_waitcnt vmcnt(4)
	ds_write_b128 v218, v[52:55] offset:24576
	v_mfma_f32_16x16x128_f8f6f4 v[76:79], v[24:31], v[230:237], v[76:79]
	s_waitcnt vmcnt(3)
	ds_write_b128 v218, v[238:241] offset:32768
	s_waitcnt vmcnt(2)
	ds_write_b128 v218, v[242:245] offset:40960
	v_mfma_f32_16x16x128_f8f6f4 v[72:75], v[16:23], v[230:237], v[72:75]
	s_waitcnt vmcnt(1)
	ds_write_b128 v218, v[0:3] offset:49152
	s_waitcnt vmcnt(0)
	ds_write_b128 v218, v[4:7] offset:57344
	s_cbranch_scc1 .L8
.L9:
	s_andn2_b64 vcc, exec, s[10:11]
	v_add_u32_e32 v221, 0, v215
	v_add_u32_e32 v222, 0, v214
	v_add_u32_e32 v48, 0, v213
	v_add_u32_e32 v36, 0, v212
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_vccnz .L4
	ds_read_b128 v[4:7], v221 offset:32768
	ds_read_b128 v[0:3], v222 offset:32768
	ds_read_b128 v[68:71], v48
	ds_read_b128 v[64:67], v36
	ds_read_b128 v[12:15], v221 offset:40960
	ds_read_b128 v[8:11], v222 offset:40960
	ds_read_b128 v[16:19], v222 offset:49152
	ds_read_b128 v[20:23], v221 offset:49152
	ds_read_b128 v[28:31], v221 offset:57344
	ds_read_b128 v[24:27], v222 offset:57344
	s_waitcnt lgkmcnt(6)
	v_mfma_f32_16x16x128_f8f6f4 v[44:47], v[0:7], v[64:71], v[44:47]
	s_waitcnt lgkmcnt(4)
	v_mfma_f32_16x16x128_f8f6f4 v[40:43], v[8:15], v[64:71], v[40:43]
	s_waitcnt lgkmcnt(2)
	v_mfma_f32_16x16x128_f8f6f4 v[188:191], v[16:23], v[64:71], v[188:191]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[184:187], v[24:31], v[64:71], v[184:187]
	ds_read_b128 v[68:71], v48 offset:4096
	ds_read_b128 v[64:67], v36 offset:4096
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[180:183], v[0:7], v[64:71], v[180:183]
	v_mfma_f32_16x16x128_f8f6f4 v[176:179], v[8:15], v[64:71], v[176:179]
	v_mfma_f32_16x16x128_f8f6f4 v[172:175], v[16:23], v[64:71], v[172:175]
	v_mfma_f32_16x16x128_f8f6f4 v[168:171], v[24:31], v[64:71], v[168:171]
	ds_read_b128 v[68:71], v48 offset:8192
	ds_read_b128 v[64:67], v36 offset:8192
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[164:167], v[0:7], v[64:71], v[164:167]
	v_mfma_f32_16x16x128_f8f6f4 v[160:163], v[8:15], v[64:71], v[160:163]
	v_mfma_f32_16x16x128_f8f6f4 v[156:159], v[16:23], v[64:71], v[156:159]
	v_mfma_f32_16x16x128_f8f6f4 v[152:155], v[24:31], v[64:71], v[152:155]
	ds_read_b128 v[68:71], v48 offset:12288
	ds_read_b128 v[64:67], v36 offset:12288
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[148:151], v[0:7], v[64:71], v[148:151]
	v_mfma_f32_16x16x128_f8f6f4 v[144:147], v[8:15], v[64:71], v[144:147]
	v_mfma_f32_16x16x128_f8f6f4 v[140:143], v[16:23], v[64:71], v[140:143]
	v_mfma_f32_16x16x128_f8f6f4 v[136:139], v[24:31], v[64:71], v[136:139]
	ds_read_b128 v[68:71], v48 offset:16384
	ds_read_b128 v[64:67], v36 offset:16384
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[132:135], v[0:7], v[64:71], v[132:135]
	v_mfma_f32_16x16x128_f8f6f4 v[128:131], v[8:15], v[64:71], v[128:131]
	v_mfma_f32_16x16x128_f8f6f4 v[124:127], v[16:23], v[64:71], v[124:127]
	v_mfma_f32_16x16x128_f8f6f4 v[120:123], v[24:31], v[64:71], v[120:123]
	ds_read_b128 v[68:71], v48 offset:20480
	ds_read_b128 v[64:67], v36 offset:20480
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[116:119], v[0:7], v[64:71], v[116:119]
	v_mfma_f32_16x16x128_f8f6f4 v[112:115], v[8:15], v[64:71], v[112:115]
	v_mfma_f32_16x16x128_f8f6f4 v[108:111], v[16:23], v[64:71], v[108:111]
	v_mfma_f32_16x16x128_f8f6f4 v[104:107], v[24:31], v[64:71], v[104:107]
	ds_read_b128 v[68:71], v48 offset:24576
	ds_read_b128 v[64:67], v36 offset:24576
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[100:103], v[0:7], v[64:71], v[100:103]
	v_mfma_f32_16x16x128_f8f6f4 v[96:99], v[8:15], v[64:71], v[96:99]
	v_mfma_f32_16x16x128_f8f6f4 v[92:95], v[16:23], v[64:71], v[92:95]
	v_mfma_f32_16x16x128_f8f6f4 v[88:91], v[24:31], v[64:71], v[88:91]
	ds_read_b128 v[68:71], v48 offset:28672
	ds_read_b128 v[64:67], v36 offset:28672
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_16x16x128_f8f6f4 v[84:87], v[0:7], v[64:71], v[84:87]
	v_mfma_f32_16x16x128_f8f6f4 v[80:83], v[8:15], v[64:71], v[80:83]
	v_mfma_f32_16x16x128_f8f6f4 v[76:79], v[16:23], v[64:71], v[76:79]
	v_mfma_f32_16x16x128_f8f6f4 v[72:75], v[24:31], v[64:71], v[72:75]
	s_branch .L4
.L10:
	s_waitcnt vmcnt(0)
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
	s_nop 0
	s_nop 0
.Lfunc_end:
.size _grouped_fp8_persistent_gemm_kernel, .Lfunc_end-_grouped_fp8_persistent_gemm_kernel

.rodata
.p2align 6
.amdhsa_kernel _grouped_fp8_persistent_gemm_kernel
  .amdhsa_group_segment_fixed_size 0
  .amdhsa_private_segment_fixed_size 0
  .amdhsa_kernarg_size 96
  .amdhsa_next_free_vgpr 248
  .amdhsa_next_free_sgpr 56
  .amdhsa_accum_offset 248
  .amdhsa_float_round_mode_32 0
  .amdhsa_float_round_mode_16_64 0
  .amdhsa_float_denorm_mode_32 3
  .amdhsa_float_denorm_mode_16_64 3
  .amdhsa_ieee_mode 1
  .amdhsa_dx10_clamp 1
  .amdhsa_user_sgpr_kernarg_segment_ptr 1
  .amdhsa_user_sgpr_kernarg_preload_length 14
  .amdhsa_system_sgpr_workgroup_id_x 1
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.kernels:
  - .name: _grouped_fp8_persistent_gemm_kernel
    .symbol: _grouped_fp8_persistent_gemm_kernel.kd
    .kernarg_segment_size: 96
    .group_segment_fixed_size: 0
    .private_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .wavefront_size: 64
    .sgpr_count: 55
    .vgpr_count: 248
    .agpr_count: 0
    .max_flat_workgroup_size: 512
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
