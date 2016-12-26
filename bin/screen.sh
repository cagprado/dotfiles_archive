#!/bin/zsh

# Find out available screens
CONNECTED=($(xrandr -q | grep -w connected | cut -f1 -d' '))
DISCONNECTED=($(xrandr -q | grep -w disconnected | cut -f1 -d' '))

if [[ "$1" = "single" || $#CONNECTED -eq 1 ]]; then
  # SINGLE MODE: If only one screen connected or if single argument is given
  echo "SINGLE MODE"

  # more than 1 connected, assume external instead of primary
  [[ $#CONNECTED -ne 1 ]] && CONNECTED+=${CONNECTED[1]} && CONNECTED[1]=()

  ARGUMENTS=$(echo "--output "${^CONNECTED[2,-1]}" --off" "--output "${^DISCONNECTED}" --off" "--output ${CONNECTED[1]} --auto --primary")
  xrandr $=ARGUMENTS
else
  # DUAL MODE: Automatic is more than one screen is connected
  echo "DUAL MODE"

  ARGUMENTS=$(echo "--output "${^CONNECTED[3,-1]}" --off" "--output "${^DISCONNECTED}" --off" "--output ${CONNECTED[1]} --auto --primary --output ${CONNECTED[2]} --auto --right-of ${CONNECTED[1]}")
  xrandr $=ARGUMENTS
fi

# Wait a little bit to restart Awesome WM (fix background)
if [[ -n "$(ps -Af | grep -o -w ".*awesome" | grep -v grep)" ]]; then
  sleep 1
  echo 'awesome.restart()' | awesome-client >/dev/null 2>&1
fi

# clone (in case we need it someday)
# xrandr --output $PRIMARY --auto --output $SECONDARY --auto --same-as $PRIMARY --scale (x1/x2)x(y1/y2)
