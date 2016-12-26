#!/bin/zsh

while ! $(wget -q --spider google.com); do sleep 5; done
systemctl --user start network-services.target
[[ "$(hostname)" == "mredson" ]] && systemctl --user start dns-update.timer || :
