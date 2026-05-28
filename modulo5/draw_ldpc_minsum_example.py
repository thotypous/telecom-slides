from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyArrowPatch


plt.rcParams["svg.fonttype"] = "none"

OUT_DIR = Path(__file__).resolve().parent / "fig"

VARS = ["b0", "b1", "b2", "p0", "p1", "p2"]
CHECKS = ["C0", "C1", "C2"]
EDGES = {
    "C0": ["b0", "b1", "b2", "p0"],
    "C1": ["b0", "p0", "p1"],
    "C2": ["b2", "p0", "p2"],
}

X_BITS = [1, 0, 1, 0, 1, 1]
Y_BITS = [1, 0, 0, 0, 1, 1]
R0 = [1.8, -1.6, -0.2, -1.5, 1.7, 1.4]
MESSAGES = {
    "b0": [-0.2, 1.5],
    "b1": [0.2],
    "b2": [1.5, 1.4],
    "p0": [0.2, -1.7, 0.2],
    "p1": [1.5],
    "p2": [-0.2],
}
R1 = [R0[i] + sum(MESSAGES[VARS[i]]) for i in range(len(VARS))]

CHECK_TO_VAR = {
    ("C0", "b0"): -0.2,
    ("C0", "b1"): 0.2,
    ("C0", "b2"): 1.5,
    ("C0", "p0"): 0.2,
    ("C1", "b0"): 1.5,
    ("C1", "p0"): -1.7,
    ("C1", "p1"): 1.5,
    ("C2", "b2"): 1.4,
    ("C2", "p0"): 0.2,
    ("C2", "p2"): -0.2,
}

VAR_POS = {
    "b0": (0.7, 2.9),
    "b1": (1.8, 2.9),
    "b2": (2.9, 2.9),
    "p0": (4.0, 2.9),
    "p1": (5.1, 2.9),
    "p2": (6.2, 2.9),
}
CHECK_POS = {
    "C0": (1.8, 1.1),
    "C1": (4.0, 1.1),
    "C2": (5.1, 1.1),
}

LABEL_OFFSETS = {
    ("C0", "b0"): (-0.12, 0.16),
    ("C0", "b1"): (-0.05, 0.16),
    ("C0", "b2"): (0.10, 0.16),
    ("C0", "p0"): (0.15, 0.16),
    ("C1", "b0"): (0.85, -0.5),
    ("C1", "p0"): (-0.03, -0.5),
    ("C1", "p1"): (-0.27, -0.5),
    ("C2", "b2"): (-0.24, 0.20),
    ("C2", "p0"): (-0.12, 0.17),
    ("C2", "p2"): (0.10, 0.18),
}


def sign_char(value):
    return "+" if value >= 0 else "-"


def hard_bits(values):
    return [1 if value >= 0 else 0 for value in values]


def draw_node(ax, xy, label, fc, ec, text="#0f172a", radius=0.19):
    ax.add_patch(Circle(xy, radius, facecolor=fc, edgecolor=ec, lw=1.6, zorder=3))
    ax.text(*xy, label, ha="center", va="center", fontsize=9.8, color=text, weight="bold", zorder=4)


def edge_points(check, var, shrink=0.24):
    x0, y0 = CHECK_POS[check]
    x1, y1 = VAR_POS[var]
    dx, dy = x1 - x0, y1 - y0
    dist = (dx * dx + dy * dy) ** 0.5
    ux, uy = dx / dist, dy / dist
    return (x0 + ux * shrink, y0 + uy * shrink), (x1 - ux * shrink, y1 - uy * shrink)


