from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "final_bit_decode.svg"


def box(ax, xy, w, h, text, fc, ec="#334155", color="#111827", size=7.4, weight=None, lw=1.05):
    x, y = xy
    ax.add_patch(
        FancyBboxPatch(
            (x, y),
            w,
            h,
            boxstyle="round,pad=0.022,rounding_size=0.055",
            facecolor=fc,
            edgecolor=ec,
            lw=lw,
            zorder=2,
        )
    )
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=size, color=color, weight=weight, zorder=5)


def arrow(ax, start, end, color="#334155", lw=1.05, mutation=8, rad=0.0, style="-|>"):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle=style,
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            color=color,
            lw=lw,
            zorder=4,
            shrinkA=1.5,
            shrinkB=1.5,
        )
    )


def label(ax, xy, text, color="#334155", size=7.0, ha="center", va="center", weight=None):
    ax.text(*xy, text, ha=ha, va=va, fontsize=size, color=color, weight=weight, zorder=6)


def main() -> None:
    fig, ax = plt.subplots(figsize=(13.0, 3.05), dpi=170)
    fig.patch.set_facecolor("white")
    ax.set_position([0, 0, 1, 1])
    ax.set_xlim(0.05, 13.05)
    ax.set_ylim(0.34, 3.22)
    ax.axis("off")

    signal_fc = "#eff6ff"
    signal_ec = "#60a5fa"
    data_fc = "#ecfdf5"
    data_ec = "#86efac"
    stage_fc = "#fefce8"
    stage_ec = "#facc15"
    check_fc = "#f5f3ff"
    check_ec = "#c4b5fd"
    bad_fc = "#fef2f2"
    bad_ec = "#fca5a5"
    line = "#334155"
    signal = "#2563eb"
    data = "#16a34a"
    verify = "#7c3aed"

    label(ax, (0.78, 2.92), "campo SIGNAL", color=signal, size=8.6, weight="bold")
    label(ax, (0.78, 1.66), "campo DATA", color=data, size=8.6, weight="bold")

    # SIGNAL path.
    sig_y = 2.28
    sig_steps = [
        (0.35, 0.92, "48 símbolos\nSIGNAL", signal_fc, signal_ec, signal, 7.1),
        (1.62, 0.92, "demapper\nBPSK", stage_fc, stage_ec, "#854d0e", 6.8),
        (2.88, 0.92, "deinter-\nleaver", stage_fc, stage_ec, "#854d0e", 6.8),
        (4.14, 0.80, "Viterbi", stage_fc, stage_ec, "#854d0e", 7.2),
        (5.28, 1.24, "parser\nRATE/LENGTH\nPARITY/TAIL", signal_fc, signal_ec, signal, 6.5),
    ]
    sig_bounds = []
    for x, w, text, fc, ec, color, size in sig_steps:
        box(ax, (x, sig_y), w, 0.48, text, fc, ec, color=color, size=size, weight="bold")
        sig_bounds.append((x, x + w))
    for (_, right), (left, _) in zip(sig_bounds, sig_bounds[1:]):
        arrow(ax, (right, sig_y + 0.24), (left, sig_y + 0.24), color=line)

    box(ax, (6.88, sig_y), 0.88, 0.48, "parity_ok", check_fc, check_ec, color=verify, size=7.0, weight="bold")
    box(ax, (7.98, sig_y), 0.70, 0.48, "tail_ok", check_fc, check_ec, color=verify, size=7.0, weight="bold")
    ax.plot([6.52, 6.70, 6.70], [sig_y + 0.10, sig_y + 0.10, sig_y + 0.24], color=verify, lw=0.90, zorder=3)
    arrow(ax, (6.70, sig_y + 0.24), (6.88, sig_y + 0.24), color=verify, lw=0.90)
    ax.plot([6.52, 6.64, 6.64, 8.30], [sig_y + 0.02, sig_y + 0.02, sig_y - 0.10, sig_y - 0.10], color=verify, lw=0.85, zorder=3)
    arrow(ax, (8.30, sig_y - 0.11), (8.30, sig_y), color=verify, lw=0.85)

    box(ax, (9.00, sig_y), 1.38, 0.48, "MCS +\nLENGTH", signal_fc, signal_ec, color=signal, size=7.0, weight="bold")
    arrow(ax, (8.68, sig_y + 0.24), (9.00, sig_y + 0.24), color=signal, lw=1.05)
    label(ax, (9.80, 1.98), "parametriza\nDATA", color=signal, size=6.8, weight="bold", ha="left")
    arrow(ax, (9.70, sig_y), (9.70, 1.86), color=signal, lw=1.0, mutation=8)

    # DATA path.
    data_y = 0.98
    data_steps = [
        (0.35, 0.94, "símbolos\nDATA", data_fc, data_ec, data, 7.2),
        (1.58, 1.08, "demapper\npor taxa", stage_fc, stage_ec, "#854d0e", 6.8),
        (2.94, 1.04, "deinterleaver\npor simbolo", stage_fc, stage_ec, "#854d0e", 6.3),
        (4.28, 0.78, "Viterbi", stage_fc, stage_ec, "#854d0e", 7.2),
        (5.34, 0.96, "descram-\nbler", stage_fc, stage_ec, "#854d0e", 6.8),
        (6.60, 1.16, "SERVICE\nPSDU\nTAIL", data_fc, data_ec, data, 6.5),
        (8.04, 0.82, "pack\nbits", stage_fc, stage_ec, "#854d0e", 6.8),
        (9.14, 0.82, "CRC32", stage_fc, stage_ec, "#854d0e", 7.1),
    ]
    data_bounds = []
    for x, w, text, fc, ec, color, size in data_steps:
        box(ax, (x, data_y), w, 0.52, text, fc, ec, color=color, size=size, weight="bold")
        data_bounds.append((x, x + w))
    for (_, right), (left, _) in zip(data_bounds, data_bounds[1:]):
        arrow(ax, (right, data_y + 0.26), (left, data_y + 0.26), color=line)

    ax.plot([9.70, 9.70, 1.58], [sig_y, 1.80, 1.80], color=signal, lw=0.95, zorder=3)
    arrow(ax, (1.58, 1.81), (1.58, data_y + 0.56), color=signal, lw=0.95, mutation=8)
    label(ax, (4.18, 1.90), "RATE define BPSK/QPSK/16-QAM/64-QAM, code rate e tamanho", color=signal, size=6.5)

    box(ax, (10.26, data_y), 0.76, 0.52, "crc_ok", check_fc, check_ec, color=verify, size=7.0, weight="bold")
    box(ax, (11.28, data_y), 1.30, 0.52, "bytes\nPSDU", data_fc, data_ec, color=data, size=7.2, weight="bold")
    arrow(ax, (9.96, data_y + 0.26), (10.26, data_y + 0.26), color=verify, lw=0.95)
    arrow(ax, (11.02, data_y + 0.26), (11.28, data_y + 0.26), color=data, lw=1.05)

    # Failure meaning: compact but visually separate.
    box(ax, (10.92, 2.16), 1.64, 0.64, "se falhar:\ndescarta ou\nmarca inválido", bad_fc, bad_ec, color="#991b1b", size=6.8, weight="bold")
    ax.plot([7.32, 7.32, 11.75], [sig_y + 0.48, 2.92, 2.92], color="#dc2626", lw=0.8, zorder=3)
    arrow(ax, (11.75, 2.93), (11.75, 2.80), color="#dc2626", lw=0.8)
    arrow(ax, (10.64, data_y + 0.52), (11.75, 2.16), color="#dc2626", lw=0.8, rad=0.08)

    label(
        ax,
        (6.52, 0.48),
        "SIGNAL escolhe como DATA será interpretado; DATA produz bytes, mas CRC apenas valida plausibilidade",
        color="#475569",
        size=7.3,
        weight="bold",
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0)
    plt.close(fig)


if __name__ == "__main__":
    main()
