from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyArrowPatch, Rectangle


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "hairpin_match.svg"


def arrow(ax, start, end, color="#334155", lw=1.4, style="-|>", rad=0.0, mutation=11):
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


def capacitor(ax, x, y, color="#d8b4fe"):
    dash = (0, (3, 2))
    ax.plot([x - 0.18, x - 0.055], [y, y], color=color, lw=2.0, ls=dash, zorder=10)
    ax.plot([x + 0.055, x + 0.18], [y, y], color=color, lw=2.0, ls=dash, zorder=10)
    ax.plot([x - 0.055, x - 0.055], [y - 0.18, y + 0.18], color=color, lw=2.0, ls=dash, zorder=10)
    ax.plot([x + 0.055, x + 0.055], [y - 0.18, y + 0.18], color=color, lw=2.0, ls=dash, zorder=10)


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 5.0), dpi=160)
    fig.patch.set_facecolor("white")
    ax.set_aspect("equal")
    ax.set_xlim(-3.15, 3.15)
    ax.set_ylim(-1.85, 2.35)
    ax.axis("off")

    metal = "#1f2937"
    active = "#2563eb"
    stub = "#b45309"
    cap = "#a855f7"

    # Slightly short driven element at the bottom.
    y_active = -0.78
    ax.plot([-2.05, -0.26], [y_active, y_active], color=active, lw=5.0, solid_capstyle="round", zorder=5)
    ax.plot([0.26, 2.05], [y_active, y_active], color=active, lw=5.0, solid_capstyle="round", zorder=5)

    # Feed terminals.
    left_terminal = (-0.26, y_active)
    right_terminal = (0.26, y_active)
    for x in [-0.26, 0.26]:
        ax.add_patch(Circle((x, y_active), 0.07, facecolor="white", edgecolor=metal, lw=1.6, zorder=9))

    # Dotted series capacitance representation on the short active element.
    capacitor(ax, -1.02, y_active, cap)
    ax.text(-1.02, y_active - 0.30, r"$-jX_C$", ha="center", va="top", fontsize=11.5, color=cap)

    # Inverted-U hairpin stub in parallel with the active element.
    y_top = 1.35
    ax.plot([-0.26, -0.26], [y_active, y_top], color=stub, lw=4.0, solid_capstyle="round", zorder=6)
    ax.plot([0.26, 0.26], [y_active, y_top], color=stub, lw=4.0, solid_capstyle="round", zorder=6)
    ax.plot([-0.26, 0.26], [y_top, y_top], color=stub, lw=4.0, solid_capstyle="round", zorder=6)
    ax.text(0, y_top + 0.22, "hairpin", ha="center", va="bottom", fontsize=11.0, color=stub, weight="bold")
    ax.text(0.52, 0.47, r"$+jX_L$", ha="left", va="center", fontsize=12.5, color=stub)

    # Coax and 50 ohm result.
    ax.plot([0, 0], [-1.55, y_active - 0.07], color=metal, lw=2.0, zorder=3)
    ax.add_patch(Rectangle((-0.18, -1.66), 0.36, 0.34, facecolor="#e5e7eb", edgecolor=metal, lw=1.1, zorder=4))
    ax.text(0.36, -1.44, "coax 50 Ω", ha="left", va="center", fontsize=10.5, color=metal)

    # Impedance callouts.
    ax.text(
        -2.78,
        -0.05,
        "ativo curto\n" r"$Z_A = R_a - jX_C$",
        ha="left",
        va="center",
        fontsize=10.8,
        color=active,
        bbox=dict(boxstyle="round,pad=0.28", fc="#eff6ff", ec="#93c5fd", lw=0.9),
    )
    arrow(ax, (-1.55, -0.18), (-0.72, y_active + 0.05), color=active, rad=-0.08)
    ax.text(
        1.52,
        0.98,
        "stub curto\n" r"reatância $+jX_L$",
        ha="left",
        va="center",
        fontsize=10.8,
        color=stub,
        bbox=dict(boxstyle="round,pad=0.28", fc="#fff7ed", ec="#fdba74", lw=0.9),
    )
    arrow(ax, (1.46, 0.82), (0.31, 0.82), color=stub, rad=0.08)

    ax.text(
        0,
        2.08,
        r"paralelo nos terminais: $(R_a - jX_C) \parallel (+jX_L) \rightarrow 50\,\Omega$",
        ha="center",
        va="center",
        fontsize=11.2,
        color="#111827",
        bbox=dict(boxstyle="round,pad=0.35", fc="#f8fafc", ec="#cbd5e1", lw=0.9),
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
