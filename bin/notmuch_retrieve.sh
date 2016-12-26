#!/bin/sh

[[ "$1" == "-l" ]] && local MREDSON=mredson || :

# Dump notmuch database on server (mredson) and download it
FILENAME="/tmp/$$.$(date +%Y%m%d%H%M).notmuchdump"
ssh cagprado@$MREDSON "notmuch dump| xz" | xz -d | notmuch restore
