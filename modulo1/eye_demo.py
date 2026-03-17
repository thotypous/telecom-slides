import numpy as np
import matplotlib.pyplot as plt


SEED = 12
SPS = 64
N_SYMBOLS = 220
LEVELS = np.array([-1.0, 1.0])
LENGTHS = [
    ("20 m", 0.10, 0.98),
    ("200 m", 0.24, 0.90),
    ("1 km", 0.44, 0.78),
]


def gaussian_kernel(sigma_samples: float) -> np.ndarray:
    half = int(np.ceil(4 * sigma_samples))
    x = np.arange(-half, half + 1, dtype=float)
    kernel = np.exp(-(x**2) / (2 * sigma_samples**2))
    kernel /= kernel.sum()
    return kernel


def make_waveform(rng: np.random.Generator) -> np.ndarray:
    symbols = rng.choice(LEVELS, size=N_SYMBOLS)
    baseband = np.repeat(symbols, SPS)
    return baseband


def channel_response(signal: np.ndarray, sigma_symbols: float, gain: float) -> np.ndarray:
    sigma_samples = sigma_symbols * SPS
    filtered = np.convolve(signal, gaussian_kernel(sigma_samples), mode="same")
    noise = 0.03 * np.std(filtered) * np.random.default_rng(SEED + int(100 * sigma_symbols)).normal(
        size=filtered.shape
    )
    return gain * filtered + noise


def add_eye(ax: plt.Axes, signal: np.ndarray, title: str) -> None:
    starts = np.arange(8 * SPS, (N_SYMBOLS - 8) * SPS, SPS)
    for start in starts:
        segment = signal[start : start + 2 * SPS]
        if len(segment) != 2 * SPS:
            continue
        t = np.linspace(0.0, 2.0, len(segment), endpoint=False)
        ax.plot(t, segment, color="#0f766e", alpha=0.16, linewidth=1.0)

    ax.axvline(1.0, color="#8b1e3f", linestyle="--", linewidth=1.2)
    ax.set_title(title, fontsize=13)
    ax.set_xlim(0.0, 2.0)
    ax.set_ylim(-1.45, 1.45)
    ax.set_xticks([0.0, 1.0, 2.0], labels=["0T", "T", "2T"])
    ax.set_yticks([-1, 0, 1])
    ax.grid(True, alpha=0.22)


def main() -> None:
    rng = np.random.default_rng(SEED)
    source = make_waveform(rng)

    fig, axes = plt.subplots(1, 3, figsize=(11.4, 3.5), sharex=True, sharey=True)

    for ax, (label, sigma_symbols, gain) in zip(axes, LENGTHS):
        degraded = channel_response(source, sigma_symbols, gain)
        add_eye(ax, degraded, label)
        ax.set_xlabel("Tempo dentro de 2 intervalos de símbolo")

    axes[0].set_ylabel("Amplitude")
    fig.suptitle("Diagrama de olho de um sinal digital em banda base após cabos de diferentes comprimentos", fontsize=15)
    fig.tight_layout()
    fig.savefig("eye_pam_lengths.svg")
    fig.savefig("eye_pam_lengths.png", dpi=180)


if __name__ == "__main__":
    main()
