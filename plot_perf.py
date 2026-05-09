#!/usr/bin/env python3
"""Generate performance comparison plots for wgrad GEMM optimization."""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

sites = ['gate_up_wgrad\n(2880x5760)', 'down_wgrad\n(2880x2880)']

legacy_ref_ms = [3.896, 2.201]
legacy_asm_ms = [3.526, 1.953]
ds_triton_ms  = [2.578, 1.341]
ds_asm_ms     = [2.558, 1.338]

legacy_ref_t  = [1116, 988]
legacy_asm_t  = [1233, 1113]
ds_triton_t   = [1687, 1621]
ds_asm_t      = [1700, 1625]

colors = ['#7f8c8d', '#95a5a6', '#3498db', '#e74c3c']
labels = [
    'Legacy Triton ref',
    'Legacy ASM (1.10-1.13x)',
    'dot_scaled Triton (1.51-1.64x)',
    'dot_scaled ASM v2 (1.52-1.64x)',
]

x = np.arange(len(sites))
w = 0.18

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
bg = '#1a1a2e'
fig.patch.set_facecolor(bg)

for i, (data, label, color) in enumerate(zip(
    [legacy_ref_ms, legacy_asm_ms, ds_triton_ms, ds_asm_ms], labels, colors)):
    bars = ax1.bar(x + (i - 1.5) * w, data, w, label=label, color=color,
                   edgecolor='#2a2a4a', linewidth=0.5)
    for bar, val in zip(bars, data):
        ax1.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.05,
                 f'{val:.2f}', ha='center', va='bottom', fontsize=7,
                 fontweight='bold', color='white')

ax1.set_ylabel('Latency (ms)', fontsize=11, color='white')
ax1.set_xticks(x)
ax1.set_xticklabels(sites, fontsize=10, color='white')
ax1.set_ylim(0, 4.8)
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax1.spines['bottom'].set_color('#555')
ax1.spines['left'].set_color('#555')
ax1.tick_params(colors='white')
ax1.set_facecolor(bg)

for i, (data, label, color) in enumerate(zip(
    [legacy_ref_t, legacy_asm_t, ds_triton_t, ds_asm_t], labels, colors)):
    bars = ax2.bar(x + (i - 1.5) * w, data, w, label=label, color=color,
                   edgecolor='#2a2a4a', linewidth=0.5)
    for bar, val in zip(bars, data):
        ax2.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 20,
                 f'{val}', ha='center', va='bottom', fontsize=7,
                 fontweight='bold', color='white')

ax2.set_ylabel('TFLOPS', fontsize=11, color='white')
ax2.set_xticks(x)
ax2.set_xticklabels(sites, fontsize=10, color='white')
ax2.set_ylim(0, 2800)
ax2.axhline(y=2610, color='#888', linestyle='--', linewidth=0.8, alpha=0.7)
ax2.text(1.35, 2640, 'MI355X FP8 peak (2610)', fontsize=7, color='#aaa', ha='right')
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)
ax2.spines['bottom'].set_color('#555')
ax2.spines['left'].set_color('#555')
ax2.tick_params(colors='white')
ax2.set_facecolor(bg)

handles, lbls = ax2.get_legend_handles_labels()
fig.legend(handles, lbls, loc='upper center', ncol=2, fontsize=8.5,
           bbox_to_anchor=(0.5, 1.02), frameon=False, labelcolor='white')

fig.suptitle('FP8 Grouped GEMM Wgrad — MI355X (gfx950)',
             fontsize=13, fontweight='bold', y=1.08, color='white')

plt.tight_layout()
fig.savefig('perf.png', dpi=180, bbox_inches='tight', facecolor=bg)
fig.savefig('tflops.png', dpi=180, bbox_inches='tight', facecolor=bg)
print('Saved perf.png and tflops.png')
