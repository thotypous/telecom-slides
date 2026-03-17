import numpy as np
import matplotlib.pyplot as plt


SEED = 7
SIGMAS = [0.1, 1.0, 5.0]


def main() -> None:
    rng = np.random.default_rng(SEED)

    t = np.linspace(0.0, 1.2, 700)
    f0 = 5.0
    signal = np.sin(2 * np.pi * f0 * t)

    fig, axes = plt.subplots(1, 3, figsize=(11.5, 3.2), sharex=True, sharey=True)

    for ax, sigma in zip(axes, SIGMAS):
        noisy = signal + rng.normal(0.0, sigma, size=t.shape)
        ax.plot(t, noisy, color="#0b6e4f", linewidth=1.3)
        ax.set_title(rf"$\sigma = {sigma:.1f}$", fontsize=13)
        ax.set_xlim(t[0], t[-1])
        ax.set_ylim(-10, 10)
        ax.set_xlabel("Tempo (s)")
        ax.grid(True, alpha=0.25)

    axes[0].set_ylabel("Amplitude")

    fig.suptitle("Sinal senoidal com diferentes níveis de AWGN", fontsize=15)
    fig.tight_layout()
    fig.savefig("awgn_demo.svg")
    fig.savefig("awgn_demo.png", dpi=180)


if __name__ == "__main__":
    main()
