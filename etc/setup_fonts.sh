#!/bin/sh

# console
echo "copying font for console..."
sudo cp $HOME/.local/share/fonts/bitmap/tamsyn-patched/Tamsyn8x16.psf.gz /usr/share/kbd/consolefonts/consolefont.psf.gz

# fontconfig
cd ~/.config/fontconfig/conf.d
ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf
ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf
