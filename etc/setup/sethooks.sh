#!/bin/zsh

mkdir -p $HOME/.cfg/hooks/scripts
for ITEM in $(<$HOME/etc/setup/hookslist); do
  # if ITEM starts with : it is a hook, else it is auxiliary script
  cp $HOME/etc/setup/${ITEM#:*} $HOME/.cfg/hooks/scripts
  if [[ "${ITEM[1]}" = ":" ]]; then
    ln -sf $HOME/.cfg/hooks/scripts/${ITEM#:*} $HOME/.cfg/hooks
  fi
done
