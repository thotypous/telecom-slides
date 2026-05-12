from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, Rectangle


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "vna_diagrama_blocos.svg"


def box(ax, xy, w, h, text, fc, ec="#334155", color="#111827", size=10.5, weight=None):
    x, y = xy
    ax.add_patch(Rectangle((x, y), w, h, facecolor=fc, edgecolor=ec, lw=1.2, zorder=2))
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=size, color=color, weight=weight, zorder=5)


def arrow(ax, start, end, color="#334155", lw=1.45, style="-|>", rad=0.0, mutation=10):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle=style,
            mutation_scale=mutation,
            connectionstyle=f"arc3,rad={rad}",
            lw=lw,
            color=color,
            zorder=4,
        )
    )


def label(ax, xy, text, color="#334155", size=9.5, ha="center", va="center"):
    ax.text(*xy, text, ha=ha, va=va, fontsize=size, color=color, zorder=6)


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.2, 5.0), dpi=160)
    fig.patch.set_facecolor("white")
    ax.set_xlim(0, 7.2)
    ax.set_ylim(0, 5.0)
    ax.axis("off")

    vna_fc = "#ecfdf5"
    dut_fc = "#eff6ff"
    sig = "#2563eb"
    refl = "#dc2626"
    thru = "#16a34a"
    ref = "#7c3aed"

    # VNA enclosure and DUT.
    ax.add_patch(Rectangle((0.25, 0.45), 6.70, 3.42, facecolor=vna_fc, edgecolor="#86efac", lw=1.4, zorder=0))
    label(ax, (0.55, 3.68), "NanoVNA", color="#166534", size=11.5, ha="left", va="center")
    box(ax, (4.55, 4.18), 1.35, 0.52, "DUT", dut_fc, ec="#60a5fa", size=11.5, weight="bold")

    # Source, splitter and receivers.
    box(ax, (0.62, 2.70), 1.05, 0.55, "oscilador\nfonte", "#f8fafc", size=9.8)
    box(ax, (2.02, 2.70), 1.05, 0.55, "divisor", "#f8fafc", size=10.2)
    box(ax, (0.70, 1.55), 0.95, 0.48, "R0\nreferência", "#f5f3ff", ec="#c4b5fd", color=ref, size=9.2)
    box(ax, (3.05, 1.55), 0.95, 0.48, "R1\nreflexão", "#fef2f2", ec="#fca5a5", color=refl, size=9.2)
    box(ax, (5.45, 1.55), 1.10, 0.48, "R2\ntransmissão", "#f0fdf4", ec="#86efac", color=thru, size=9.2)
    box(ax, (2.05, 0.70), 3.10, 0.52, "processamento digital", "#f8fafc", size=10.5, weight="bold")

    # Ports.
    box(ax, (3.65, 2.72), 0.78, 0.42, "CH0\nREFL", "#e0f2fe", ec="#38bdf8", size=8.8)
    box(ax, (5.78, 2.72), 0.78, 0.42, "CH1\nTHRU", "#e0f2fe", ec="#38bdf8", size=8.8)

    # Signal paths inside the VNA and through the DUT.
    arrow(ax, (1.67, 2.98), (2.02, 2.98), sig)
    arrow(ax, (3.07, 2.98), (3.65, 2.98), sig)
    arrow(ax, (4.43, 2.98), (4.92, 4.18), sig, rad=0.05)
    label(ax, (4.22, 3.64), "incidente", color=sig, size=9.2)

    arrow(ax, (4.86, 4.18), (3.80, 2.06), refl, rad=-0.10)
    label(ax, (3.30, 2.48), "refletido", color=refl, size=9.2, ha="left")

    arrow(ax, (5.22, 4.18), (6.17, 3.14), thru, rad=-0.03)
    arrow(ax, (6.17, 2.72), (6.00, 2.03), thru)
    label(ax, (6.00, 3.45), "transmitido", color=thru, size=9.2, ha="left")

    # Reference and receiver paths.
    arrow(ax, (2.54, 2.70), (1.18, 2.03), ref, rad=0.12)
    label(ax, (1.95, 2.18), "amostra\nde referência", color=ref, size=8.8)
    arrow(ax, (3.52, 1.55), (3.10, 1.22), refl)
    arrow(ax, (5.92, 1.55), (4.60, 1.22), thru)
    arrow(ax, (1.18, 1.55), (2.48, 1.22), ref)

    # Computed ratios.
    ax.text(3.60, 0.20, r"$S_{11}=$ refletido/incidente   $S_{21}=$ transmitido/incidente", ha="center", va="center", fontsize=10.2, color="#111827")

    # Clarify that CH1 is only used for two-port transmission measurements.
    ax.text(5.50, 2.60, "usado em\nmedidas S21", ha="center", va="top", fontsize=8.8, color="#475569")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
