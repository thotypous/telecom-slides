import numpy as np
import matplotlib.pyplot as plt


SPS = 64
SPAN = 8
N_SYMBOLS = 140
SEED = 21
PULSES = [
    ("sinc", None),
    ("RC β=0.25", 0.25),
    ("RC β=0.5", 0.5),
    ("RC β=1.0", 1.0),
]


def sinc_pulse(t: np.ndarray) -> np.ndarray:
    return np.sinc(t)


def raised_cosine_pulse(t: np.ndarray, beta: float) -> np.ndarray:
    pulse = np.sinc(t) * np.cos(np.pi * beta * t)
    denom = 1 - (2 * beta * t) ** 2
    out = np.empty_like(t)

    regular = np.abs(denom) > 1e-10
    out[regular] = pulse[regular] / denom[regular]

    singular = ~regular
    if np.any(singular):
        out[singular] = (np.pi / 4) * np.sinc(1 / (2 * beta))

    return out


def make_pulse(beta: float | None) -> tuple[np.ndarray, np.ndarray]:
    t = np.arange(-SPAN * SPS, SPAN * SPS + 1) / SPS
    if beta is None:
        g = sinc_pulse(t)
    else:
        g = raised_cosine_pulse(t, beta)
    g /= np.max(np.abs(g))
    return t, g


def make_waveform(pulse: np.ndarray, rng: np.random.Generator) -> np.ndarray:
    symbols = rng.choice([-1.0, 1.0], size=N_SYMBOLS)
    up = np.zeros(N_SYMBOLS * SPS)
    up[::SPS] = symbols
    shaped = np.convolve(up, pulse, mode="same")
    shaped /= np.max(np.abs(shaped))
    return shaped


def add_eye(ax: plt.Axes, waveform: np.ndarray, rng: np.random.Generator, title: str) -> None:
    starts = np.arange(10 * SPS, (N_SYMBOLS - 10) * SPS, SPS)
    for start in starts:
        jitter = int(np.round(rng.normal(0.0, 0.09 * SPS)))
        left = start - SPS + jitter
        right = start + SPS + jitter
        if left < 0 or right > len(waveform):
            continue
        segment = waveform[left:right]
        if len(segment) != 2 * SPS:
            continue
        t_eye = np.linspace(0.0, 2.0, len(segment), endpoint=False)
        ax.plot(t_eye, segment, color="#0f766e", alpha=0.18, linewidth=0.9)

    ax.axvline(1.0, color="#8b1e3f", linestyle="--", linewidth=1.0)
    ax.set_xlim(0.0, 2.0)
    ax.set_ylim(-1.25, 1.25)
    ax.set_xticks([0.0, 1.0, 2.0], labels=["0T", "T", "2T"])
    ax.set_yticks([-1, 0, 1])
    ax.grid(True, alpha=0.2)
    ax.set_title(title, fontsize=12)


def add_spectrum(ax: plt.Axes, pulse: np.ndarray) -> None:
    n_fft = 8192
    spec = np.fft.fftshift(np.abs(np.fft.fft(pulse, n=n_fft)))
    spec /= np.max(spec)
    freq = np.fft.fftshift(np.fft.fftfreq(n_fft, d=1 / SPS))
    ax.plot(freq, spec, color="#1d4ed8", linewidth=1.5)
    ax.set_xlim(-1.35, 1.35)
    ax.set_ylim(0.0, 1.05)
    ax.set_xticks([-1, 0, 1], labels=["-1/T", "0", "1/T"])
    ax.set_yticks([0, 0.5, 1.0])
    ax.grid(True, alpha=0.2)


def main() -> None:
    rng = np.random.default_rng(SEED)

    fig, axes = plt.subplots(3, 4, figsize=(12.8, 7.2))

    for col, (label, beta) in enumerate(PULSES):
        t, pulse = make_pulse(beta)

        axes[0, col].plot(t, pulse, color="#0b6e4f", linewidth=1.5)
        axes[0, col].set_xlim(-4, 4)
        axes[0, col].set_ylim(-0.3, 1.05)
        axes[0, col].set_xticks([-4, -2, 0, 2, 4])
        axes[0, col].grid(True, alpha=0.2)
        axes[0, col].set_title(label, fontsize=12)

        add_spectrum(axes[1, col], pulse)

        waveform = make_waveform(pulse, rng)
        add_eye(axes[2, col], waveform, rng, "")

    axes[0, 0].set_ylabel("Tempo\namplitude")
    axes[1, 0].set_ylabel("Freq.\n|G(f)|")
    axes[2, 0].set_ylabel("Olho\namplitude")

    for ax in axes[0]:
        ax.set_xlabel("t/T")
    for ax in axes[1]:
        ax.set_xlabel("Frequência normalizada")
    for ax in axes[2]:
        ax.set_xlabel("Tempo dentro de 2 símbolos")

    fig.suptitle("Pulso sinc vs. raised cosine: tempo, frequência e robustez a erro de temporização", fontsize=16)
    fig.tight_layout()
    fig.savefig("pulse_compare.svg")
    fig.savefig("pulse_compare.png", dpi=180)


if __name__ == "__main__":
    main()
