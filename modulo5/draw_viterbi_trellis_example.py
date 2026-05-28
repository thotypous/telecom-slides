from pathlib import Path

import matplotlib.pyplot as plt


plt.rcParams["svg.fonttype"] = "none"

OUT_DIR = Path(__file__).resolve().parent / "fig"

STATES = ["00", "10", "01", "11"]
Y = {state: len(STATES) - 1 - i for i, state in enumerate(STATES)}
RX = ["11", "11", "00", "01", "01", "11"]
TRUE_BITS = [1, 0, 1, 1, 0, 0]
TRUE_STATES = ["00", "10", "01", "10", "11", "01", "00"]


def xor_bits(bits):
    out = 0
    for bit in bits:
        out ^= bit
    return out


def transition(state, bit):
    s0 = int(state[0])
    s1 = int(state[1])
    out0 = xor_bits([bit, s0, s1])
    out1 = xor_bits([bit, s1])
    next_state = f"{bit}{s0}"
    return next_state, f"{out0}{out1}"


def hamming(a, b):
    return sum(x != y for x, y in zip(a, b))


def viterbi_metrics():
    metrics = {"00": 0, "10": 999, "01": 999, "11": 999}
    survivors = []
    all_metrics = [metrics.copy()]

    for rx in RX:
        new_metrics = {state: 999 for state in STATES}
        new_prev = {}
        for state in STATES:
            if metrics[state] >= 999:
                continue
            for bit in (0, 1):
                dest, out = transition(state, bit)
                cost = metrics[state] + hamming(rx, out)
                if cost < new_metrics[dest]:
                    new_metrics[dest] = cost
                    new_prev[dest] = (state, bit, out, hamming(rx, out))
        metrics = new_metrics
        survivors.append(new_prev)
        all_metrics.append(metrics.copy())

    traceback = []
    state = "00"
    for t in range(len(RX), 0, -1):
        prev_state, bit, out, branch = survivors[t - 1][state]
        traceback.append((t - 1, prev_state, state, bit, out))
        state = prev_state
    traceback.reverse()
    return all_metrics, survivors, traceback


METRICS, SURVIVORS, TRACEBACK = viterbi_metrics()


def candidates_for_step(t):
    candidates = []
    rx = RX[t - 1]
    for state in STATES:
        if METRICS[t - 1][state] >= 999:
            continue
        for bit in (0, 1):
            dest, out = transition(state, bit)
            branch = hamming(rx, out)
            total = METRICS[t - 1][state] + branch
            survivor = SURVIVORS[t - 1].get(dest)
            is_survivor = survivor is not None and survivor[:3] == (state, bit, out)
            candidates.append((state, dest, bit, out, branch, total, is_survivor))
    return candidates


