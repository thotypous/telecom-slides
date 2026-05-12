from pathlib import Path as FilePath

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import FancyArrowPatch, PathPatch
from matplotlib.path import Path as MplPath


plt.rcParams["svg.fonttype"] = "none"


OUT = FilePath(__file__).resolve().parent / "fig" / "efie_geometria.svg"


def blob_path(center=(0.95, 0.0), scale=1.0):
    theta = np.linspace(0, 2 * np.pi, 180, endpoint=True)
    r = 1.0 + 0.12 * np.sin(3 * theta + 0.4) + 0.08 * np.cos(5 * theta)
    x = center[0] + scale * 0.95 * r * np.cos(theta)
    y = center[1] + scale * 0.72 * r * np.sin(theta)
    vertices = np.column_stack([x, y])
    codes = np.full(len(vertices), MplPath.LINETO)
    codes[0] = MplPath.MOVETO
    return MplPath(vertices, codes)


def arrow(ax, start, end, color, lw=1.8, style="-|>", rad=0.0, zorder=5):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle=style,
            mutation_scale=13,
            connectionstyle=f"arc3,rad={rad}",
            lw=lw,
            color=color,
            zorder=zorder,
        )
    )


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 5.0), dpi=160)
    fig.patch.set_facecolor("white")
    ax.set_aspect("equal")
    ax.set_xlim(-3.0, 3.25)
    ax.set_ylim(-2.15, 2.15)
    ax.axis("off")

    # Region 1 background.
    ax.text(-2.75, 1.78, "região 1", fontsize=13, weight="bold", color="#475569")
    ax.text(-2.75, 1.53, "meio externo", fontsize=10.5, color="#64748b")

    # Incident source at left.
    source_x = -2.15
    source_y = 0.08
    t = np.linspace(-0.55, 0.55, 140)
    ax.plot(source_x + 0.10 * np.sin(12 * np.pi * (t + 0.55)), source_y + t, color="#7c3aed", lw=2.0)
    ax.text(source_x - 0.45, source_y + 0.82, r"fonte $J_{inc}$", fontsize=12, color="#5b21b6")
    arrow(ax, (-1.78, 0.15), (-0.18, 0.15), "#7c3aed", lw=2.0)
    ax.text(-1.22, 0.38, r"$E_{inc}$", fontsize=13, color="#5b21b6")

    # Conducting obstacle and its boundary S.
    conductor = PathPatch(blob_path(), facecolor="#d7dee8", edgecolor="#1f2937", lw=2.2, zorder=3)
    ax.add_patch(conductor)
    ax.text(0.86, 0.03, "condutor\nperfeito", ha="center", va="center", fontsize=12, color="#111827", weight="bold")
    ax.text(1.16, -1.03, r"superfície $S$", ha="center", fontsize=12, color="#1f2937")

    # Surface current and outward normal.
    arrow(ax, (0.35, 0.82), (1.18, 0.98), "#dc2626", lw=2.0, rad=0.18)
    ax.text(0.61, 1.18, r"$J_s$ induzida", fontsize=12, color="#b91c1c")
    arrow(ax, (1.66, 0.45), (2.28, 0.85), "#0f766e", lw=2.0)
    ax.text(2.36, 0.88, r"$\hat{n}$", fontsize=14, color="#0f766e")

    # Scattered field from induced current.
    arrow(ax, (1.72, -0.18), (2.82, -0.62), "#2563eb", lw=2.0, rad=-0.1)
    ax.text(2.10, -0.92, r"$E_{esp}(J_s)$", fontsize=12.5, color="#1d4ed8")
    arrow(ax, (0.15, -0.78), (-0.95, -1.20), "#2563eb", lw=1.8, rad=0.12)

    # Tangential boundary condition.
    ax.plot([0.08, 1.62], [-1.42, -1.42], color="#334155", lw=1.3)
    ax.text(0.85, -1.68, r"na superfície: $(E_{inc}+E_{esp})_t = 0$", ha="center", fontsize=12.2, color="#111827")
    ax.text(0.85, -1.92, r"incógnita da EFIE: $J_s$ em $S$", ha="center", fontsize=11.3, color="#475569")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
