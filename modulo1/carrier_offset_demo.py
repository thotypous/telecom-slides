import numpy as np
import matplotlib.pyplot as plt


POINTS = np.exp(1j * (np.pi / 4 + np.arange(4) * np.pi / 2))
PHASE_OFFSET = np.deg2rad(28)
N_STEPS = 18
FREQ_STEP = np.deg2rad(11)


def style_axis(ax: plt.Axes, title: str) -> None:
    ax.axhline(0, color="#9ca3af", linewidth=0.8)
    ax.axvline(0, color="#9ca3af", linewidth=0.8)
    ax.set_xlim(-1.5, 1.5)
    ax.set_ylim(-1.5, 1.5)
    ax.set_aspect("equal")
    ax.grid(True, alpha=0.18)
    ax.set_xticks([-1, 0, 1])
    ax.set_yticks([-1, 0, 1])
    ax.set_title(title, fontsize=13)


def main() -> None:
    fig, axes = plt.subplots(1, 3, figsize=(12.0, 3.7), sharex=True, sharey=True)

    ideal = POINTS
    phase_rot = POINTS * np.exp(1j * PHASE_OFFSET)

    style_axis(axes[0], "Sem erro")
    axes[0].scatter(ideal.real, ideal.imag, s=62, color="#0f766e", zorder=3)

    style_axis(axes[1], "Erro de fase Δφ")
    axes[1].scatter(ideal.real, ideal.imag, s=38, color="#cbd5e1", zorder=1)
    axes[1].scatter(phase_rot.real, phase_rot.imag, s=62, color="#b91c1c", zorder=3)

    style_axis(axes[2], "Erro de frequência Δf")
    for p in POINTS:
        traj = p * np.exp(1j * np.arange(N_STEPS) * FREQ_STEP)
        colors = plt.cm.viridis(np.linspace(0.2, 0.95, N_STEPS))
        for i in range(N_STEPS - 1):
            axes[2].plot(
                traj[i : i + 2].real,
                traj[i : i + 2].imag,
                color=colors[i],
                linewidth=1.6,
                alpha=0.9,
                zorder=2,
            )
        axes[2].scatter(traj.real, traj.imag, s=24, c=colors, zorder=3)

    axes[0].set_ylabel("Q")
    for ax in axes:
        ax.set_xlabel("I")

    axes[1].text(
        0.04,
        0.06,
        "Rotação constante",
        transform=axes[1].transAxes,
        fontsize=10.5,
        bbox={"boxstyle": "round,pad=0.2", "facecolor": "white", "edgecolor": "#cbd5e1", "alpha": 0.95},
    )
    axes[2].text(
        0.04,
        0.06,
        "Rotação contínua no tempo",
        transform=axes[2].transAxes,
        fontsize=10.5,
        bbox={"boxstyle": "round,pad=0.2", "facecolor": "white", "edgecolor": "#cbd5e1", "alpha": 0.95},
    )

    fig.suptitle("Efeito de erro de fase e frequência no oscilador local", fontsize=16)
    fig.tight_layout()
    fig.savefig("carrier_offset_demo.svg")
    fig.savefig("carrier_offset_demo.png", dpi=180)


if __name__ == "__main__":
    main()
