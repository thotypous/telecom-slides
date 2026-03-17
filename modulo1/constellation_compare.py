import numpy as np
import matplotlib.pyplot as plt


def qam_levels(m_side: int) -> np.ndarray:
    levels = np.arange(-(m_side - 1), m_side + 1, 2, dtype=float)
    xv, yv = np.meshgrid(levels, levels)
    pts = xv.flatten() + 1j * yv.flatten()
    pts /= np.sqrt(np.mean(np.abs(pts) ** 2))
    return pts


def psk_points(m: int) -> np.ndarray:
    k = np.arange(m)
    pts = np.exp(1j * (2 * np.pi * k / m + np.pi / 4))
    pts /= np.sqrt(np.mean(np.abs(pts) ** 2))
    return pts


CONSTELLATIONS = [
    {
        "title": "BPSK",
        "points": np.array([-1 + 0j, 1 + 0j]),
        "stats": "1 bit/simb.\ndmin/sqrt(Es)=2.00\nBER: Q(sqrt(2Eb/N0))",
    },
    {
        "title": "QPSK",
        "points": psk_points(4),
        "stats": "2 bits/simb.\ndmin/sqrt(Es)=1.41\nBER: Q(sqrt(2Eb/N0))",
    },
    {
        "title": "16-QAM",
        "points": qam_levels(4),
        "stats": "4 bits/simb.\ndmin/sqrt(Es)=0.63\nBER aprox.:\n3/4 Q(sqrt(0.8Eb/N0))",
    },
    {
        "title": "64-QAM",
        "points": qam_levels(8),
        "stats": "6 bits/simb.\ndmin/sqrt(Es)=0.31\nBER aprox.:\n7/12 Q(sqrt(2/7 Eb/N0))",
    },
]


def draw_constellation(ax: plt.Axes, title: str, points: np.ndarray, stats: str) -> None:
    ax.scatter(points.real, points.imag, s=34, color="#0f766e", zorder=3)
    ax.axhline(0, color="#9ca3af", linewidth=0.8)
    ax.axvline(0, color="#9ca3af", linewidth=0.8)
    ax.set_title(title, fontsize=14)
    ax.set_aspect("equal")
    ax.grid(True, alpha=0.18)
    limit = max(1.2, 1.2 * np.max(np.abs(np.concatenate([points.real, points.imag]))))
    ax.set_xlim(-limit, limit)
    ax.set_ylim(-limit, limit)
    ax.set_xticks([])
    ax.set_yticks([])
    ax.text(
        0.04,
        0.96,
        stats,
        transform=ax.transAxes,
        va="top",
        ha="left",
        fontsize=10.5,
        bbox={"boxstyle": "round,pad=0.25", "facecolor": "white", "edgecolor": "#cbd5e1", "alpha": 0.95},
    )


def main() -> None:
    fig, axes = plt.subplots(1, 4, figsize=(13.2, 3.6))

    for ax, cfg in zip(axes, CONSTELLATIONS):
        draw_constellation(ax, cfg["title"], cfg["points"], cfg["stats"])

    axes[0].set_ylabel("Q")
    for ax in axes:
        ax.set_xlabel("I")

    fig.suptitle("Comparação de constelações: eficiência espectral vs. robustez", fontsize=16)
    fig.tight_layout()
    fig.savefig("constellation_compare.svg")
    fig.savefig("constellation_compare.png", dpi=180)


if __name__ == "__main__":
    main()
