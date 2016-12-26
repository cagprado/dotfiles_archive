#!/bin/sh
# Update System-NS ip info (Dynamic DNS)
wget -q -O- --post-data "type=dynamic&domain=mredson.system-ns.net&command=set&token=4c0cf1ef49875d0e67bd47576f745f57" http://system-ns.com/api | grep -v '"code":0' | awk '{print d, $0}' "d=$(date)"
