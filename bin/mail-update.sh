#!/bin/zsh

$HOME/bin/msmtp-queue -r
[[ "$(hostname)" == "mredson" ]] && afew -m
mbsync -a
notmuch new
afew -tn
