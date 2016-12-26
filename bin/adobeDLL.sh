#!/bin/zsh
# Copies files in adobe master collection tree

ADOBE_PATH="/mnt/win/Users/Caio/Documents"
INST32_PATH="/mnt/win/Program Files (x86)/Adobe"
INST64_PATH="/mnt/win/Program Files/Adobe"

LIB32="$ADOBE_PATH/Adobe Creative Suite 5.5 Master Collection/DLL FILE/32bit/amtlib.dll"
LIB64="$ADOBE_PATH/Adobe Creative Suite 5.5 Master Collection/DLL FILE/64bit/amtlib.dll"
SERVICES="$ADOBE_PATH/Adobe Creative Suite 5.5 Master Collection/DLL FILE/Acrobat X/amtservices.dll"

DEST32=(
"Acrobat 10.0/Acrobat/amtlib.dll"
"Adobe Audition CS5.5/amtlib.dll"
"Adobe Contribute CS5.1/App/amtlib.dll"
"Adobe Device Central CS5.5/amtlib.dll"
"Adobe Dreamweaver CS5.5/amtlib.dll"
"Adobe Encore CS5.1/amtlib.dll"
"Adobe Fireworks CS5.1/amtlib.dll"
"Adobe Flash Builder 4.5/eclipse/plugins/com.adobe.flexide.amt_4.5.1.313231/os/win32/x86/amtlib.dll"
"Adobe Flash Catalyst CS5.5/plugins/com.adobe.flexide.amt_1.5.0.308731/os/win32/x86/amtlib.dll"
"Adobe Flash CS5.5/amtlib.dll"
"Adobe Illustrator CS5.1/Support Files/Contents/Windows/amtlib.dll"
"Adobe InDesign CS5.5/amtlib.dll"
"Adobe OnLocation CS5.1/amtlib.dll"
"Adobe Photoshop CS5.1/amtlib.dll"
)

DEST64=(
"Adobe After Effects CS5.5/Support Files/amtlib.dll"
"Adobe Media Encoder CS5.5/amtlib.dll"
"Adobe Photoshop CS5.1 (64 Bit)/amtlib.dll"
"Adobe Premiere Pro CS5.5/amtlib.dll"
)

for FILE in $DEST32; do
  cp $LIB32 $INST32_PATH/$FILE
done

for FILE in $DEST64; do
  cp $LIB64 $INST64_PATH/$FILE
done
