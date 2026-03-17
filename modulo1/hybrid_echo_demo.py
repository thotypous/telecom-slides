import numpy as np
import matplotlib.pyplot as plt


def raised_step(t: np.ndarray, start: float, stop: float, rise: float) -> np.ndarray:
    up = 0.5 * (1 + np.tanh((t - start) / rise))
    down = 0.5 * (1 + np.tanh((t - stop) / rise))
    return up - down


def main() -> None:
    t = np.linspace(0.0, 12.0, 1600)

    tx = raised_step(t, 1.1, 4.6, 0.08)
    ideal_echo = 0.42 * raised_step(t, 2.2, 5.7, 0.11)
    real_echo = 0.56 * raised_step(t, 2.45, 6.0, 0.15)
    residual = real_echo - ideal_echo

    fig, axes = plt.subplots(2, 1, figsize=(10.8, 4.5), sharex=True)

    axes[0].plot(t, tx, color="#1d4ed8", linewidth=2.0, label="sinal transmitido")
    axes[0].plot(t, ideal_echo, color="#16a34a", linewidth=1.8, linestyle="--", label="eco estimado")
    axes[0].plot(t, real_echo, color="#b91c1c", linewidth=1.8, label="eco real")
    axes[0].set_ylabel("Amplitude")
    axes[0].set_ylim(-0.15, 1.2)
    axes[0].grid(True, alpha=0.22)
    axes[0].legend(loc="upper right", ncol=3, fontsize=9, frameon=False)
    axes[0].set_title("ZL real diferente da impedância de referência", fontsize=14)

    axes[1].plot(t, residual, color="#7c3aed", linewidth=2.0)
    axes[1].axhline(0, color="#9ca3af", linewidth=0.8)
    axes[1].set_ylabel("Eco residual")
    axes[1].set_xlabel("Tempo")
    axes[1].set_ylim(-0.2, 0.3)
    axes[1].grid(True, alpha=0.22)

    fig.tight_layout()
    fig.savefig("hybrid_echo_demo.svg")
    fig.savefig("hybrid_echo_demo.png", dpi=180)


if __name__ == "__main__":
    main()
