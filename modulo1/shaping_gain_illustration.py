#!/usr/bin/env python3
"""Illustrative shaping-gain figure for the lecture slides.

The key point is geometric honesty:
- both panels use the exact same 64-QAM lattice;
- therefore the minimum distance d_min is unchanged;
- only the probability of using inner vs outer points changes.

This is a 2D intuition aid. In V.34, shell mapping is performed jointly
across four 2D symbols (8D), not as an isolated 2D symbol-by-symbol rule.
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


OUT_DIR = Path(__file__).parent
SVG_PATH = OUT_DIR / "shaping_gain_illustration.svg"
PNG_PATH = OUT_DIR / "shaping_gain_illustration.png"

CLR_UNIFORM = "#2b6cb0"
CLR_INNER = "#1f77b4"
CLR_OUTER = "#d95f02"
CLR_ACCENT = "#b22222"
CLR_GUIDE = "#888888"


def qam64_points():
    coords = np.arange(-7, 8, 2)
    xx, yy = np.meshgrid(coords, coords)
    pts = np.column_stack((xx.ravel(), yy.ravel()))
    return pts


def shell_index(points):
    return np.maximum(np.abs(points[:, 0]), np.abs(points[:, 1]))


def shell_probabilities(shells):
    # Qualitative weighting only: inner points more likely, outer points rarer.
    # The exact V.34 shell mapping operates in 8D and does not correspond to a
    # fixed 2D per-point probability table.
    weight_by_shell = {
        1: 1.00,
        3: 0.82,
        5: 0.56,
        7: 0.30,
    }
    weights = np.array([weight_by_shell[s] for s in shells], dtype=float)
    return weights / weights.sum()


def rms_radius(points, probs=None):
    r2 = points[:, 0] ** 2 + points[:, 1] ** 2
    if probs is None:
        return np.sqrt(r2.mean())
    return np.sqrt(np.sum(probs * r2))


def draw_axes(ax):
    ax.set_xlim(-9.5, 9.5)
    ax.set_ylim(-9.5, 9.5)
    ax.set_aspect("equal")
    ax.grid(True, alpha=0.22, linewidth=0.6)
    ax.set_xlabel("Em fase")
    ax.set_ylabel("Quadratura")
    ax.set_xticks(np.arange(-8, 9, 2))
    ax.set_yticks(np.arange(-8, 9, 2))


def annotate_dmin(ax):
    ax.annotate(
        "",
        xy=(-7, -8.55),
        xytext=(-5, -8.55),
        arrowprops=dict(arrowstyle="<->", color=CLR_ACCENT, lw=1.5),
    )
    ax.text(-6, -9.05, r"mesmo $d_{min}$", ha="center", va="top",
            fontsize=10, color=CLR_ACCENT, fontweight="bold",
            bbox=dict(facecolor="white", edgecolor="none", pad=0.1))


def main():
    plt.rcParams.update({
        "font.size": 11,
        "axes.titlesize": 13,
        "axes.titleweight": "bold",
        "axes.labelsize": 11,
    })

    points = qam64_points()
    shells = shell_index(points)
    probs = shell_probabilities(shells)

    rms_uniform = rms_radius(points)
    rms_shaped = rms_radius(points, probs)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12.2, 6.7))

    for ax in (ax1, ax2):
        draw_axes(ax)
        annotate_dmin(ax)

    ax1.set_title("Uso uniforme da malha 64-QAM")
    ax1.scatter(
        points[:, 0],
        points[:, 1],
        s=78,
        color=CLR_UNIFORM,
        edgecolors="white",
        linewidths=0.45,
        zorder=3,
    )

    theta = np.linspace(0, 2 * np.pi, 400)
    ax1.plot(
        rms_uniform * np.cos(theta),
        rms_uniform * np.sin(theta),
        "--",
        color=CLR_ACCENT,
        linewidth=1.8,
        label=f"raio RMS = {rms_uniform:.2f}",
        zorder=2,
    )
    ax1.legend(loc="upper right", fontsize=10, framealpha=0.95)
    ax1.text(
        0.9,
        -9.00,
        "Todos os pontos equiprováveis",
        ha="center",
        va="top",
        fontsize=10,
        color="#444444",
    )

    ax2.set_title("Mesma malha, com shaping")
    sizes = 40 + 170 * (probs / probs.max())
    colors = np.where(shells <= 3, CLR_INNER, CLR_OUTER)
    ax2.scatter(
        points[:, 0],
        points[:, 1],
        s=sizes,
        c=colors,
        alpha=0.95,
        edgecolors="white",
        linewidths=0.45,
        zorder=3,
    )

    for radius in [1, 3, 5, 7]:
        ax2.plot(
            radius * np.cos(theta),
            radius * np.sin(theta),
            color=CLR_GUIDE,
            linewidth=0.8,
            alpha=0.35,
            zorder=1,
        )

    ax2.plot(
        rms_shaped * np.cos(theta),
        rms_shaped * np.sin(theta),
        "--",
        color=CLR_ACCENT,
        linewidth=1.8,
        label=f"raio RMS = {rms_shaped:.2f}",
        zorder=2,
    )
    ax2.legend(loc="upper right", fontsize=10, framealpha=0.95)
    ax2.text(
        2.4,
        -9.00,
        "Pontos internos mais prováveis; externos mais raros",
        ha="center",
        va="top",
        fontsize=10,
        color="#444444",
        bbox=dict(facecolor="white", edgecolor="none", pad=0.1),
    )

    fig.text(
        0.5,
        0.06,
        r"Mesmo $d_{min}$ nos dois painéis; o ganho vem da redução da energia média.",
        ha="center",
        va="center",
        fontsize=12,
        fontweight="bold",
        color="#222222",
        bbox=dict(boxstyle="round,pad=0.35", facecolor="#f7f7f7",
                  edgecolor="#bbbbbb", linewidth=1.0),
    )
    fig.text(
        0.5,
        0.018,
        "Intuição 2D: no V.34 real, o shell mapping escolhe sequências de anéis em 8D.",
        ha="center",
        va="center",
        fontsize=10,
        color="#555555",
    )

    fig.tight_layout(rect=[0, 0.10, 1, 1])
    fig.savefig(SVG_PATH, bbox_inches="tight", facecolor="white")
    fig.savefig(PNG_PATH, dpi=220, bbox_inches="tight", facecolor="white")
    plt.close(fig)


if __name__ == "__main__":
    main()
