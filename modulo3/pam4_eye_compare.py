import numpy as np
import matplotlib.pyplot as plt


SEED = 49
SPS = 80
N_SYMBOLS = 360


def raised_cosine_step(length: int) -> np.ndarray:
    t = np.linspace(0.0, 1.0, length, endpoint=False)
    return 0.5 - 0.5 * np.cos(np.pi * t)


def smooth_symbols(symbols: np.ndarray, transition: int) -> np.ndarray:
    signal = np.repeat(symbols, SPS).astype(float)
    ramp = raised_cosine_step(2 * transition)

    for idx in range(1, len(symbols)):
        start = idx * SPS - transition
        stop = idx * SPS + transition
        if start < 0 or stop > len(signal):
            continue
        signal[start:stop] = symbols[idx - 1] * (1.0 - ramp) + symbols[idx] * ramp

    return signal


def make_eye(levels: np.ndarray, noise_sigma: float, transition: int) -> tuple[np.ndarray, np.ndarray]:
    rng = np.random.default_rng(SEED + len(levels))
    symbols = rng.choice(levels, size=N_SYMBOLS)
    signal = smooth_symbols(symbols, transition)
    signal += rng.normal(scale=noise_sigma, size=signal.shape)
    return symbols, signal


def plot_eye(ax: plt.Axes, signal: np.ndarray, levels: np.ndarray, color: str, title: str, subtitle: str) -> None:
    starts = np.arange(10 * SPS, (N_SYMBOLS - 12) * SPS, SPS)
    for start in starts:
        segment = signal[start : start + 2 * SPS]
        if len(segment) != 2 * SPS:
            continue
        x = np.linspace(0.0, 2.0, len(segment), endpoint=False)
        ax.plot(x, segment, color=color, alpha=0.11, linewidth=0.9)

    for level in levels:
        ax.axhline(level, color="#475569", linewidth=0.8, linestyle="--", alpha=0.65)
        ax.text(2.02, level, f"{level:.2g}", va="center", ha="left", fontsize=8.5, color="#334155")

    ax.axvline(1.0, color="#8b1e3f", linestyle=":", linewidth=1.3)
    ax.set_xlim(0.0, 2.17)
    ax.set_ylim(-1.25, 1.25)
    ax.set_xticks([0.0, 1.0, 2.0], labels=["0", "T", "2T"])
    ax.set_yticks([])
    ax.grid(True, axis="x", alpha=0.16)
    ax.set_title(f"{title}\n{subtitle}", fontsize=13.5, weight="bold", pad=9, color="#111827")
    ax.set_xlabel("tempo dentro de dois símbolos")


def add_vertical_margin(ax: plt.Axes, y0: float, y1: float, x: float, label: str, color: str) -> None:
    ax.annotate("", xy=(x, y0), xytext=(x, y1), arrowprops={"arrowstyle": "<->", "color": color, "lw": 1.7})
    ax.text(x + 0.06, (y0 + y1) / 2.0, label, color=color, fontsize=10.5, va="center", weight="bold")


def main() -> None:
    nrz_levels = np.array([-1.0, 1.0])
    pam4_levels = np.array([-1.0, -1.0 / 3.0, 1.0 / 3.0, 1.0])
    _, nrz_signal = make_eye(nrz_levels, noise_sigma=0.030, transition=17)
    _, pam4_signal = make_eye(pam4_levels, noise_sigma=0.026, transition=14)

    plt.rcParams.update({"font.family": "DejaVu Sans", "svg.fonttype": "none"})
    fig, axes = plt.subplots(1, 2, figsize=(11.6, 4.55), sharey=True)
    fig.patch.set_facecolor("white")

    plot_eye(axes[0], nrz_signal, nrz_levels, "#0f766e", "NRZ", "2 níveis -> 1 bit por símbolo")
    plot_eye(axes[1], pam4_signal, pam4_levels, "#7c3aed", "PAM4", "4 níveis -> 2 bits por símbolo")
    axes[0].set_ylabel("amplitude normalizada")

    add_vertical_margin(axes[0], -0.96, 0.96, 1.47, "1 olho grande", "#0f766e")
    add_vertical_margin(axes[1], -0.30, 0.30, 1.47, "3 olhos menores", "#7c3aed")

    axes[0].text(
        0.06,
        0.08,
        "maior separação vertical\nmais margem de ruído",
        transform=axes[0].transAxes,
        fontsize=10.5,
        bbox={"boxstyle": "round,pad=0.35", "facecolor": "#ecfdf5", "edgecolor": "#99f6e4"},
    )
    axes[1].text(
        0.06,
        0.08,
        "mesma excursão total\nmenor distância entre níveis",
        transform=axes[1].transAxes,
        fontsize=10.5,
        bbox={"boxstyle": "round,pad=0.35", "facecolor": "#f5f3ff", "edgecolor": "#ddd6fe"},
    )

    fig.text(
        0.5,
        0.015,
        "Para a mesma taxa de bits por lane: PAM4 transporta 2 bits/símbolo, reduz o baud rate pela metade, mas exige SNR, linearidade e FEC.",
        ha="center",
        va="bottom",
        fontsize=12.3,
        color="#111827",
        bbox={"boxstyle": "round,pad=0.42", "facecolor": "#f8fafc", "edgecolor": "#cbd5e1"},
    )

    fig.tight_layout(rect=(0.02, 0.10, 0.98, 0.96), w_pad=2.0)
    fig.savefig("fig/pam4_eye_compare.svg", bbox_inches="tight")


if __name__ == "__main__":
    main()
