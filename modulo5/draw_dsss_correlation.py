from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "dsss_barker_multipath.svg"


def style_axis(ax, title):
    ax.set_title(title, fontsize=10, color="#0f172a", pad=8, weight="bold")
    ax.grid(True, axis="y", color="#e2e8f0", lw=0.8)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["left", "bottom"]].set_color("#94a3b8")
    ax.tick_params(colors="#475569", labelsize=8)


def stem(ax, x, y, color, base="#cbd5e1"):
    markerline, stemlines, baseline = ax.stem(x, y, linefmt=color, markerfmt="o", basefmt="-")
    plt.setp(stemlines, linewidth=1.5, color=color)
    plt.setp(markerline, markersize=4.2, markerfacecolor=color, markeredgecolor="white", markeredgewidth=0.5)
    plt.setp(baseline, linewidth=0.8, color=base)


def main() -> None:
    barker = np.array([1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1], dtype=float)
    autocorr = np.correlate(barker, barker, mode="full") / len(barker)
    lags = np.arange(-(len(barker) - 1), len(barker))

    symbol_len = len(barker)
    tx = np.concatenate((barker, -barker))
    delays = np.array([0, 5, 13])
    gains = np.array([1.00, 0.44, 0.28])
    noise_rng = np.random.default_rng(7)
    rx = np.zeros(len(tx) + delays[-1] + symbol_len)
    for delay, gain in zip(delays, gains):
        rx[delay : delay + len(tx)] += gain * tx
    rx += 0.035 * noise_rng.standard_normal(rx.size)

    corr = np.correlate(rx, barker, mode="valid") / len(barker)
    corr_x = np.arange(corr.size)

    fig, axes = plt.subplots(2, 1, figsize=(6.2, 5.0), dpi=180)
    fig.patch.set_facecolor("white")

    ax = axes[0]
    style_axis(ax, "Autocorrelação do Barker-11")
    colors = np.where(lags == 0, "#2563eb", "#64748b")
    for x, y, c in zip(lags, autocorr, colors):
        stem(ax, [x], [y], c)
    ax.axhline(0, color="#94a3b8", lw=0.8)
    ax.set_xlim(-10.8, 10.8)
    ax.set_ylim(-0.22, 1.08)
    ax.set_xlabel("atraso em chips", fontsize=8.6, color="#334155")
    ax.set_ylabel("correlação normalizada", fontsize=8.6, color="#334155")
    ax.annotate(
        "pico quando\nalinhado",
        xy=(0, 1.0),
        xytext=(2.2, 0.78),
        arrowprops=dict(arrowstyle="-|>", color="#2563eb", lw=1.0),
        fontsize=8,
        color="#1d4ed8",
        ha="left",
        va="center",
    )
    ax.text(
        -10.2,
        -0.20,
        "lóbulos laterais pequenos: ecos desalinhados correlacionam pouco",
        fontsize=7.5,
        color="#475569",
    )

    ax = axes[1]
    style_axis(ax, "Correlação de dois símbolos com ecos")
    stem(ax, corr_x, corr, "#0f766e")
    ax.axhline(0, color="#94a3b8", lw=0.8)
    ax.set_xlim(-0.6, corr.size - 0.4)
    ax.set_ylim(-1.12, 1.18)
    ax.set_xlabel("hipótese de atraso", fontsize=8.6, color="#334155")
    ax.set_ylabel("saída do correlator", fontsize=8.6, color="#334155")

    ax.axvline(symbol_len, color="#94a3b8", lw=0.9, ls="--")

    labels = [
        "símbolo +1\n(+Barker)",
        "eco curto",
        "eco tardio do\nsímbolo +1: ISI",
        "símbolo -1\n(-Barker)",
    ]
    points = [0, 5, 13, symbol_len]
    offsets = [(1.7, 0.82), (6.9, 0.48), (16.1, 0.40), (12.7, -0.72)]
    colors = ["#0f766e", "#0f766e", "#dc2626", "#0f766e"]
    for point, label, text_xy, color in zip(points, labels, offsets, colors):
        ax.annotate(
            label,
            xy=(point, corr[point]),
            xytext=text_xy,
            arrowprops=dict(arrowstyle="-|>", color=color, lw=1.0),
            fontsize=8,
            color=color,
            ha="left",
            va="center",
            bbox=dict(boxstyle="round,pad=0.18", fc="white", ec="none", alpha=0.88),
        )

    fig.tight_layout(rect=(0.04, 0.03, 0.99, 0.98), h_pad=1.0)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0.03)
    plt.close(fig)


if __name__ == "__main__":
    main()
