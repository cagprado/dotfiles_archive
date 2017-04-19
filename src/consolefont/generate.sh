#!/bin/sh

test -z "$1" && exit 1
FONT="$1"
./bdf2psf --fb "$FONT" standard.equivalents ascii.set+linux.set+useful.set+powerline.set+:fontsets/Lat15.256 512 generated.psf
