from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, Rectangle


plt.rcParams["svg.fonttype"] = "none"

OUT = Path(__file__).resolve().parent / "fig" / "cyclic_prefix_window.svg"


def block(ax, x, y, w, h, label, fc, ec, txt="#0f172a", size=8.5, weight="bold"):
    ax.add_patch(Rectangle((x, y), w, h, facecolor=fc, edgecolor=ec, lw=1.1))
    ax.text(x + w / 2, y + h / 2, label, ha="center", va="center", fontsize=size, color=txt, weight=weight)


def arrow(ax, start, end, color="#334155", lw=1.2, mutation=10):
    ax.add_patch(
        FancyArrowPatch(
            start,
            end,
            arrowstyle="-|>",
            mutation_scale=mutation,
            color=color,
            lw=lw,
            shrinkA=0,
            shrinkB=0,
        )
    )


def main() -> None:
    fig, ax = plt.subplots(figsize=(7.3, 4.8), dpi=180)
    fig.patch.set_facecolor("white")
    ax.set_xlim(0, 10.4)
    ax.set_ylim(0, 6.2)
    ax.axis("off")

    gi_fc = "#dbeafe"
    gi_ec = "#2563eb"
    useful_fc = "#ecfdf5"
    useful_ec = "#0f766e"
    prev_fc = "#f1f5f9"
    prev_ec = "#94a3b8"
    bad_fc = "#fee2e2"
    ok_fc = "#dcfce7"
    warn = "#dc2626"
    ok = "#16a34a"
    slate = "#334155"

    ax.text(0.15, 5.83, "Símbolo OFDM transmitido", fontsize=10.5, color="#0f172a", weight="bold")
    block(ax, 0.25, 5.10, 1.25, 0.48, "anterior", prev_fc, prev_ec, size=7.2)
    block(ax, 1.50, 5.10, 1.15, 0.48, "GI", gi_fc, gi_ec, txt="#1d4ed8")
    block(ax, 2.65, 5.10, 5.90, 0.48, "símbolo útil N amostras", useful_fc, useful_ec, txt="#065f46")
    block(ax, 8.55, 5.10, 1.25, 0.48, "próximo", prev_fc, prev_ec, size=7.2)
    ax.text(1.55, 4.88, "cópia do fim", fontsize=7.2, color="#1d4ed8")

    delays = [0.0, 0.4, 0.8]
    labels = ["direto", "eco 1", "eco 2"]
    colors = ["#0f766e", "#2563eb", "#7c3aed"]
    y0 = 4.22

    for i, (delay, label, color) in enumerate(zip(delays, labels, colors)):
        y = y0 - i * 0.58
        block(ax, 1.50 + delay, y, 1.15, 0.34, "GI", gi_fc, gi_ec, txt="#1d4ed8", size=6.8)
        block(ax, 2.65 + delay, y, 5.90, 0.34, "útil", useful_fc, useful_ec, txt="#065f46", size=6.8)
        ax.text(0.42, y + 0.17, label, fontsize=7.8, color=color, va="center", weight="bold")
        arrow(ax, (0.95, y + 0.17), (1.42 + delay, y + 0.17), color=color, lw=1.0, mutation=8)

    ax.text(0.15, 2.40, "Escolha da janela FFT", fontsize=10.5, color="#0f172a", weight="bold")

    # Valid window interval.
    ax.add_patch(Rectangle((2.18, 1.68), 6.24, 0.66, facecolor=ok_fc, edgecolor=ok, lw=1.1))
    ax.text(5.30, 2.01, "região válida: N amostras ainda pertencem ao mesmo símbolo", ha="center", va="center", fontsize=8, color="#166534", weight="bold")

    # Early/late invalid regions.
    ax.add_patch(Rectangle((0.75, 1.68), 1.32, 0.66, facecolor=bad_fc, edgecolor=warn, lw=1.0))
    ax.text(1.41, 2.01, "cedo demais:\nsímbolo anterior", ha="center", va="center", fontsize=6.9, color="#991b1b", weight="bold")
    ax.add_patch(Rectangle((8.55, 1.68), 1.45, 0.66, facecolor=bad_fc, edgecolor=warn, lw=1.0))
    ax.text(9.28, 2.01, "tarde demais:\npróximo símbolo", ha="center", va="center", fontsize=6.9, color="#991b1b", weight="bold")

    # Example FFT window.
    win_start = 2.34
    win_end = win_start + 5.90
    ax.plot([win_start, win_start], [1.30, 2.58], color="#0f766e", lw=2.0, alpha=.5)
    ax.plot([win_end, win_end], [1.30, 2.58], color="#0f766e", lw=2.0, alpha=.5)
    arrow(ax, (win_start, 1.38), (win_end, 1.38), color="#0f766e", lw=1.4, mutation=9)
    arrow(ax, (win_end, 1.38), (win_start, 1.38), color="#0f766e", lw=1.4, mutation=9)
    ax.text((win_start + win_end) / 2, 1.12, "janela FFT: começa um pouco dentro do GI", ha="center", fontsize=8.2, color="#065f46", weight="bold")

    ax.text(
        0.42,
        0.47,
        "Se todos os ecos cabem no GI, existe uma faixa de inícios de FFT sem ISI.\n"
        "Dentro dela, cada eco parece deslocamento circular: na FFT vira fase por subportadora.",
        fontsize=8.4,
        color=slate,
        weight="bold",
    )

    fig.tight_layout(pad=0.1)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, format="svg", bbox_inches="tight", pad_inches=0.02)
    plt.close(fig)


if __name__ == "__main__":
    main()
