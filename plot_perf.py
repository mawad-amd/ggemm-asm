#!/usr/bin/env python3
"""Generate performance comparison bar chart."""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

kernels = ['Reference\n(Triton)', 'Optimized\n(ASM)']
tflops = [1120, 1251]
times_ms = [3.882, 3.476]
peak = 1340

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4.5))

colors = ['#888888', '#e63946']

# TFLOPS
bars1 = ax1.bar(kernels, tflops, color=colors, width=0.5, edgecolor='white', linewidth=0.5)
ax1.axhline(y=peak, color='#333333', linestyle='--', linewidth=1, label=f'Peak FP8 ({peak} TFLOPS)')
ax1.set_ylabel('TFLOPS')
ax1.set_ylim(0, peak * 1.15)
ax1.legend(loc='upper left', framealpha=0.9)
for bar, val in zip(bars1, tflops):
    ax1.text(bar.get_x() + bar.get_width()/2, val + 20, f'{val}', ha='center', va='bottom', fontweight='bold')

# Latency
bars2 = ax2.bar(kernels, times_ms, color=colors, width=0.5, edgecolor='white', linewidth=0.5)
ax2.set_ylabel('Time (ms)')
ax2.set_ylim(0, max(times_ms) * 1.25)
for bar, val in zip(bars2, times_ms):
    ax2.text(bar.get_x() + bar.get_width()/2, val + 0.05, f'{val:.3f}', ha='center', va='bottom', fontweight='bold')
ax2.text(0.95, 0.95, '+13.2%', transform=ax2.transAxes, ha='right', va='top',
         fontsize=14, fontweight='bold', color='#e63946')

fig.suptitle('FP8 Grouped GEMM Wgrad — MI355X (gfx950)\ngate_up_wgrad: E=32, M=131072, OUT_M=2880, OUT_N=5760',
             fontsize=11)
fig.tight_layout()
fig.savefig('perf.png', dpi=150, bbox_inches='tight', facecolor='white')
print('Saved perf.png')
