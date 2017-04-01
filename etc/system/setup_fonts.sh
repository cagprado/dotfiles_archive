#!/bin/sh

# First install package fonts-meta-extended-lt from AUR

cd ~/.config/fontconfig/conf.d
ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf
ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf
ln -sf ../conf.avail/33-preferred.conf
