from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "pratica_pipeline.svg"


def rounded_box(ax, xy, w, h, text, fc, ec="#334155", color="#111827", size=9.0, weight=None, lw=1.2):
    x, y = xy
    ax.add_patch(
        FancyBboxPatch(
            (x, y),
            w,
            h,
            boxstyle="round,pad=0.03,rounding_size=0.08",
            facecolor=fc,
            edgecolor=ec,
            lw=lw,
            zorder=2,
        )
    )
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=size, color=color, weight=weight, zorder=5)


def arrow(ax, start, end, color="#334155", lw=1.25, rad=0.0, mutation=10, zorder=4):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle="-|>",
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            lw=lw,
            color=color,
            zorder=zorder,
            shrinkA=2,
            shrinkB=2,
        )
    )


def label(ax, xy, text, color="#334155", size=8.3, ha="center", va="center", weight=None):
    ax.text(*xy, text, ha=ha, va=va, fontsize=size, color=color, weight=weight, zorder=6)


def main() -> None:
    fig, ax = plt.subplots(figsize=(12.6, 3.0), dpi=170)
    fig.patch.set_facecolor("white")
    ax.set_position([0, 0, 1, 1])
    ax.set_xlim(0, 12.6)
    ax.set_ylim(0.55, 3.78)
    ax.axis("off")

    source_fc = "#eff6ff"
    source_ec = "#60a5fa"
    receiver_fc = "#f8fafc"
    receiver_ec = "#94a3b8"
    stage_fc = "#ecfeff"
    stage_ec = "#22d3ee"
    output_fc = "#f0fdf4"
    output_ec = "#86efac"
    line = "#334155"
    accent = "#2563eb"
    check = "#16a34a"

    label(ax, (1.13, 3.62), "fontes de amostras I/Q", color="#1d4ed8", size=9.5, weight="bold")
    sources = [
        (0.25, 2.64, "--testbench\nTX + canal"),
        (0.25, 1.74, "--npz\ntrechos gravados"),
        (0.25, 0.84, "--iq\nSDR bruto"),
    ]
    for x, y, text in sources:
        rounded_box(ax, (x, y), 1.82, 0.58, text, source_fc, source_ec, color="#1e3a8a", size=8.7, weight="bold")

    # Input fan-in: separate arrows converge before entering the receiver.
    junction = (2.36, 2.03)
    for _, y, _ in sources:
        arrow(ax, (2.10, y + 0.29), junction, color=accent, lw=1.45, mutation=11)
    arrow(ax, junction, (2.8, 2.03), color=accent, lw=1.55, mutation=12)

    ax.add_patch(
        FancyBboxPatch(
            (2.70, 0.78),
            7.75,
            2.56,
            boxstyle="round,pad=0.04,rounding_size=0.12",
            facecolor=receiver_fc,
            edgecolor=receiver_ec,
            lw=1.35,
            zorder=1,
        )
    )
    label(ax, (6.58, 3.08), "receptor OFDM 802.11a/g", color="#0f172a", size=10.0, weight="bold")

    stages = [
        ("detecção\nde pacote", 0.72),
        ("correção\nfreq.", 0.58),
        ("seq. longa\ncorr.", 0.76),
        ("FFT", 0.42),
        ("equaliz.", 0.66),
        ("pilotos", 0.54),
        ("demapper\nsoft", 0.70),
        ("deinter-\nleaver", 0.70),
        ("Viterbi", 0.55),
        ("descram-\nbler", 0.70),
    ]
    x = 2.78
    y = 1.76
    h = 0.58
    gap = 0.13
    bounds = []
    for text, w in stages:
        rounded_box(ax, (x, y), w, h, text, stage_fc, stage_ec, color="#155e75", size=7.3, weight="bold", lw=1.0)
        bounds.append((x, x + w))
        x += w + gap

    for (_, right), (left, _) in zip(bounds, bounds[1:]):
        arrow(ax, (right, y + h / 2), (left, y + h / 2), color=line, lw=1.0, mutation=8)

    label(ax, (6.55, 1.23), "mesma cadeia de recepção para as três fontes", color="#475569", size=8.0)

    outputs = [
        (10.94, 2.82, "SIGNAL"),
        (10.94, 2.14, "bytes\nPSDU"),
        (10.94, 1.46, "cauda\nok?"),
        (10.94, 0.78, "CRC\nok?"),
    ]
    label(ax, (11.62, 3.62), "saídas e validações", color="#166534", size=9.5, weight="bold")
    for x, y, text in outputs:
        rounded_box(ax, (x, y), 1.35, 0.52, text, output_fc, output_ec, color="#14532d", size=8.3, weight="bold")

    bus_x = 10.68
    ax.plot([bus_x, bus_x], [1.04, 3.08], color=check, lw=1.2, zorder=3)
    arrow(ax, (bounds[-1][1], 2.05), (bus_x, 2.05), color=check, lw=1.25, mutation=10)
    for x, y, _ in outputs:
        arrow(ax, (bus_x, y + 0.26), (x, y + 0.26), color=check, lw=1.0, mutation=8)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0)
    plt.close(fig)


if __name__ == "__main__":
    main()