def draw(stage, filename, title, subtitle):
    fig, ax = plt.subplots(figsize=(8.9, 4.55), dpi=180)
    fig.patch.set_facecolor("white")
    ax.set_facecolor("white")
    ax.set_position([0.02, 0.02, 0.96, 0.96])

    ax.text(0, 4.55, title, fontsize=13.2, weight="bold", color="#0f172a", ha="left")
    ax.text(0, 4.22, subtitle, fontsize=9.4, color="#334155", ha="left")

    max_col = 6
    visible_cols = {1: 1, 2: 2, 3: 3, 4: 6, 5: 6}[stage]
    show_survivors_until = {1: 1, 2: 2, 3: 2, 4: 6, 5: 6}[stage]
    show_traceback = stage == 5

    for x in range(max_col + 1):
        color = "#cbd5e1" if x <= visible_cols else "#e5e7eb"
        ax.axvline(x, ymin=0.12, ymax=0.82, color=color, lw=0.8, zorder=0)
        ax.text(x, -0.42, f"n={x}", fontsize=8.5, color="#475569", ha="center")

    for i, rx in enumerate(RX, start=1):
        color = "#475569"
        label = f"RX {rx}"
        if i <= visible_cols:
            if stage in {3, 5} and i == 2:
                x = i - 0.5
                ax.text(x + 0.085, -0.78, "RX 1", fontsize=8.5, color=color, ha="right")
                ax.text(x + 0.085, -0.78, "1", fontsize=8.5, color="#dc2626", ha="left")
            else:
                ax.text(i - 0.5, -0.78, label, fontsize=8.5, color=color, ha="center")

    for state in STATES:
        ax.text(-0.28, Y[state], state, fontsize=9.5, color="#334155", ha="right", va="center")
        for x in range(max_col + 1):
            if x <= visible_cols:
                metric = METRICS[x][state]
                metric_label = "∞" if metric >= 999 else str(metric)
                node_fc = "#eff6ff" if metric < 999 else "#f8fafc"
                node_ec = "#2563eb" if metric < 999 else "#cbd5e1"
                ax.scatter(x, Y[state], s=190, facecolor=node_fc, edgecolor=node_ec, lw=1.2, zorder=3)
                ax.text(x, Y[state], metric_label, fontsize=7.8, color="#0f172a", ha="center", va="center", zorder=4)

    for t in range(1, show_survivors_until + 1):
        for dest, (src, bit, out, branch) in SURVIVORS[t - 1].items():
            x0, x1 = t - 1, t
            y0, y1 = Y[src], Y[dest]
            is_true = TRUE_STATES[t - 1] == src and TRUE_STATES[t] == dest
            is_rx_only_path = stage == 3 and t == 2 and src == "00" and dest == "10"
            is_correct_path = stage == 3 and t == 2 and src == "10" and dest == "01"
            color = "#64748b"
            lw = 2.0 if is_true else 1.1
            alpha = 0.92 if is_true else 0.55
            if is_rx_only_path:
                color = "#dc2626"
                lw = 1.1
                alpha = 0.90
            if is_correct_path:
                color = "#16a34a"
                lw = 2.4
                alpha = 0.95
            ax.annotate(
                "",
                xy=(x1 - 0.08, y1),
                xytext=(x0 + 0.08, y0),
                arrowprops=dict(arrowstyle="-|>", color=color, lw=lw, alpha=alpha),
                zorder=1,
            )
            label_is_needed = stage <= 2 or is_true
            if stage == 3 and not is_true:
                label_is_needed = False
            if stage == 4 and not is_true:
                label_is_needed = t >= 5 and dest in ("00", "10")
            if label_is_needed:
                midx = (x0 + x1) / 2
                midy = (y0 + y1) / 2
                text_color = "#475569"
                if is_rx_only_path:
                    text_color = "#dc2626"
                if is_correct_path:
                    text_color = "#15803d"
                y_offset = 0.16 if is_true else 0.10
                ax.text(
                    midx,
                    midy + y_offset,
                    f"{bit}/{out}",
                    fontsize=7.2,
                    color=text_color,
                    ha="center",
                    va="center",
                    bbox=dict(boxstyle="round,pad=0.12", fc="white", ec="none", alpha=0.86),
                    zorder=5,
                )

    if stage == 3:
        for src, dest, bit, out, branch, total, is_survivor in candidates_for_step(3):
            x0, x1 = 2, 3
            y0, y1 = Y[src], Y[dest]
            color = "#2563eb" if is_survivor else "#f97316"
            lw = 2.1 if is_survivor else 1.3
            ls = "-" if is_survivor else (0, (3, 2))
            alpha = 0.92 if is_survivor else 0.72
            ax.annotate(
                "",
                xy=(x1 - 0.08, y1),
                xytext=(x0 + 0.08, y0),
                arrowprops=dict(arrowstyle="-|>", color=color, lw=lw, linestyle=ls, alpha=alpha),
                zorder=2 if is_survivor else 1,
            )

        ax.text(
            2.9,
            3.72,
            "n=2: vermelho casa com RX, verde tem menor PM; n=3: azul sobrevive, laranja descarta",
            fontsize=8.1,
            color="#334155",
            ha="center",
            bbox=dict(boxstyle="round,pad=0.22", fc="#f8fafc", ec="#cbd5e1", lw=0.8),
        )

    if show_traceback:
        for t, src, dest, bit, out in TRACEBACK:
            ax.annotate(
                "",
                xy=(t + 1 - 0.07, Y[dest]),
                xytext=(t + 0.07, Y[src]),
                arrowprops=dict(arrowstyle="-|>", color="#16a34a", lw=3.0),
                zorder=2,
            )
        ax.text(
            4.50,
            3.72,
            "escolha final = menor PM; com cauda, esse estado deve ser 00",
            fontsize=8.5,
            color="#15803d",
            ha="center",
            bbox=dict(boxstyle="round,pad=0.24", fc="#f0fdf4", ec="#86efac", lw=0.8),
        )

    if stage == 4:
        ax.text(
            4.72,
            3.72,
            "cauda 0 0 -> estado final 00",
            fontsize=9.2,
            color="#334155",
            ha="center",
            bbox=dict(boxstyle="round,pad=0.22", fc="#f8fafc", ec="#cbd5e1", lw=0.8),
        )

    ax.set_xlim(-0.7, 6.35)
    ax.set_ylim(-1.0, 4.75)
    ax.axis("off")
    fig.savefig(OUT_DIR / filename, format="svg")
    plt.close(fig)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    draw(
        1,
        "viterbi_trellis_step1.svg",
        "Passo 1: métricas partem do estado 00",
        "Cada nó mostra a melhor métrica acumulada até aquele estado.",
    )
    draw(
        2,
        "viterbi_trellis_step2.svg",
        "Passo 2: atualiza métricas sem decidir a mensagem",
        "Com apenas dois pares, ainda só propagamos custos pela treliça.",
    )
    draw(
        3,
        "viterbi_trellis_step3.svg",
        "Passo 3: pela primeira vez há descarte por estado",
        "Quando dois caminhos chegam ao mesmo estado, só o de menor métrica sobrevive.",
    )
    draw(
        4,
        "viterbi_trellis_step4.svg",
        "Passo 4: processa toda a sequência, incluindo a cauda",
        "A cauda 0 0 torna conhecido o estado final do encoder pequeno.",
    )
    draw(
        5,
        "viterbi_trellis_step5.svg",
        "Passo 5: traceback a partir do menor custo final",
        "O caminho sobrevivente revela a sequência de entrada mais provável.",
    )


if __name__ == "__main__":
    main()
