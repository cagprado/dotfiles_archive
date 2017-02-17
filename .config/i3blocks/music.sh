#!/bin/sh

if [[ -n "$BLOCK_BUTTON" ]]; then
  case $BLOCK_BUTTON in
    1) mpc pre &> /dev/null ;;
    2) mpc toggle &> /dev/null ;;
    3) mpc next &> /dev/null ;;
  esac
fi

playstatus=$(mpc status | sed -n 's/^\[\([^])]*\)\].*$/\1/p')
case $playstatus in
  playing) mpc -f ' %artist% - %title%' current ;;
  paused) mpc -f ' %artist% - %title%' current ;;
esac
