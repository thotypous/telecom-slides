#!/usr/bin/env python3
"""Generate SVG of a generic LFSR for CRC computation.

Shows a 4-stage LFSR corresponding to G(x) = x^4 + x + 1.
Input data enters at left, XOR taps at positions determined by the polynomial.
"""
import svgwrite

W, H = 520, 160
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
GAP = 30
Y_CENTER = 80
N_STAGES = 4

# Positions of register boxes
reg_x = []
start_x = 160
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
    dwg.add(dwg.line((x1, y1), (x2, y2), stroke='black', stroke_width=1.2,
                     marker_end=marker.get_funciri()))

# Draw registers
labels = ['r₃', 'r₂', 'r₁', 'r₀']
for i in range(N_STAGES):
    draw_reg(reg_x[i], Y_CENTER, labels[i])

# Input arrow
input_x = 40
dwg.add(dwg.text('dados', insert=(10, Y_CENTER - 12), font_size=11, fill='#555'))
arrow(input_x, Y_CENTER, reg_x[0] - 14, Y_CENTER)

# Output arrow
out_x = reg_x[-1] + REG_W
arrow(out_x, Y_CENTER, out_x + 40, Y_CENTER)

# XOR taps for G(x) = x^4 + x + 1
# Tap at x^0 (input): XOR before r3
xor1_x = reg_x[0] - 14
# Actually: feedback from output XORed with input and fed to specific taps
# For CRC LFSR: data_in XOR r0 -> feedback
# feedback goes to: r3 input, and XOR at r1 input (for x^1 tap)

# Feedback line from output
fb_y = Y_CENTER + REG_H//2 + 25
fb_x_start = out_x + 20
# feedback = r0 XOR data_in
# draw XOR at input
xor_in_x = input_x + 50
xor_in_y = Y_CENTER
draw_xor(xor_in_x, xor_in_y)
# data arrow to XOR
arrow(input_x, Y_CENTER, xor_in_x - 12, Y_CENTER)

# Feedback line: from r0 output, go down, go left, go up to XOR
dwg.add(dwg.line((fb_x_start, Y_CENTER), (fb_x_start, fb_y), 
                  stroke='black', stroke_width=1.2))
dwg.add(dwg.line((fb_x_start, fb_y), (xor_in_x, fb_y),
                  stroke='black', stroke_width=1.2))
dwg.add(dwg.line((xor_in_x, fb_y), (xor_in_x, Y_CENTER + 12),
                  stroke='black', stroke_width=1.2,
                  marker_end=marker.get_funciri()))

# From XOR to r3
arrow(xor_in_x + 12, Y_CENTER, reg_x[0], Y_CENTER)

# Between registers: r3->r2, r2->XOR->r1, r1->r0
# r3 -> r2
arrow(reg_x[0] + REG_W, Y_CENTER, reg_x[1], Y_CENTER)

# r2 -> XOR (tap for x^1) -> r1
xor2_x = reg_x[1] + REG_W + GAP//2
draw_xor(xor2_x, Y_CENTER)
arrow(reg_x[1] + REG_W, Y_CENTER, xor2_x - 12, Y_CENTER)
arrow(xor2_x + 12, Y_CENTER, reg_x[2], Y_CENTER)

# feedback tee to xor2
dwg.add(dwg.line((xor2_x, fb_y), (xor2_x, Y_CENTER + 12),
                  stroke='black', stroke_width=1.2,
                  marker_end=marker.get_funciri()))
# small dot at tee
dwg.add(dwg.circle((xor2_x, fb_y), 3, fill='black'))

# r1 -> r0
arrow(reg_x[2] + REG_W, Y_CENTER, reg_x[3], Y_CENTER)

# Labels
dwg.add(dwg.text('G(x) = x⁴ + x + 1', insert=(W//2, 22),
                 text_anchor='middle', font_size=14, fill='#333', font_weight='bold'))
dwg.add(dwg.text('saída', insert=(out_x + 30, Y_CENTER - 12),
                 font_size=11, fill='#555'))
dwg.add(dwg.text('feedback', insert=(fb_x_start + 5, fb_y - 4),
                 font_size=10, fill='#888'))

dwg.save()
print("Saved lfsr_crc.svg")
