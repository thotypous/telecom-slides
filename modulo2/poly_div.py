#!/usr/bin/env python3
"""Generate an SVG illustrating polynomial long division over GF(2).

Example: divide M(x) * x^4 by G(x) = x^4 + x + 1  (binary 10011)
with M(x) = x^6 + x^4 + x^3 = 1011000.
We append 4 zeros -> dividend = 10110000000.
"""
import svgwrite

GENERATOR = 0b10011
GEN_DEGREE = 4
MSG_BITS   = [1,0,1,1,0,0,0]
DIVIDEND   = MSG_BITS + [0]*GEN_DEGREE

def gf2_div(dividend, gen, gen_deg):
    buf = list(dividend)
    steps = []
    for i in range(len(buf) - gen_deg):
        if buf[i] == 1:
            for j in range(gen_deg + 1):
                buf[i+j] ^= (gen >> (gen_deg - j)) & 1
            steps.append((i, list(buf)))
    remainder = buf[-gen_deg:]
    return steps, remainder

steps, remainder = gf2_div(DIVIDEND, GENERATOR, GEN_DEGREE)

CELL   = 20
FONT   = 14
LEFT   = 60
TOP    = 50
LINE_H = CELL + 4

n_bits = len(DIVIDEND)
gen_bits = [(GENERATOR >> (GEN_DEGREE - j)) & 1 for j in range(GEN_DEGREE + 1)]

W = LEFT + n_bits * CELL + 140
H = TOP + (len(steps) * 2 + 3) * LINE_H + 20

dwg = svgwrite.Drawing('poly_div.svg', size=(f'{W}px', f'{H}px'),
                        viewBox=f'0 0 {W} {H}')
dwg.defs.add(dwg.style("""
    text { font-family: 'Inria Sans', 'DejaVu Sans', sans-serif; }
"""))

def bits_text(bits, x0, y0, color='black', bold=False):
    for k, b in enumerate(bits):
        fw = 'bold' if bold else 'normal'
        dwg.add(dwg.text(str(b), insert=(x0 + k*CELL + CELL//2, y0 + FONT),
                         text_anchor='middle', font_size=FONT, fill=color,
                         font_weight=fw))

def hline(x1, y, x2):
    dwg.add(dwg.line((x1, y), (x2, y), stroke='black', stroke_width=1))

# Title
dwg.add(dwg.text('M(x) = x\u2076 + x\u2074 + x\u00b3,   G(x) = x\u2074 + x + 1',
                 insert=(LEFT, TOP - 28), font_size=13, fill='#333'))
dwg.add(dwg.text('Dividendo: M(x)\u00b7x\u2074 = 10110000000,   Divisor: G(x) = 10011',
                 insert=(LEFT, TOP - 12), font_size=11, fill='#666'))

y = TOP
# Dividend row
bits_text(DIVIDEND, LEFT, y, bold=True)

# Long division bracket
bx = LEFT - 4
hline(bx, TOP - 2, LEFT + n_bits*CELL + 2)
dwg.add(dwg.line((bx, TOP - 2), (bx, TOP + LINE_H - 4), stroke='black', stroke_width=1))

# Generator label on left
dwg.add(dwg.text('10011', insert=(4, y + FONT), font_size=12, fill='#c00'))

# Division steps
cur = list(DIVIDEND)
y = TOP + LINE_H

for step_idx, (pos, buf_after) in enumerate(steps):
    sub_x = LEFT + pos * CELL
    bits_text(gen_bits, sub_x, y - 2, color='#c00')
    xor_y = y + LINE_H - 6
    hline(sub_x + 2, xor_y, sub_x + (GEN_DEGREE+1)*CELL - 2)
    y = xor_y + 2

    for j in range(pos, n_bits):
        dwg.add(dwg.text(str(buf_after[j]),
                         insert=(LEFT + j*CELL + CELL//2, y + FONT),
                         text_anchor='middle', font_size=FONT, fill='black'))
    y += LINE_H

# Highlight remainder
rem_x = LEFT + (n_bits - GEN_DEGREE) * CELL
rem_y = y - LINE_H + 2
dwg.add(dwg.rect((rem_x - 3, rem_y), (GEN_DEGREE * CELL + 6, FONT + 8),
                  fill='#e8f0ff', stroke='#0066cc', stroke_width=1.5, rx=3))
for k, b in enumerate(remainder):
    dwg.add(dwg.text(str(b), insert=(rem_x + k*CELL + CELL//2, rem_y + FONT + 1),
                     text_anchor='middle', font_size=FONT, fill='#0066cc',
                     font_weight='bold'))
dwg.add(dwg.text('\u2190 resto (CRC)', insert=(rem_x + GEN_DEGREE*CELL + 12, rem_y + FONT),
                 font_size=11, fill='#0066cc'))

dwg.save()
print("Saved poly_div.svg")
