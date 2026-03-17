#!/usr/bin/env python3
"""Simple conceptual ECC figure for early-course placement."""

from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, Rectangle
import numpy as np


OUT_DIR = Path(__file__).parent
SVG_PATH = OUT_DIR / "coding_gain_concept.svg"
PNG_PATH = OUT_DIR / "coding_gain_concept.png"

CLR_BLUE = "#2b6cb0"
CLR_GREEN = "#2f855a"
CLR_RED = "#c53030"
CLR_ORANGE = "#dd6b20"
CLR_GRAY = "#555555"
CLR_LIGHT = "#eef2f7"


def arrow(ax, x1, y1, x2, y2, color="#333333", lw=1.6):
    ax.add_patch(
        FancyArrowPatch(
            (x1, y1), (x2, y2),
            arrowstyle="-|>",
            mutation_scale=12,
            linewidth=lw,
            color=color,
            shrinkA=0,
            shrinkB=0,
        )
    )


def bit_box(ax, x, y, text, facecolor, edgecolor="#ffffff", txtcolor="white",
            w=0.55, h=0.42, fontsize=12, weight="bold"):
    ax.add_patch(Rectangle((x - w / 2, y - h / 2), w, h,
                           facecolor=facecolor, edgecolor=edgecolor,
                           linewidth=1.0))
    ax.text(x, y, text, ha="center", va="center", fontsize=fontsize,
            color=txtcolor, fontweight=weight)


def clean_axis(ax, title):
    ax.set_title(title, fontsize=13, fontweight="bold", pad=10)
    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    for spine in ax.spines.values():
        spine.set_edgecolor("#cfcfcf")
        spine.set_linewidth(1.0)
    ax.set_facecolor("white")


def draw_uncoded(ax):
    clean_axis(ax, "Sem ECC")
    bits = ["1", "0", "1", "1"]
    xs = [1.2, 2.2, 3.2, 4.2]
    for x, b in zip(xs, bits):
        bit_box(ax, x, 4.6, b, CLR_BLUE)

    ax.text(1.0, 5.35, "Bits enviados", fontsize=10.5, color=CLR_GRAY, ha="left")
    arrow(ax, 4.9, 4.6, 6.0, 4.6, color=CLR_GRAY)
    ax.text(5.45, 4.95, "canal com ruído", fontsize=10.2, color=CLR_GRAY, ha="center")

    recv = ["1", "0", "0", "1"]
    colors = [CLR_BLUE, CLR_BLUE, CLR_RED, CLR_BLUE]
    for x, b, c in zip([6.8, 7.8, 8.8, 9.8], recv, colors):
        bit_box(ax, x, 4.6, b, c)

    ax.text(6.5, 5.35, "Bits recebidos", fontsize=10.5, color=CLR_GRAY, ha="left")
    ax.text(8.8, 3.45, "Um erro de bit já\nvira erro final.", ha="center",
            va="center", fontsize=11, color=CLR_RED)


def draw_coded(ax):
    clean_axis(ax, "Com redundância")
    ax.text(0.8, 5.35, "Exemplo: repetir cada bit 3 vezes", fontsize=10.2,
            color=CLR_GRAY, ha="left")

    groups = [("1", CLR_GREEN), ("0", CLR_BLUE), ("1", CLR_GREEN)]
    starts = [1.0, 4.0, 7.0]
    for (bit, clr), start in zip(groups, starts):
        for i in range(3):
            bit_box(ax, start + 0.7 * i, 4.55, bit, clr)

    arrow(ax, 2.4, 3.75, 2.4, 2.8, color=CLR_GRAY)
    arrow(ax, 5.4, 3.75, 5.4, 2.8, color=CLR_GRAY)
    arrow(ax, 8.4, 3.75, 8.4, 2.8, color=CLR_GRAY)

    recv = [
        ("1", CLR_GREEN), ("0", CLR_RED), ("1", CLR_GREEN),
        ("0", CLR_BLUE), ("0", CLR_BLUE), ("0", CLR_BLUE),
        ("1", CLR_GREEN), ("1", CLR_GREEN), ("0", CLR_RED),
    ]
    for i, (bit, clr) in enumerate(recv):
        bit_box(ax, 1.0 + 0.7 * i, 2.35, bit, clr)

    ax.text(0.8, 1.55, "Mesmo com alguns erros, a maioria ainda acerta.",
            fontsize=10.4, color=CLR_GRAY, ha="left")

    for xc, label in zip([1.7, 4.7, 7.7], ["1", "0", "1"]):
        bit_box(ax, xc, 0.72, label, CLR_ORANGE, w=0.62, h=0.46)
    ax.text(8.05, 0.25, "decisão final", fontsize=10.4, color=CLR_GRAY,
            ha="center", va="bottom")


