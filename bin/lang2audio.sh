#!/bin/bash
# write a Chinese text string as an audio file using Google Translate
# usage: zh2audio.sh <text>
wget -q -U Mozilla -O $1.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=zh&q=$1"
