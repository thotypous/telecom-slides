from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Rectangle


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "python_inputs.svg"


def box(ax, xy, w, h, text, fc, ec="#334155", color="#111827", size=7.6, weight=None, lw=1.05):
    x, y = xy
    ax.add_patch(
        FancyBboxPatch(
            (x, y),
            w,
            h,
            boxstyle="round,pad=0.025,rounding_size=0.06",
            facecolor=fc,
            edgecolor=ec,
            lw=lw,
            zorder=2,
        )
    )
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=size, color=color, weight=weight, zorder=5)


def arrow(ax, start, end, color="#334155", lw=1.15, mutation=9, rad=0.0):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle="-|>",
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            color=color,
            lw=lw,
            zorder=4,
            shrinkA=1.5,
            shrinkB=1.5,
        )
    )


def label(ax, xy, text, color="#334155", size=7.2, ha="center", va="center", weight=None):
    ax.text(*xy, text, ha=ha, va=va, fontsize=size, color=color, weight=weight, zorder=6)


def draw_wave(ax, x, y, w, h, color="#2563eb", burst=False):
    ax.add_patch(Rectangle((x, y), w, h, facecolor="#f8fafc", edgecolor="#cbd5e1", lw=0.6, zorder=2))
    t = np.linspace(0, 1, 80)
    if burst:
        env = np.exp(-((t - 0.52) / 0.22) ** 2)
        s = 0.5 + 0.30 * env * np.sin(2 * np.pi * 9 * t)
    else:
        s = 0.5 + 0.18 * np.sin(2 * np.pi * 4 * t) + 0.05 * np.sin(2 * np.pi * 17 * t)
    ax.plot(x + w * t, y + h * s, color=color, lw=0.9, zorder=5)


def main() -> None:
    fig, ax = plt.subplots(figsize=(12.8, 3.2), dpi=170)
    fig.patch.set_facecolor("white")
    ax.set_position([0, 0, 1, 1])
    ax.set_xlim(0.04, 12.84)
    ax.set_ylim(0.40, 3.64)
    ax.axis("off")

    blue_fc = "#eff6ff"
    blue_ec = "#60a5fa"
    green_fc = "#ecfdf5"
    green_ec = "#86efac"
    yellow_fc = "#fefce8"
    yellow_ec = "#facc15"
    slate_fc = "#f8fafc"
    slate_ec = "#94a3b8"
    purple_fc = "#f5f3ff"
    purple_ec = "#c4b5fd"
    line = "#334155"
    accent = "#2563eb"
    ok = "#16a34a"

    rows = [
        (2.72, "--testbench", "#1d4ed8", "TX sintético", "canal:\nAWGN/CFO/multipath", "decimação\n20 MS/s", True),
        (1.72, "--npz", "#0f766e", "arquivo .npz", "trechos I/Q\njá recortados", "seleciona\nvetor", True),
        (0.72, "--iq", "#854d0e", "arquivo I/Q\ncontínuo", "detector por\nlimiar |x[n]|", "recorta\ncandidato", False),
    ]

    label(ax, (1.02, 3.46), "modo de entrada", color="#0f172a", size=8.6, weight="bold")
    label(ax, (4.45, 3.46), "preparação antes do receptor", color="#0f172a", size=8.6, weight="bold")
    label(ax, (10.78, 3.46), "interface comum", color="#0f172a", size=8.6, weight="bold")

    for y, mode, mode_color, first, second, third, burst in rows:
        box(ax, (0.26, y), 1.48, 0.55, mode, blue_fc, blue_ec, color=mode_color, size=8.4, weight="bold")
        box(ax, (2.16, y), 1.25, 0.55, first, slate_fc, slate_ec, color="#334155", size=7.2, weight="bold")
        box(ax, (4.02, y), 1.54, 0.55, second, yellow_fc, yellow_ec, color="#854d0e", size=6.9, weight="bold")
        box(ax, (6.18, y), 1.24, 0.55, third, green_fc, green_ec, color="#166534", size=7.0, weight="bold")

        draw_wave(ax, 7.82, y + 0.11, 1.00, 0.33, color=mode_color, burst=burst)
        label(ax, (8.32, y - 0.11), "complex64", color="#475569", size=6.5)

        cy = y + 0.275
        arrow(ax, (1.74, cy), (2.16, cy), color=accent)
        arrow(ax, (3.41, cy), (4.02, cy), color=line)
        arrow(ax, (5.56, cy), (6.18, cy), color=line)
        arrow(ax, (7.42, cy), (7.82, cy), color=line)

    junction = (9.46, 2.00)
    for y, *_ in rows:
        arrow(ax, (8.82, y + 0.275), junction, color=ok, lw=1.2, mutation=9)

    box(
        ax,
        (10.05, 1.42),
        2.26,
        1.16,
        "`rx_waveform_20mhz`\n\nvetor complexo\n20 MS/s",
        purple_fc,
        purple_ec,
        color="#4c1d95",
        size=8.0,
        weight="bold",
        lw=1.25,
    )
    arrow(ax, junction, (10.05, 2.00), color=ok, lw=1.35, mutation=10)
    label(ax, (11.18, 1.12), "mesmo contrato para\npacket_detector e demais blocos", color="#475569", size=7.0)

    label(
        ax,
        (4.60, 0.42),
        "as fontes mudam como o vetor é obtido; o receptor começa sempre no mesmo tipo, taxa e sem referência de início",
        color="#475569",
        size=7.4,
        weight="bold",
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0)
    plt.close(fig)


if __name__ == "__main__":
    main()
