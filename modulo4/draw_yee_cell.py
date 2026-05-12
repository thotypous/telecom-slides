from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import FancyArrowPatch, Polygon


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "celula_yee.svg"


def project(point):
    x, y, z = point
    return np.array([x + 0.55 * z, y + 0.34 * z])


def arrow(ax, p0, p1, color, lw=2.0, mutation=12, zorder=6):
    p0 = project(p0)
    p1 = project(p1)
    ax.add_patch(
        FancyArrowPatch(
            p0,
            p1,
            arrowstyle="-|>",
            mutation_scale=mutation,
            lw=lw,
            color=color,
            zorder=zorder,
        )
    )


def text3(ax, point, label, color="#111827", size=10.5, ha="center", va="center", weight=None):
    x, y = project(point)
    ax.text(x, y, label, color=color, fontsize=size, ha=ha, va=va, weight=weight, zorder=10)


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 5.0), dpi=160)
    fig.patch.set_facecolor("white")
    ax.set_aspect("equal")
    ax.axis("off")

    e_color = "#dc2626"
    h_color = "#2563eb"
    grid_color = "#475569"

    corners = {
        "000": (0, 0, 0),
        "100": (1, 0, 0),
        "010": (0, 1, 0),
        "110": (1, 1, 0),
        "001": (0, 0, 1),
        "101": (1, 0, 1),
        "011": (0, 1, 1),
        "111": (1, 1, 1),
    }

    faces = [
        ["000", "100", "110", "010"],
        ["100", "101", "111", "110"],
        ["010", "110", "111", "011"],
    ]
    face_colors = ["#f8fafc", "#eef6ff", "#f1f5f9"]
    for face, color in zip(faces, face_colors):
        ax.add_patch(
            Polygon([project(corners[key]) for key in face], closed=True, facecolor=color, edgecolor="none", alpha=0.88, zorder=0)
        )

    edges = [
        ("000", "100"), ("010", "110"), ("001", "101"), ("011", "111"),
        ("000", "010"), ("100", "110"), ("001", "011"), ("101", "111"),
        ("000", "001"), ("100", "101"), ("010", "011"), ("110", "111"),
    ]
    for a, b in edges:
        pa, pb = project(corners[a]), project(corners[b])
        ax.plot([pa[0], pb[0]], [pa[1], pb[1]], color=grid_color, lw=1.25, zorder=2)

    # Electric-field samples on staggered edges.
    arrow(ax, (0.15, 0, 0), (0.85, 0, 0), e_color)
    text3(ax, (0.50, -0.11, 0), r"$E_x$", e_color, size=11)
    arrow(ax, (0, 0.15, 0.08), (0, 0.85, 0.08), e_color)
    text3(ax, (-0.10, 0.54, 0.08), r"$E_y$", e_color, size=11, ha="right")
    arrow(ax, (1.02, 0.06, 0.15), (1.02, 0.06, 0.85), e_color)
    text3(ax, (1.12, 0.02, 0.52), r"$E_z$", e_color, size=11, ha="left")

    # Magnetic-field samples centered on faces.
    arrow(ax, (0.50, 0.50, 0.05), (0.50, 0.50, 0.42), h_color, lw=2.1)
    text3(ax, (0.52, 0.54, 0.49), r"$H_z$", h_color, size=11, ha="left")
    arrow(ax, (1.04, 0.28, 0.50), (1.04, 0.74, 0.50), h_color, lw=2.1)
    text3(ax, (1.08, 0.82, 0.50), r"$H_y$", h_color, size=11, ha="left")
    arrow(ax, (0.28, 1.04, 0.50), (0.74, 1.04, 0.50), h_color, lw=2.1)
    text3(ax, (0.81, 1.08, 0.50), r"$H_x$", h_color, size=11, ha="left")

    # Coordinate axes.
    origin = (-0.28, -0.28, -0.05)
    arrow(ax, origin, (0.18, -0.28, -0.05), "#111827", lw=1.2, mutation=9, zorder=3)
    arrow(ax, origin, (-0.28, 0.18, -0.05), "#111827", lw=1.2, mutation=9, zorder=3)
    arrow(ax, origin, (-0.28, -0.28, 0.38), "#111827", lw=1.2, mutation=9, zorder=3)
    text3(ax, (0.24, -0.30, -0.05), r"$x$", size=9.5)
    text3(ax, (-0.31, 0.25, -0.05), r"$y$", size=9.5)
    text3(ax, (-0.30, -0.30, 0.45), r"$z$", size=9.5)

    # Time staggering and curl note.
    ax.text(2.22, 1.38, "amostragem intercalada", fontsize=12, weight="bold", color="#111827", ha="center")
    ax.text(2.22, 1.15, r"$E$: tempo $t$", fontsize=11, color=e_color, ha="center")
    ax.text(2.22, 0.95, r"$H$: tempo $t + \Delta t/2$", fontsize=11, color=h_color, ha="center")
    ax.text(2.22, 0.61, "atualização por\nrotacionais discretos", fontsize=10.5, color="#475569", ha="center", va="center")

    ax.set_xlim(-0.55, 2.95)
    ax.set_ylim(-0.45, 1.55)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
