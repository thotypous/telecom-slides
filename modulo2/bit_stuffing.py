#!/usr/bin/env python3
"""Generate an SVG illustrating HDLC bit stuffing."""
import svgwrite

W, H = 620, 230
dwg = svgwrite.Drawing('bit_stuffing.svg', size=(f'{W}px', f'{H}px'),
                        viewBox=f'0 0 {W} {H}')
dwg.defs.add(dwg.style("""
    text { font-family: 'Inria Sans', 'DejaVu Sans', sans-serif; }
"""))

CELL = 19
FONT = 14
LEFT = 90
ROW_H = 50

# Row 1: dados originais
# Show: 0 1 1 1 1 1 0 1 1 1 1 1 1 0 0 1
original = [0,1,1,1,1,1,0,1,1,1,1,1,1,0,0,1]
# Row 2: after bit stuffing  
# After five 1s, insert 0:
# 0 1 1 1 1 1 [0] 0 1 1 1 1 1 [0] 1 0 0 1
stuffed  = [0,1,1,1,1,1,0, 0,1,1,1,1,1, 0, 1,0,0,1]
# Inserted bit indices in stuffed: 6, 13
inserted = {6, 13}

# Row 3: flag for comparison
flag = [0,1,1,1,1,1,1,0]

def draw_row(bits, x0, y0, label, highlights=None, inserted_set=None):
    dwg.add(dwg.text(label, insert=(8, y0 + FONT + 1), font_size=12, fill='#555'))
    for k, b in enumerate(bits):
        bx = x0 + k * CELL
        if inserted_set and k in inserted_set:
            # highlight inserted zero
            dwg.add(dwg.rect((bx, y0), (CELL, CELL + 4),
                              fill='#ffe0e0', stroke='#c00', stroke_width=0.8, rx=2))
            color = '#c00'
            fw = 'bold'
        elif highlights and k in highlights:
            dwg.add(dwg.rect((bx, y0), (CELL, CELL + 4),
                              fill='#fff3d0', stroke='#996600', stroke_width=0.5, rx=2))
            color = '#333'
            fw = 'normal'
        else:
            color = 'black'
            fw = 'normal'
        dwg.add(dwg.text(str(b), insert=(bx + CELL//2, y0 + FONT + 1),
                         text_anchor='middle', font_size=FONT, fill=color,
                         font_weight=fw))

y = 20
# Row 1: original data
five_1_pos_1 = {1,2,3,4,5}
five_1_pos_2 = {7,8,9,10,11,12}
draw_row(original, LEFT, y, 'dados', highlights=five_1_pos_1 | five_1_pos_2)

y += ROW_H
# Row 2: stuffed data
draw_row(stuffed, LEFT, y, 'transmitido', inserted_set=inserted)

y += ROW_H
# Row 3: flag
draw_row(flag, LEFT, y, 'flag HDLC')
# Underline the flag
dwg.add(dwg.text('01111110', insert=(LEFT + 8*CELL + 10, y + FONT + 1),
                 font_size=12, fill='#0066cc'))

# Arrows from original "five 1s" to inserted zeros
# Arrow 1: from original[5] area down to stuffed[6]
ax1 = LEFT + 6 * CELL + CELL//2   # after the 5th '1' in original
ay1 = 20 + CELL + 8
ax1t = LEFT + 6 * CELL + CELL//2  # inserted zero in stuffed
ay1t = 20 + ROW_H - 4

# Arrow 2
ax2 = LEFT + 12 * CELL + CELL//2 
ax2t = LEFT + 13 * CELL + CELL//2

for (sx, sy, tx, ty) in [(ax1, ay1, ax1t, ay1t), (ax2, ay1, ax2t, ay1t)]:
    dwg.add(dwg.line((sx, sy), (tx, ty), stroke='#c00', stroke_width=1,
                      stroke_dasharray='3,2'))

# Labels
dwg.add(dwg.text('0 inserido', insert=(LEFT + 6*CELL - 14, 20 + ROW_H + CELL + 22),
                 font_size=10, fill='#c00'))
dwg.add(dwg.text('0 inserido', insert=(LEFT + 13*CELL - 14, 20 + ROW_H + CELL + 22),
                 font_size=10, fill='#c00'))

# Bottom note
dwg.add(dwg.text('Regra: após cinco 1s consecutivos nos dados, inserir um 0.',
                 insert=(LEFT, H - 10), font_size=12, fill='#333'))

dwg.save()
print("Saved bit_stuffing.svg")
