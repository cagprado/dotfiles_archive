#!/bin/sh

STATE=$(synclient | grep TouchpadOff | cut -f2 -d= | cut -f2 -d\ )

if [ $STATE = "0" ]; then
  synclient TouchpadOff=1
else
  synclient TouchpadOff=0
fi
