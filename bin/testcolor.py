#!/usr/bin/env python
# -*- coding: utf-8 -*-
def idx(r,g,b):
    return 16 + b + 6*g + 36*r
def prt(r,g,b):
    print("\033[48;5;{0};38;5;16m#{0:03}\033[m".format(idx(r,g,b)), end='')
def prt24(r,g,b):
    print("\033[48;2;{0};{1};{2};38;2;{3};{4};{5}m \033[m".format(r,g,b,255-r,255-g,255-b), end='')
#===============================================================================

# TERMINAL ATRIBUTES
print('NORMAL  BRIGHT  FAINT   ITALIC  UNDER   BLINK   BLINK   REVERSE CONCEAL CROSSED DOUBLE')
for i in range(11):
    print("\033[{0}m{0};XXm\033[m\t".format(i), end='')
print('')
for j in range(30,38):
    for i in range(11):
        print("\033[{0};{1}m{0};{1}m\033[m\t".format(i,j), end='')
    print('')
print('')

# GREYS
print('GREYS: ',end='')
for i in range(232,256):
    print("\033[48;5;{0}m   \033[m".format(i), end='')
print('')
print(' '*7,end='')
for i in range(232,256):
    if i%2 == 0: print("{0}".format(i), end='')
    else: print(" "*3, end='')
print('')

# COLOR BLOCKS
for b in range(5,-1,-1):
    print('')
    print(' '*(4+b*2),end='')
    for r in range(5-b,0,-1):
        prt(r,0,b+r)
    for g in range(6):
        prt(0,g,b)

for r in range(5):
    for b in range(1,6):
        prt(r,5,b)
    for g in range(4,4-r,-1):
        prt(r-5+g,g,5)
    print('')
    print(' '*(6+r*2),end='')
    for b in range(4-r,-1,-1):
        prt(b+r+1,0,b)
    for g in range(1,6):
        prt(r+1,g,0)

for g in range(5,-1,-1):
    for b in range(6):
        if b!=0 or g!=5: prt(5,g,b)
    for r in range(4,4-g,-1):
        prt(r,r-5+g,5)
    print('')
    if g==5:
        print(' '*(23-g)*2,end='')
    elif g>=1:
        b = g
        print(' '*(b-1)*2,end='')
        for r in range(5-b,1,-1):
            prt(r,1,b+r)
        for g2 in range(1,5):
            prt(1,g2,b)
        if g>1:
            print(' '*16,end='')
        else:
            for b in range(2,5):
                prt(1,4,b)
            print(' '*4,end='')

for r in range(2,5):
    print(' '*2*(r-1),end='')
    for b in range(5-r,0,-1):
        prt(b+r-1,1,b)
    for g in range(2,5):
        prt(r,g,1)
    for b in range(2,5):
        prt(r,4,b)
    for g in range(3,4-r,-1):
        prt(r-4+g,g,4)
    print('')

for g in range(3,0,-1):
    if g==3:
        print('  '*(13-g), end='')
    elif g==2:
        print('  '*3, end='')
        prt(2,2,3);prt(2,3,3)
        print('  '*4, end='')
    elif g==1:
        print('  '*2, end='')
        prt(3,2,3);prt(2,2,2);prt(2,3,2);prt(2,3,3)
        print('  '*2, end='')
    for b in range(1,5):
        prt(4,g,b)
    for r in range(3,4-g,-1):
        prt(r,g-(4-r),4)
    print('')

print('  '*3, end='')
prt(3,2,2);prt(3,3,2);prt(3,3,3);prt(2,2,3);print('')
print('  '*6, end='')
prt(3,2,2);prt(3,2,3)

print('')
print('')

# 24-bit color
print('24-BIT: ', end='')
for i in range(0, 77):
    r = int(255 - (i*255/76))
    b = int(i*255/76)
    g = i*510/76
    if g > 255:
        g = 510 - g
    g = int(g)
    prt24(r,g,b)
print('')
