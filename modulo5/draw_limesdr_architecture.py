from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Arc, Circle, FancyArrowPatch, FancyBboxPatch, Rectangle


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "limesdr_architecture.svg"


def rounded_box(ax, xy, w, h, text, fc, ec="#334155", color="#111827", size=8.6, weight=None, lw=1.15):
    x, y = xy
    ax.add_patch(
        FancyBboxPatch(
            (x, y),
            w,
            h,
            boxstyle="round,pad=0.025,rounding_size=0.07",
            facecolor=fc,
            edgecolor=ec,
            lw=lw,
            zorder=2,
        )
    )
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=size, color=color, weight=weight, zorder=5)


def arrow(ax, start, end, color="#334155", lw=1.25, rad=0.0, mutation=10, style="-|>", zorder=4):
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
            shrinkA=1.5,
            shrinkB=1.5,
        )
    )


def elbow_arrow(ax, points, color="#334155", lw=1.0, mutation=8, zorder=4):
    ax.plot(
        [point[0] for point in points[:-1]],
        [point[1] for point in points[:-1]],
        color=color,
        lw=lw,
        solid_capstyle="round",
        solid_joinstyle="round",
        zorder=zorder,
    )
    arrow(ax, points[-2], points[-1], color=color, lw=lw, mutation=mutation, style="->", zorder=zorder)


def label(ax, xy, text, color="#334155", size=8.2, ha="center", va="center", weight=None):
    ax.text(*xy, text, ha=ha, va=va, fontsize=size, color=color, weight=weight, zorder=6)


def draw_mixer(ax, center, label_text, color):
    x, y = center
    ax.add_patch(Circle((x, y), 0.18, facecolor="#fff7ed", edgecolor=color, lw=1.1, zorder=3))
    ax.plot([x - 0.095, x + 0.095], [y - 0.095, y + 0.095], color=color, lw=1.0, zorder=4)
    ax.plot([x - 0.095, x + 0.095], [y + 0.095, y - 0.095], color=color, lw=1.0, zorder=4)
    label(ax, (x, y + 0.25), label_text, color=color, size=7.4, weight="bold")


def draw_antenna(ax):
    x = 0.58
    ax.plot([x, x], [1.18, 2.30], color="#0f172a", lw=2.2, solid_capstyle="round", zorder=4)
    ax.plot([x - 0.26, x + 0.26], [1.18, 1.18], color="#0f172a", lw=1.7, solid_capstyle="round", zorder=4)
    ax.plot([x, x - 0.18], [2.30, 2.58], color="#0f172a", lw=1.8, solid_capstyle="round", zorder=4)
    ax.plot([x, x + 0.18], [2.30, 2.58], color="#0f172a", lw=1.8, solid_capstyle="round", zorder=4)
    for radius in (0.38, 0.62, 0.86):
        ax.add_patch(Arc((x, 2.48), radius, radius, theta1=25, theta2=155, color="#2563eb", lw=1.05, zorder=3))
    label(ax, (0.58, 0.86), "antena Wi-Fi\n2,4/5 GHz", color="#1e3a8a", size=8.0, weight="bold")


