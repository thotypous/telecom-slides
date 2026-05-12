from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Circle, FancyArrowPatch, Rectangle, Wedge


plt.rcParams["svg.fonttype"] = "none"


OUT = Path(__file__).resolve().parent / "fig" / "campo_proximo_distante.svg"


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 5.2), dpi=160)
    ax.set_aspect("equal")
    ax.set_xlim(-3.3, 3.3)
    ax.set_ylim(-2.45, 2.45)
    ax.axis("off")
    fig.patch.set_facecolor("white")

    boundary = 1.05


    # Background regions.
    ax.add_patch(Circle((0, 0), 3.05, facecolor="#eef5ff", edgecolor="none", zorder=0))
    ax.add_patch(Circle((0, 0), boundary, facecolor="#fff0d6", edgecolor="none", zorder=1))
    ax.add_patch(Circle((0, 0), boundary, fill=False, edgecolor="#d98400", lw=2.2, ls="--", zorder=4))

    # Radiated wave fronts in the far field.
    for radius, alpha in [(1.55, 0.85), (2.05, 0.65), (2.55, 0.45), (3.0, 0.3)]:
        ax.add_patch(
            Wedge(
                (0, 0),
                radius,
                0,
                360,
                width=0.025,
                facecolor="#2d77c7",
                edgecolor="none",
                alpha=alpha,
                zorder=2,
            )
        )

    # Reactive near-field loops.
    for angle in [25, 80, 140, 205, 285]:
        ax.add_patch(
            FancyArrowPatch(
                posA=(0.48 * np.cos(np.deg2rad(angle)), 0.48 * np.sin(np.deg2rad(angle))),
                posB=(0.74 * np.cos(np.deg2rad(angle + 45)), 0.74 * np.sin(np.deg2rad(angle + 45))),
                connectionstyle="arc3,rad=0.45",
                arrowstyle="-|>",
                mutation_scale=10,
                lw=1.2,
                color="#c56a00",
                alpha=0.9,
                zorder=5,
            )
        )

    # Center-fed vertical antenna.
    ax.add_patch(Rectangle((-0.035, -0.72), 0.07, 1.44, facecolor="#222222", edgecolor="none", zorder=8))
    ax.add_patch(Circle((0, 0), 0.12, facecolor="#222222", edgecolor="white", lw=0.8, zorder=9))
    ax.plot([-0.27, 0.27], [-0.86, -0.86], color="#222222", lw=2.2, zorder=8)
    ax.plot([0, 0], [-0.86, -0.72], color="#222222", lw=2.2, zorder=8)

    # Radius marker for lambda/(2 pi).
    ax.annotate(
        "",
        xy=(boundary, 0),
        xytext=(0, 0),
        arrowprops=dict(arrowstyle="<->", lw=1.3, color="#4a4a4a"),
        zorder=10,
    )
    ax.text(0.52, -0.2, r"$\lambda/(2\pi)$", ha="center", va="top", fontsize=12, color="#333333")

    # Outward propagation arrows.
    for y in [-0.9, 0.0, 0.9]:
        ax.annotate(
            "",
            xy=(2.85, y),
            xytext=(1.55, y * 0.65),
            arrowprops=dict(arrowstyle="->", lw=1.5, color="#1f5f9f"),
            zorder=6,
        )

    ax.text(-1.15, 1.72, "Campo próximo", ha="center", va="center", fontsize=13.5, weight="bold", color="#8a4b00")
    ax.text(-1.15, 1.45, r"$r \ll \lambda/(2\pi)$", ha="center", va="center", fontsize=11.5, color="#8a4b00")
    ax.text(0, -1.35, r"termos reativos", ha="center", va="center", fontsize=11, color="#8a4b00")
    ax.text(0, -1.62, r"$1/r^2$ e $1/r^3$", ha="center", va="center", fontsize=13, weight="bold", color="#8a4b00")

    ax.text(2.12, 1.72, "Campo distante", ha="center", va="center", fontsize=13.5, weight="bold", color="#17558f")
    ax.text(2.12, 1.45, r"$r \gg \lambda/(2\pi)$", ha="center", va="center", fontsize=11.5, color="#17558f")
    ax.text(2.15, -1.45, r"termo radiado $1/r$", ha="center", va="center", fontsize=13, weight="bold", color="#17558f")
    ax.text(2.15, -1.76, "energia se propaga", ha="center", va="center", fontsize=11, color="#17558f")

    ax.text(
        0,
        -2.22,
        r"Exemplo: em 145,8 MHz, $\lambda \approx 2{,}06\,$m e $\lambda/(2\pi) \approx 33\,$cm",
        ha="center",
        va="center",
        fontsize=11.5,
        color="#222222",
        bbox=dict(boxstyle="round,pad=0.35", fc="white", ec="#bbbbbb", lw=0.8),
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
