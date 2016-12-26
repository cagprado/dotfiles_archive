#!/bin/zsh
# For scanning images, useful when you have a scanner and want
# to scan lots of images without bothering to enter filenames.

echo -n "Enter image basename: "; read BASENAME

ID=0
while :; do
  IMGNAME=$(printf "${BASENAME}%04d.pnm" $ID)
  scanimage -p -d epson2 --mode Color --resolution 300 $@ > "$IMGNAME"
  echo "Press any key to keep scanning... "; read -k -s
  ID=$[$ID+1]
done
