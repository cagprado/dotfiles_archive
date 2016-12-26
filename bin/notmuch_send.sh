#!/bin/sh

[[ "$1" == "-l" ]] && local MREDSON=mredson || :

# Dump notmuch database here and retrieve it on server (mredson)
notmuch dump | xz | ssh cagprado@$MREDSON "xz -d | notmuch restore" 
