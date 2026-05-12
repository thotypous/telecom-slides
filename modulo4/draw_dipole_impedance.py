from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


plt.rcParams["svg.fonttype"] = "none"


OUT = Path(__file__).resolve().parent / "fig" / "dipolo_impedancia_qualitativa.svg"


def main() -> None:
    x = np.linspace(0.025, 1.0, 700)

    rr = np.where(
        x <= 0.5,
        73 * (x / 0.5) ** 2,
        73 + 180 * ((x - 0.5) / 0.5) ** 2,
    )

    # Qualitative reactance: capacitive for short dipoles, first zero near
    # 0.48 lambda, inductive after that, and another zero near one wavelength.
    reactance = 1750 * (x - 0.48) * (0.96 - x) / (x + 0.03)

    fig, ax_rr = plt.subplots(figsize=(7.2, 5.2), dpi=160)
    fig.patch.set_facecolor("white")
    ax_x = ax_rr.twinx()

    ax_rr.axvspan(0, 0.48, color="#fff0d6", zorder=0)
    ax_rr.axvspan(0.48, 1.0, color="#eaf4ff", zorder=0)
    ax_rr.axvline(0.48, color="#777777", lw=1.1, ls="--", zorder=2)
    ax_rr.axvline(0.96, color="#777777", lw=1.1, ls="--", zorder=2)

    rr_line, = ax_rr.plot(x, rr, color="#1f5f9f", lw=2.8, label=r"$R_r$")
    x_line, = ax_x.plot(x, reactance, color="#b45f06", lw=2.8, label=r"$X$")

    ax_x.axhline(0, color="#444444", lw=1.0, alpha=0.8)

    ax_rr.scatter([0.5], [73], s=42, color="#1f5f9f", zorder=5)
    ax_rr.annotate(
        r"$R_r \approx 73\,\Omega$",
        xy=(0.5, 73),
        xytext=(0.29, 105),
        arrowprops=dict(arrowstyle="->", color="#1f5f9f", lw=1.0),
        color="#1f5f9f",
        fontsize=11,
    )

    ax_x.annotate(
        "1ª ressonância\n$X=0$",
        xy=(0.48, 0),
        xytext=(0.29, 95),
        arrowprops=dict(arrowstyle="->", color="#7a4a00", lw=1.0),
        color="#7a4a00",
        fontsize=10.5,
        ha="center",
    )
    ax_x.annotate(
        r"2ª ressonância" "\n" r"perto de $\lambda$",
        xy=(0.96, 0),
        xytext=(0.78, -142),
        arrowprops=dict(arrowstyle="->", color="#7a4a00", lw=1.0),
        color="#7a4a00",
        fontsize=10.5,
        ha="center",
    )

    ax_x.annotate(
        r"$X \to -\infty$",
        xy=(0.045, -230),
        xytext=(0.16, -178),
        arrowprops=dict(arrowstyle="->", color="#b45f06", lw=1.0),
        color="#b45f06",
        fontsize=11,
    )

    ax_rr.text(0.22, 232, "capacitiva\n$X<0$", ha="center", va="center", color="#8a4b00", fontsize=12, weight="bold")
    ax_rr.text(0.72, 232, "indutiva\n$X>0$", ha="center", va="center", color="#17558f", fontsize=12, weight="bold")

    ax_rr.set_xlim(0, 1.0)
    ax_rr.set_ylim(0, 260)
    ax_x.set_ylim(-250, 250)

    ax_rr.set_xlabel(r"comprimento elétrico $d/\lambda$", fontsize=12)
    ax_rr.set_ylabel(r"resistência de radiação $R_r$ ($\Omega$)", color="#1f5f9f", fontsize=11)
    ax_x.set_ylabel(r"reatância $X$ ($\Omega$, qualitativo)", color="#b45f06", fontsize=11)
    ax_rr.tick_params(axis="y", labelcolor="#1f5f9f")
    ax_x.tick_params(axis="y", labelcolor="#b45f06")

    ax_rr.set_xticks([0, 0.25, 0.5, 0.75, 1.0])
    ax_rr.set_xticklabels(["0", "0,25", "0,5", "0,75", "1"])
    ax_rr.grid(True, axis="both", color="#d9d9d9", lw=0.8, alpha=0.7)

    ax_rr.legend([rr_line, x_line], [r"$R_r$", r"$X$"], loc="upper left", frameon=True, framealpha=0.95)
    ax_rr.set_title(r"Impedância de entrada de um dipolo: $Z_A = R_r + jX$", fontsize=14, pad=10)

    fig.tight_layout()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
