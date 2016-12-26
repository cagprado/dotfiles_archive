#!/bin/bash

transmission-remote ${MREDSON}:9091 -n cagprado:$(pass transmission/cagprado) "$@"
