from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "yagi_ganho_vs_boom.svg"


def main() -> None:
    points_x = np.array([0.1, 0.3, 1.0, 3.0])
    points_y = np.array([5.0, 7.0, 9.5, 13.0])
    labels = ["2 el.\n~5 dBi", "3 el.\n~7 dBi", "5 el.\n~9–10 dBi", "10 el.\n~13 dBi"]
    x = np.linspace(0.08, 3.2, 500)
    y = np.interp(np.log10(x), np.log10(points_x), points_y)

    fig, ax = plt.subplots(figsize=(7.2, 5.0), dpi=160)
    fig.patch.set_facecolor("white")

    ax.plot(x, y, color="#2563eb", lw=2.8)
    ax.scatter(points_x, points_y, s=58, color="#dc2626", edgecolor="white", linewidth=1.0, zorder=5)

    offsets = [(0.22, -0.15), (0.31, 0.55), (0.04, 1.12), (-0.45, 0.62)]
    for px, py, label, (dx, dy) in zip(points_x, points_y, labels, offsets):
        ax.annotate(
            label,
            xy=(px, py),
            xytext=(px + dx, py + dy),
            arrowprops=dict(arrowstyle="->", color="#7f1d1d", lw=1.0),
            fontsize=10.2,
            color="#7f1d1d",
            ha="center",
            va="center",
        )

    ax.text(
        1.78,
        5.15,
        r"ordem de grandeza: dobrar o boom dá $\approx +3$ dB",
        ha="center",
        va="center",
        fontsize=11.3,
        color="#1e3a8a",
        bbox=dict(boxstyle="round,pad=0.35", fc="#eff6ff", ec="#93c5fd", lw=0.9),
    )

    ax.set_xlim(0, 3.25)
    ax.set_ylim(3.8, 13.9)
    ax.set_xlabel(r"comprimento do boom $L_{boom}/\lambda$", fontsize=11.5)
    ax.set_ylabel(r"ganho $G$ (dBi)", fontsize=11.5)
    ax.set_xticks([0.1, 0.3, 1.0, 2.0, 3.0])
    ax.set_xticklabels(["0,1", "0,3", "1", "2", "3"])
    ax.set_yticks([4, 5, 7, 9, 11, 13])
    ax.grid(True, color="#d8dee9", lw=0.8, alpha=0.75)
    ax.spines[["top", "right"]].set_visible(False)
    ax.set_title("Yagi-Uda: ganho cresce devagar com o boom", fontsize=13.5, pad=10)

    fig.tight_layout()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
