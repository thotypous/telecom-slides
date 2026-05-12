from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Arc, Circle, FancyArrowPatch


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "leo_doppler_geometria.svg"


def arrow(ax, start, end, color="#334155", lw=1.5, style="-|>", mutation=11, rad=0.0, zorder=6):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle=style,
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            lw=lw,
            color=color,
            zorder=zorder,
        )
    )


def draw_satellite(ax, x, y, label, dx=0.0, ha="center"):
    ax.add_patch(Circle((x, y), 0.055, facecolor="#f8fafc", edgecolor="#1f2937", lw=1.0, zorder=8))
    ax.plot([x - 0.13, x - 0.06], [y, y], color="#1f2937", lw=1.0, zorder=8)
    ax.plot([x + 0.06, x + 0.13], [y, y], color="#1f2937", lw=1.0, zorder=8)
    ax.add_patch(Circle((x - 0.16, y), 0.035, facecolor="#93c5fd", edgecolor="#1d4ed8", lw=0.8, zorder=8))
    ax.add_patch(Circle((x + 0.16, y), 0.035, facecolor="#93c5fd", edgecolor="#1d4ed8", lw=0.8, zorder=8))
    ax.text(x + dx, y + 0.17, label, ha=ha, va="bottom", fontsize=9.0, color="#111827", zorder=9)


def main() -> None:
    fig = plt.figure(figsize=(7.2, 5.2), dpi=160)
    fig.patch.set_facecolor("white")
    gs = fig.add_gridspec(2, 1, height_ratios=[1.35, 1.0], hspace=0.18)
    ax_geo = fig.add_subplot(gs[0])
    ax_plot = fig.add_subplot(gs[1])

    # Geometry panel.
    ax_geo.set_aspect("equal")
    ax_geo.set_xlim(-3.05, 3.05)
    ax_geo.set_ylim(-0.35, 2.75)
    ax_geo.axis("off")

    ground = Arc((0, -3.25), 7.4, 7.4, theta1=58, theta2=122, color="#64748b", lw=2.0)
    ax_geo.add_patch(ground)
    station = (0.0, 0.47)
    ax_geo.plot([station[0] - 0.22, station[0] + 0.22], [station[1] - 0.11, station[1] - 0.11], color="#334155", lw=1.5)
    ax_geo.plot([station[0], station[0]], [station[1] - 0.11, station[1] + 0.15], color="#334155", lw=1.6)
    ax_geo.plot([station[0] - 0.12, station[0], station[0] + 0.12], [station[1] + 0.04, station[1] + 0.15, station[1] + 0.04], color="#334155", lw=1.3)
    ax_geo.text(0, 0.12, "estação", ha="center", va="top", fontsize=9.5, color="#334155")

    theta = np.linspace(155, 25, 180) * np.pi / 180
    cx, cy = 0.0, -0.62
    rx, ry = 2.55, 2.55
    x_orb = cx + rx * np.cos(theta)
    y_orb = cy + ry * np.sin(theta)
    ax_geo.plot(x_orb, y_orb, color="#2563eb", lw=2.1, zorder=2)
    arrow(ax_geo, (x_orb[70], y_orb[70]), (x_orb[88], y_orb[88]), color="#2563eb", lw=1.8, mutation=12)

    points = {
        "AOS": 145,
        "TCA\nzênite": 90,
        "LOS": 35,
    }
    sat_positions = []
    for label, deg in points.items():
        th = np.deg2rad(deg)
        x = cx + rx * np.cos(th)
        y = cy + ry * np.sin(th)
        sat_positions.append((label, x, y, th))
        label_dx = -0.12 if label == "AOS" else 0.12 if label == "LOS" else 0.0
        draw_satellite(ax_geo, x, y, label, dx=label_dx)
        ax_geo.plot([station[0], x], [station[1], y], color="#cbd5e1", lw=1.0, ls="--", zorder=1)

    for label, x, y, th in sat_positions:
        tangent = np.array([-rx * np.sin(th), ry * np.cos(th)])
        tangent = tangent / np.linalg.norm(tangent)
        if tangent[0] < 0:
            tangent = -tangent
        v_start = np.array([x, y])
        v_end = v_start + 0.42 * tangent
        arrow(ax_geo, v_start, v_end, color="#dc2626", lw=1.4, mutation=10)
        ax_geo.text(v_end[0] + 0.05, v_end[1] + 0.02, r"$v$", color="#dc2626", fontsize=9.2)

        los_vec = np.array(station) - v_start
        los_unit = los_vec / np.linalg.norm(los_vec)
        radial = 0.34 * np.dot(tangent, los_unit) * los_unit
        if np.linalg.norm(radial) > 0.04:
            arrow(ax_geo, v_start + np.array([0.02, -0.02]), v_start + np.array([0.02, -0.02]) + radial, color="#7c3aed", lw=1.25, mutation=9)
            ax_geo.text(v_start[0] + radial[0] + 0.08, v_start[1] + radial[1] - 0.07, r"$v_r$", color="#7c3aed", fontsize=9.0)

    ax_geo.text(-2.75, 2.45, "aproximação", ha="left", va="center", fontsize=9.5, color="#334155")
    ax_geo.text(2.75, 2.45, "afastamento", ha="right", va="center", fontsize=9.5, color="#334155")

    # Doppler panel.
    t = np.linspace(-1, 1, 400)
    f = -np.tanh(2.6 * t)
    ax_plot.plot(t, f, color="#2563eb", lw=2.5)
    ax_plot.axhline(0, color="#475569", lw=1.0)
    ax_plot.axvline(0, color="#94a3b8", lw=1.0, ls="--")
    ax_plot.set_xlim(-1.05, 1.05)
    ax_plot.set_ylim(-1.18, 1.18)
    ax_plot.set_xticks([-1, 0, 1])
    ax_plot.set_xticklabels(["AOS", "TCA", "LOS"])
    ax_plot.set_yticks([-1, 0, 1])
    ax_plot.set_yticklabels([r"$f_0 - \Delta f_{max}$", r"$f_0$", r"$f_0 + \Delta f_{max}$"])
    ax_plot.set_xlabel("tempo da passagem", fontsize=10.3)
    ax_plot.set_ylabel("frequência recebida", fontsize=10.3)
    ax_plot.grid(True, color="#e2e8f0", lw=0.8)
    ax_plot.spines[["top", "right"]].set_visible(False)
    ax_plot.text(-0.70, 0.66, "aproximação:\nfrequência sobe", ha="center", va="center", fontsize=9.2, color="#1d4ed8")
    ax_plot.text(0.70, -0.66, "afastamento:\nfrequência desce", ha="center", va="center", fontsize=9.2, color="#1d4ed8")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