def draw_gain(ax):
    clean_axis(ax, "Ganho de codificação")
    ebn0 = np.linspace(4, 14, 300)
    uncoded = 0.22 * np.exp(-0.48 * (ebn0 - 4))
    coded = 0.22 * np.exp(-0.48 * (ebn0 - 1.0))

    ax.semilogy(ebn0, uncoded, color=CLR_RED, linewidth=2.3, label="sem ECC")
    ax.semilogy(ebn0, coded, color=CLR_GREEN, linewidth=2.3, label="com ECC")
    ax.set_xlim(4, 14)
    ax.set_ylim(1e-3, 3e-1)
    ax.grid(True, which="both", alpha=0.25)
    ax.set_xlabel(r"$E_b/N_0$ (dB)", fontsize=10.5, labelpad=2)
    ax.set_ylabel("BER", fontsize=10.5)
    ax.tick_params(labelsize=9)
    ax.legend(loc="upper right", fontsize=9.5, framealpha=0.95)

    target = 1e-2
    x_unc = ebn0[np.argmin(np.abs(uncoded - target))]
    x_cod = ebn0[np.argmin(np.abs(coded - target))]
    ax.hlines(target, x_cod, x_unc, color=CLR_ORANGE, linewidth=1.7, linestyles="--")
    ax.annotate("", xy=(x_unc, target), xytext=(x_cod, target),
                arrowprops=dict(arrowstyle="<->", color=CLR_ORANGE, lw=1.6))
    ax.text((x_unc + x_cod) / 2, 1.28e-2, f"{x_unc - x_cod:.1f} dB",
            ha="center", va="bottom", fontsize=10.5, color=CLR_ORANGE, fontweight="bold")
    ax.text(9.1, 2.2e-3, "Mesma BER com\nmenos energia por bit.",
            ha="center", va="bottom", fontsize=10.2, color=CLR_GRAY)


def main():
    plt.rcParams.update({"font.family": "DejaVu Sans"})
    fig = plt.figure(figsize=(13.8, 5.7), facecolor="white")
    gs = fig.add_gridspec(1, 3, left=0.04, right=0.985, bottom=0.18, top=0.84, wspace=0.15)

    ax1 = fig.add_subplot(gs[0, 0])
    ax2 = fig.add_subplot(gs[0, 1])
    ax3 = fig.add_subplot(gs[0, 2])

    draw_uncoded(ax1)
    draw_coded(ax2)
    draw_gain(ax3)

    fig.suptitle("Correção de erros: ideia básica antes dos detalhes de implementação",
                 fontsize=18, fontweight="bold", y=0.95)
    fig.text(0.17, 0.095, "Sem redundância,\ncada erro do canal aparece na saída.",
             ha="center", va="center", fontsize=10.5, color="#333333")
    fig.text(0.50, 0.095, "Com redundância,\nalguns erros isolados podem ser corrigidos.",
             ha="center", va="center", fontsize=10.5, color="#333333")
    fig.text(0.83, 0.095, "Essa margem extra aparece\ncomo alguns dB de ganho.",
             ha="center", va="center", fontsize=10.5, color="#333333")

    fig.savefig(SVG_PATH, bbox_inches="tight", facecolor="white")
    fig.savefig(PNG_PATH, dpi=220, bbox_inches="tight", facecolor="white")


if __name__ == "__main__":
    main()
