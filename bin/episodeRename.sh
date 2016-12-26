#!/bin/zsh

SEASON=""
if [[ -n "$1" ]]; then
  SEASON="${1}x"
fi

zmodload zsh/mapfile
NAMES="$(echo "$mapfile[names]" | sed -e "s/ /_/g" -e "s/'/’/g" -e "s/\.\.\./…/g")"
NAMES=( ${(f)NAMES} )
FILES=$(ls *.(avi|mpg|mkv|mp4|skip))
FILES=( ${(f)FILES} )

if (( $#NAMES != $#FILES )); then
  print "Number of files ($#FILES) differ from number of names ($#NAMES)."
  print "No file was modified."
  return
fi

for (( i = 1; i <= $#NAMES; i += 1 )); do
  FILENAME=${FILES[i]%.*}
  EXT=${FILES[i]##*.}
  echo "Renaming \"$FILES[i]\" to \"$SEASON${(l:2::0:)i}."$NAMES[i]".$EXT\""
  mv "$FILES[i]" ${SEASON}${(l:2::0:)i}."$NAMES[i]".$EXT
  if [[ -r "$FILENAME.srt" ]]; then
    mv "$FILENAME".srt $SEASON${(l:2::0:)i}."$NAMES[i]".srt
  fi
  if [[ -r "$FILENAME.ass" ]]; then
    mv "$FILENAME".ass $SEASON${(l:2::0:)i}."$NAMES[i]".ass
  fi
done
