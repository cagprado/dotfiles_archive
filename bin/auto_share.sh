#!/bin/bash

SERVER="nas"

MOUNT_POINTS=$(sed -e '/^.*#/d' -e '/^.*:/!d' -e 's/\t/ /g' /etc/fstab | tr -s " " | cut -f2 -d" ")

ping -c 1 "${SERVER}" &>/dev/null

if [ $? -ne 0 ]; then
    # The server could not be reached, unmount the shares
    for umntpnt in ${MOUNT_POINTS}; do
        umount -l $umntpnt &>/dev/null
        rm $HOME/.config/awesome/nas
    done
else
    # The server is up, make sure the shares are mounted
    for mntpnt in ${MOUNT_POINTS}; do
        echo $mntpnt
        mountpoint -q $mntpnt || mount $mntpnt
        findmnt -ln -o TARGET,SOURCE,AVAIL,USED,USE%,SIZE $mntpnt > $HOME/.config/awesome/nas
    done
fi
