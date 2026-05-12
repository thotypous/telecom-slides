from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Arc, Circle, FancyArrowPatch


plt.rcParams["svg.fonttype"] = "none"


OUT = Path(__file__).resolve().parent / "fig" / "yagi_uda_5_elementos.svg"


def arrow(ax, start, end, color="#1f2937", lw=1.8, style="-|>", rad=0.0, mutation=13):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle=style,
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            lw=lw,
            color=color,
            zorder=8,
        )
    )


def dimension(ax, x0, x1, y, label):
    ax.plot([x0, x0], [y - 0.07, y + 0.07], color="#475569", lw=1.0)
    ax.plot([x1, x1], [y - 0.07, y + 0.07], color="#475569", lw=1.0)
    arrow(ax, (x0, y), (x1, y), color="#475569", lw=1.0, style="<->", mutation=10)
    if label:
        ax.text((x0 + x1) / 2, y - 0.18, label, ha="center", va="top", fontsize=9.5, color="#475569")


def draw_straight_element(ax, x, length, color, label, sublabel):
    y0, y1 = -length / 2, length / 2
    ax.plot([x, x], [y0, y1], color=color, lw=5.2, solid_capstyle="round", zorder=6)
    ax.plot([x, x], [y0, y1], color="white", lw=1.0, alpha=0.35, zorder=7)
    ax.text(x, y1 + 0.23, label, ha="center", va="bottom", fontsize=10.7, weight="bold", color=color)
    ax.text(x, y0 - 0.23, sublabel, ha="center", va="top", fontsize=9.3, color=color)


def draw_folded_dipole(ax, x, length):
    y0, y1 = -length / 2, length / 2
    sep = 0.10
    color = "#2563eb"
    ax.plot([x - sep, x - sep], [y0 + 0.12, y1 - 0.12], color=color, lw=3.4, solid_capstyle="round", zorder=6)
    ax.plot([x + sep, x + sep], [y0 + 0.12, y1 - 0.12], color=color, lw=3.4, solid_capstyle="round", zorder=6)
    ax.add_patch(Arc((x, y1 - 0.12), 2 * sep, 0.24, theta1=0, theta2=180, color=color, lw=3.4, zorder=6))
    ax.add_patch(Arc((x, y0 + 0.12), 2 * sep, 0.24, theta1=180, theta2=360, color=color, lw=3.4, zorder=6))
    ax.add_patch(Circle((x, 0), 0.095, facecolor="#ffffff", edgecolor=color, lw=2.0, zorder=9))
    ax.plot([x - 0.055, x + 0.055], [0, 0], color=color, lw=2.2, zorder=10)
    ax.text(x, y1 + 0.23, "ativo", ha="center", va="bottom", fontsize=10.7, weight="bold", color=color)
    ax.text(x, y0 - 0.23, "dipolo\ndobrado", ha="center", va="top", fontsize=9.3, color=color)
    ax.text(x + 0.15, 0.16, "alimentação", ha="left", va="bottom", fontsize=9.2, color=color)


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 4.5), dpi=160)
    fig.patch.set_facecolor("white")
    ax.set_xlim(-0.75, 4.95)
    ax.set_ylim(-1.9, 1.75)
    ax.axis("off")

    x_positions = [0.0, 1.05, 2.05, 2.95, 3.82]
    lengths = [1.58, 1.42, 1.30, 1.20, 1.10]

    # Boom.
    ax.plot([-0.35, 4.35], [0, 0], color="#334155", lw=6.0, solid_capstyle="round", zorder=1)
    ax.plot([-0.35, 4.35], [0, 0], color="#94a3b8", lw=1.1, alpha=0.7, zorder=2)
    ax.text(2.45, -0.18, "boom", ha="center", va="top", fontsize=10.5, color="#334155")

    draw_straight_element(ax, x_positions[0], lengths[0], "#7c2d12", "refletor", "+5%")
    draw_folded_dipole(ax, x_positions[1], lengths[1])
    draw_straight_element(ax, x_positions[2], lengths[2], "#047857", "diretor 1", "0,45 λ")
    draw_straight_element(ax, x_positions[3], lengths[3], "#047857", "diretor 2", "0,43 λ")
    draw_straight_element(ax, x_positions[4], lengths[4], "#047857", "diretor 3", "0,41 λ")

    # Beam direction and front/back labels.
    arrow(ax, (2.20, 1.42), (4.55, 1.42), color="#dc2626", lw=2.2, mutation=15)
    ax.text(3.35, 1.56, "feixe principal", ha="center", va="bottom", fontsize=12, weight="bold", color="#b91c1c")
    ax.text(-0.18, 1.33, "traseira", ha="center", va="center", fontsize=10.5, color="#475569")
    ax.text(4.48, 1.18, "frente", ha="center", va="center", fontsize=10.5, color="#475569")

    # Typical spacing dimensions.
    dimension(ax, x_positions[1], x_positions[2], -1.43, "")
    dimension(ax, x_positions[2], x_positions[3], -1.43, "")
    ax.text(2.0, -1.70, r"espaçamento típico: 0,15–0,25 $\lambda$", ha="center", fontsize=9.8, color="#475569")

    # Polarization indication.
    arrow(ax, (-0.48, -0.52), (-0.48, 0.52), color="#6d28d9", lw=1.8, style="<->", mutation=12)
    ax.text(-0.62, 0.0, "polarização\nlinear", ha="right", va="center", fontsize=9.8, color="#6d28d9")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
