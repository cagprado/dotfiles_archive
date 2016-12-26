#!/bin/zsh

# First we select mic to use
LIST="$(pactl list short sources)"
echo $LIST
echo ""
echo -n "Select mic device: "
read DEVICE_NO

DEVICE=$(echo $LIST | grep "^$DEVICE_NO")
if [[ $? -ne 0 ]]; then
  echo "Invalid device! Aborting..."
  exit 1
fi

# Now we find out the number of channels
CHANNELS=$(echo $DEVICE | cut -f4 | cut -f2 -d' ' | cut -f1 -dc)

PULSE_SOURCE=$DEVICE_NO ffmpeg -y -f alsa -ac $CHANNELS -ar 44100 -i pulse -codec:a libvorbis -q:a 8 $HOME/mic-$$.ogg