def draw_graph(ax, values, arrows=False, corrected=False):
    for check, vars_ in EDGES.items():
        x0, y0 = CHECK_POS[check]
        for var in vars_:
            x1, y1 = VAR_POS[var]
            if arrows:
                start, end = edge_points(check, var)
                msg = CHECK_TO_VAR[(check, var)]
                color = "#2563eb" if msg >= 0 else "#b45309"
                arrow = FancyArrowPatch(
                    start,
                    end,
                    arrowstyle="-|>",
                    mutation_scale=9,
                    lw=1.15,
                    color=color,
                    alpha=0.78,
                    zorder=1,
                )
                ax.add_patch(arrow)
                lx = (start[0] + end[0]) / 2 + LABEL_OFFSETS[(check, var)][0]
                ly = (start[1] + end[1]) / 2 + LABEL_OFFSETS[(check, var)][1]
                ax.text(
                    lx,
                    ly,
                    f"{msg:+.1f}",
                    fontsize=6.7,
                    color=color,
                    ha="center",
                    va="center",
                    bbox=dict(boxstyle="round,pad=0.08", fc="white", ec="none", alpha=0.75),
                    zorder=2,
                )
            else:
                ax.plot([x0, x1], [y0, y1], color="#cbd5e1", lw=1.2, alpha=0.90, zorder=1)

    for i, var in enumerate(VARS):
        value = values[i]
        fc = "#f8fafc"
        ec = "#2563eb"
        text = "#0f172a"
        if corrected and hard_bits(values)[i] != hard_bits(R0)[i]:
            fc = "#f0fdf4"
            ec = "#16a34a"
            text = "#166534"
        draw_node(ax, VAR_POS[var], var, fc, ec, text=text)
        ax.text(
            VAR_POS[var][0],
            VAR_POS[var][1] + 0.34,
            f"r={value:+.1f}",
            ha="center",
            va="bottom",
            fontsize=8.2,
            color=text,
        )
        ax.text(
            VAR_POS[var][0],
            VAR_POS[var][1] - 0.34,
            f"{sign_char(value)} -> {hard_bits(values)[i]}",
            ha="center",
            va="top",
            fontsize=7.8,
            color="#475569",
        )

    for check in CHECKS:
        draw_node(ax, CHECK_POS[check], check, "#f8fafc", "#64748b")


def setup(title, subtitle):
    fig, ax = plt.subplots(figsize=(8.9, 4.55), dpi=180)
    fig.patch.set_facecolor("white")
    ax.set_facecolor("white")
    ax.set_position([0.02, 0.02, 0.96, 0.96])
    ax.text(0, 4.35, title, fontsize=13.0, weight="bold", color="#0f172a", ha="left")
    ax.text(0, 4.05, subtitle, fontsize=9.0, color="#334155", ha="left")
    ax.set_xlim(-0.2, 8.5)
    ax.set_ylim(0.25, 4.55)
    ax.axis("off")
    return fig, ax


def save(fig, filename):
    fig.savefig(OUT_DIR / filename, format="svg")
    plt.close(fig)


def step1():
    fig, ax = setup(
        "Passo 1: crenças iniciais recebidas",
        "O decoder começa apenas com LLRs dos bits; ele ainda não sabe qual posição está errada.",
    )
    draw_graph(ax, R0)
    save(fig, "ldpc_minsum_step1.svg")


def step2():
    fig, ax = setup(
        "Passo 2: checks enviam mensagens extrínsecas",
        "Cada check envia uma mensagem para cada bit vizinho, sempre usando os outros bits da mesma linha.",
    )
    draw_graph(ax, R0, arrows=True)
    ax.text(6.75, 3.35, "Todas as arestas", fontsize=9.4, weight="bold", color="#0f172a")
    ax.text(6.75, 3.02, "recebem uma mensagem\ncheck -> bit.", fontsize=8.4, color="#334155", linespacing=1.22)
    ax.text(6.75, 2.28, "Azul: mensagem positiva", fontsize=8.2, color="#1d4ed8")
    ax.text(6.75, 1.98, "Marrom: mensagem negativa", fontsize=8.2, color="#92400e")
    ax.text(6.75, 1.42, "A atualização do bit\nacontece só no\npróximo passo.", fontsize=8.4, color="#334155", linespacing=1.22)
    save(fig, "ldpc_minsum_step2.svg")


def step3():
    fig, ax = setup(
        "Passo 3: bits somam mensagens e decidem",
        "Depois de receber todas as mensagens, cada bit atualiza seu LLR e toma uma nova decisão hard.",
    )
    draw_graph(ax, R1, corrected=True)
    ax.text(6.75, 3.35, "Atualização", fontsize=9.4, weight="bold", color="#0f172a")
    ax.text(6.75, 3.02, "r_new = r + soma(l)", fontsize=8.6, color="#334155")
    ax.text(6.75, 2.62, "Apenas um nó muda\nde decisão hard.", fontsize=8.6, color="#166534", weight="bold", linespacing=1.25)
    ax.text(6.75, 2.04, "No grafo, isso faz\ntodos os checks\nficarem consistentes.", fontsize=8.5, color="#334155", linespacing=1.25)
    ax.text(6.75, 1.18, "Foi esse bit que o\ncanal havia invertido.", fontsize=8.5, color="#166534", weight="bold", linespacing=1.25)
    save(fig, "ldpc_minsum_step3.svg")


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    step1()
    step2()
    step3()


if __name__ == "__main__":
    main()
