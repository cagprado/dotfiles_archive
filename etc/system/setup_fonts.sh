#!/bin/sh

# First install package fonts-meta-extended-lt from AUR

cd /etc/fonts/conf.d
sudo ln -sf ../conf.avail/11-lcdfilter-default.conf
sudo ln -sf ../conf.avail/10-sub-pixel-rgb.conf
sudo ln -sf ../conf.avail/10-hinting-slight.conf
sudo ln -sf ../conf.avail/30-infinality-aliases.conf
