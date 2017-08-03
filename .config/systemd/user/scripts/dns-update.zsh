#!/bin/zsh
# This script is to be used in systemd.
# Updates freedns.

URL='https://freedns.afraid.org/dynamic/update.php?S1A4ek1UVnRldDhvSU1SMHI2VXg6MTUyMTQ3MDM='
wget -qO- --read-timeout=0.0 --waitretry=5 --tries=400 $URL > /dev/null
