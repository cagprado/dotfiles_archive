#!/bin/zsh
# This script is to be used in systemd.
# Waits for an internet connection and starts network related services.

local HOSTNAME="$(hostname)"

# Waiting for a connection
while ! $(wget -q --spider www.baidu.com); do sleep 5s; done

# Have connection: start services
systemctl --user start network-services-common.target
if [[ "$HOSTNAME" = "mredson" ]]; then
  systemctl --user start network-services-mredson.target
else
  systemctl --user start network-services-other.target
fi
