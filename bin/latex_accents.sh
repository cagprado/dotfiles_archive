#!/bin/sh

sed -f $HOME/bin/latex_accents.sed "$1" > "$2"
