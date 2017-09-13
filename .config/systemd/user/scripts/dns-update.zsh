#!/bin/zsh
# This script is to be used in systemd.
# Updates freedns.

URL='https://freedns.afraid.org/dynamic/update.php?MU5pM1hKdHd4N2lUSUg3aWhCaVY6MTcwNDcwOTU='
wget -qO- --read-timeout=0.0 --waitretry=5 --tries=400 $URL > /dev/null
