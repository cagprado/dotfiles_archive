#!/bin/zsh
# This script is to be used in systemd.
# Updates freedns.
wget -qO- --read-timeout=0.0 --waitretry=5 --tries=400 'https://freedns.afraid.org/dynamic/update.php?S1A4ek1UVnRldDhvSU1SMHI2VXg6MTY0MzY3ODU=' > /dev/null
