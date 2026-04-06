#!/usr/bin/env python3
"""Generate SVG of a CRC LFSR.

Shows a 4-stage LFSR corresponding to G(x) = x^4 + x + 1 using the
usual CRC convention: serial input at right, shift direction to the left,
and taps at r_1 and r_0.
"""
import svgwrite

W, H = 650, 160
dwg = svgwrite.Drawing('lfsr_crc.svg', size=(f'{W}px', f'{H}px'),
                        viewBox=f'0 0 {W} {H}')
dwg.defs.add(dwg.style("""
    text { font-family: 'Inria Sans', 'DejaVu Sans', sans-serif; }
"""))

# Marker for arrowheads
marker = dwg.marker(insert=(6,3), size=(8,6), orient='auto', id='arrow')
marker.add(dwg.path(d='M0,0 L6,3 L0,6 Z', fill='black'))
dwg.defs.add(marker)

REG_W = 50
REG_H = 36
GAP = 70
Y_CENTER = 80
N_STAGES = 4

# Positions of register boxes
reg_x = []
start_x = 110
for i in range(N_STAGES):
    rx = start_x + i * (REG_W + GAP)
    reg_x.append(rx)

def draw_reg(x, y, label):
    dwg.add(dwg.rect((x, y - REG_H//2), (REG_W, REG_H),
                      fill='#f0f4ff', stroke='black', stroke_width=1.5, rx=3))
    dwg.add(dwg.text(label, insert=(x + REG_W//2, y + 5),
                     text_anchor='middle', font_size=13, fill='#333'))

def draw_xor(cx, cy, r=10):
    dwg.add(dwg.circle((cx, cy), r, fill='white', stroke='black', stroke_width=1.5))
    dwg.add(dwg.line((cx - 6, cy), (cx + 6, cy), stroke='black', stroke_width=1.5))
    dwg.add(dwg.line((cx, cy - 6), (cx, cy + 6), stroke='black', stroke_width=1.5))

def arrow(x1, y1, x2, y2):
    head_len = 8
    head_half = 4
    if x2 < x1:
        dwg.add(dwg.line((x1, y1), (x2 + head_len, y2), stroke='black', stroke_width=1.2))
        dwg.add(dwg.polygon(
            points=[(x2, y2), (x2 + head_len, y2 - head_half), (x2 + head_len, y2 + head_half)],
            fill='black'
        ))
    else:
        dwg.add(dwg.line((x1, y1), (x2 - head_len, y2), stroke='black', stroke_width=1.2))
        dwg.add(dwg.polygon(
            points=[(x2, y2), (x2 - head_len, y2 - head_half), (x2 - head_len, y2 + head_half)],
            fill='black'
        ))

# Draw registers from highest to lowest degree, matching the leftward flow.
labels = ['r₃', 'r₂', 'r₁', 'r₀']
for i in range(N_STAGES):
    draw_reg(reg_x[i], Y_CENTER, labels[i])

# Input and output ends
input_x = reg_x[-1] + REG_W + 60
out_x = reg_x[0] - 40
dwg.add(dwg.text('dados', insert=(input_x + 5, Y_CENTER - 12),
                 text_anchor='middle', font_size=11, fill='#555'))
dwg.add(dwg.text('saída', insert=(out_x + 10, Y_CENTER - 12),
                 text_anchor='middle', font_size=11, fill='#555'))

# XOR taps for G(x) = x^4 + x + 1 in the usual CRC drawing convention:
# feedback from r_3 returns to the input XOR at r_0 and to the tap before r_1.

# Feedback line from r_3 output
fb_y = Y_CENTER + REG_H//2 + 25
fb_drop_x = reg_x[0] - 18
r0_in_x = reg_x[-1] + REG_W

# Output arrow from r_3
arrow(reg_x[0], Y_CENTER, out_x, Y_CENTER)

# Input XOR: data_in XOR feedback -> r_0
xor_in_x = reg_x[-1] + REG_W + GAP//2
xor_in_y = Y_CENTER
draw_xor(xor_in_x, xor_in_y)
# Data arrow to XOR
arrow(input_x, Y_CENTER, xor_in_x + 12, Y_CENTER)

# Feedback line: from r_3 output, go down, go right, and go up to the XORs
dwg.add(dwg.line((fb_drop_x, Y_CENTER), (fb_drop_x, fb_y),
                  stroke='black', stroke_width=1.2))
dwg.add(dwg.line((fb_drop_x, fb_y), (xor_in_x, fb_y),
                  stroke='black', stroke_width=1.2))
dwg.add(dwg.line((xor_in_x, fb_y), (xor_in_x, Y_CENTER + 12),
                  stroke='black', stroke_width=1.2,
                  marker_end=marker.get_funciri()))

# From input XOR to r_0
arrow(xor_in_x - 12, Y_CENTER, r0_in_x, Y_CENTER)

# Between registers: r_0->r_1 (with tap), r_1->r_2, r_2->r_3
# r_0 -> XOR (tap for r_1) -> r_1
xor2_x = reg_x[2] + REG_W + GAP//2
draw_xor(xor2_x, Y_CENTER)
arrow(reg_x[3], Y_CENTER, xor2_x + 12, Y_CENTER)
arrow(xor2_x - 12, Y_CENTER, reg_x[2] + REG_W, Y_CENTER)

# feedback tee to xor2
dwg.add(dwg.line((xor2_x, fb_y), (xor2_x, Y_CENTER + 12),
                  stroke='black', stroke_width=1.2,
                  marker_end=marker.get_funciri()))
# small dot at tee
dwg.add(dwg.circle((xor2_x, fb_y), 3, fill='black'))

# r_1 -> r_2
arrow(reg_x[2], Y_CENTER, reg_x[1] + REG_W, Y_CENTER)

# r_2 -> r_3
arrow(reg_x[1], Y_CENTER, reg_x[0] + REG_W, Y_CENTER)

# Labels
dwg.add(dwg.text('G(x) = x⁴ + x + 1', insert=(W//2, 22),
                 text_anchor='middle', font_size=14, fill='#333', font_weight='bold'))
dwg.add(dwg.text('feedback', insert=(fb_drop_x + 8, fb_y - 4),
                 font_size=10, fill='#888'))

dwg.save()
print("Saved lfsr_crc.svg")
