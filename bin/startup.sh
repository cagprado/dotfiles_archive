#!/bin/zsh

# Add commands that keep their names to `ps -Af` list.
PROGRAM_LIST=(udiskie blueman-applet hp-systray owncloud)

for PROGRAM in $PROGRAM_LIST; do
  if [ -z "$(ps -Af | grep -o -w ".*$PROGRAM" | grep -v grep)" ]; then
    echo $PROGRAM…
    $PROGRAM&!
  fi
done

# Run once commands (they don't - usually - fork)
fcitx -r&!      # this will replace current fcitx and actually fork
wmname Sawfish
