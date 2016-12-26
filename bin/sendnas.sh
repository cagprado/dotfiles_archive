#!/bin/sh

DIR=/mnt/hdds/cagprado/usr/mov/NEW
tar c "$@" | ssh root@nas "mkdir -p $DIR && tar xC $DIR"