def main() -> None:
    fig, ax = plt.subplots(figsize=(13.4, 3.15), dpi=170)
    fig.patch.set_facecolor("white")
    ax.set_position([0, 0, 1, 1])
    ax.set_xlim(0.08, 13.48)
    ax.set_ylim(0.38, 3.16)
    ax.axis("off")

    line = "#334155"
    rf = "#2563eb"
    iq_i = "#0284c7"
    iq_q = "#ea580c"
    digital = "#16a34a"
    lo = "#7c3aed"

    draw_antenna(ax)
    arrow(ax, (1.02, 1.75), (1.48, 1.75), color=rf, lw=1.45, mutation=12)

    # LimeSDR enclosure: RFIC, converters and FPGA before samples leave over USB.
    ax.add_patch(
        FancyBboxPatch(
            (1.50, 0.56),
            7.05,
            2.36,
            boxstyle="round,pad=0.035,rounding_size=0.11",
            facecolor="#f8fafc",
            edgecolor="#94a3b8",
            lw=1.35,
            zorder=0,
        )
    )
    label(ax, (5.03, 2.72), "LimeSDR", color="#0f172a", size=10.3, weight="bold")
    label(ax, (5.03, 2.50), "RF configurável + ADCs + FPGA", color="#475569", size=7.8)

    rounded_box(ax, (1.78, 1.36), 1.26, 0.74, "front-end RF\nfiltros + LNA/VGA", "#eff6ff", ec="#60a5fa", color="#1e3a8a", size=7.4, weight="bold")
    label(ax, (2.40, 1.16), "seleção de canal\ne ganho", color="#475569", size=6.8)

    rounded_box(ax, (3.02, 0.62), 1.05, 0.40, "LO config.", "#f5f3ff", ec="#c4b5fd", color=lo, size=7.3, weight="bold")

    draw_mixer(ax, (3.68, 2.02), "mist. I", iq_i)
    draw_mixer(ax, (3.68, 1.34), "mist. Q", iq_q)

    arrow(ax, (3.04, 1.73), (3.45, 2.02), color=rf, lw=1.15, mutation=9)
    arrow(ax, (3.04, 1.73), (3.45, 1.34), color=rf, lw=1.15, mutation=9)
    arrow(ax, (3.68, 1.02), (3.68, 1.16), color=lo, lw=1.0, mutation=7)
    elbow_arrow(ax, [(4.07, 0.82), (4.18, 0.82), (4.18, 1.75), (3.68, 1.75), (3.68, 1.88)], color=lo, lw=1.0, mutation=7)

    rounded_box(ax, (4.35, 1.78), 0.72, 0.43, "ADC I", "#ecfeff", ec="#22d3ee", color=iq_i, size=7.4, weight="bold")
    rounded_box(ax, (4.35, 1.10), 0.72, 0.43, "ADC Q", "#fff7ed", ec="#fdba74", color=iq_q, size=7.4, weight="bold")
    arrow(ax, (3.86, 2.02), (4.35, 2.00), color=iq_i, lw=1.05, mutation=8)
    arrow(ax, (3.86, 1.34), (4.35, 1.31), color=iq_q, lw=1.05, mutation=8)

    rounded_box(ax, (5.45, 1.27), 1.24, 0.88, "FPGA\nstream I/Q", "#f0fdf4", ec="#86efac", color="#166534", size=8.0, weight="bold")
    arrow(ax, (5.07, 2.00), (5.45, 1.90), color=iq_i, lw=1.05, mutation=8)
    arrow(ax, (5.07, 1.31), (5.45, 1.52), color=iq_q, lw=1.05, mutation=8)
    label(ax, (5.02, 0.82), "amostras complexas\nem banda base", color="#475569", size=7.1)

    rounded_box(ax, (7.15, 1.40), 0.92, 0.62, "USB\n3.0", "#e0f2fe", ec="#38bdf8", color="#075985", size=8.0, weight="bold")
    arrow(ax, (6.69, 1.71), (7.15, 1.71), color=digital, lw=1.35, mutation=10)
    arrow(ax, (8.07, 1.71), (9.08, 1.71), color=digital, lw=1.5, mutation=12)
    label(ax, (8.45, 1.80), "I/Q", color=digital, size=7.6, weight="bold")

    # Host computer enclosure: visualization and offline receiver used in the practice.
    ax.add_patch(
        FancyBboxPatch(
            (8.82, 0.56),
            4.44,
            2.36,
            boxstyle="round,pad=0.035,rounding_size=0.11",
            facecolor="#fffbeb",
            edgecolor="#facc15",
            lw=1.35,
            zorder=0,
        )
    )
    label(ax, (11.04, 2.72), "computador", color="#713f12", size=10.1, weight="bold")

    rounded_box(ax, (9.08, 1.58-0.30), 1.25, 0.86, "", "#fefce8", ec="#fde047", color="#854d0e", size=7.8, weight="bold")
    rounded_box(ax, (10.68, 1.67-0.30), 0.92, 0.72, "arquivo\nI/Q", "#f8fafc", ec="#94a3b8", color="#334155", size=8.0, weight="bold")
    rounded_box(ax, (12.02, 1.54-0.30), 1.02, 0.98, "Python\nreceptor\n802.11a/g", "#ecfdf5", ec="#86efac", color="#166534", size=7.5, weight="bold")

    arrow(ax, (10.33, 1.71), (10.68, 1.71), color="#ca8a04", lw=1.15, mutation=9)
    arrow(ax, (11.60, 1.71), (12.02, 1.71), color=digital, lw=1.25, mutation=10)
    label(ax, (11.10, 1.16), "grava captura", color="#475569", size=6.9)
    label(ax, (12.52, 1.10), "sincronização\nOFDM e bits", color="#166534", size=7.0)

    # Tiny display hints sit below the title inside the GNU Radio block.
    label(ax, (9.70, 2.26-0.30), "GNU Radio", color="#854d0e", size=7.5, weight="bold")
    label(ax, (9.70, 2.06-0.30), "espectro + constelação", color="#854d0e", size=5.8)
    ax.add_patch(Rectangle((9.18, 1.70-0.30), 0.42, 0.20, facecolor="#dbeafe", edgecolor="#60a5fa", lw=0.6, zorder=5))
    ax.plot([9.21, 9.30, 9.39, 9.50, 9.57], [1.75-0.30, 1.83-0.30, 1.76-0.30, 1.86-0.30, 1.78-0.30], color="#2563eb", lw=0.7, zorder=6)
    for px, py in ((9.78, 1.76-0.30), (9.84, 1.86-0.30), (9.94, 1.74-0.30), (10.00, 1.88-0.30)):
        ax.add_patch(Circle((px, py), 0.018, facecolor="#7c3aed", edgecolor="none", zorder=6))

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0)
    plt.close(fig)


if __name__ == "__main__":
    main()
