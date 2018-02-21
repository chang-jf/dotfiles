#!/bin/bash
TARGET_DEVICE=$1
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: mk_bootable_usb.sh TARGET_DEVICE" && sudo lsblk && die
sudo parted -s $TARGET_DEVICE mklabel msdos mkpart primary ntfs 0% 100% set 1 boot on && sudo parted /dev/sdb print
sudo mkfs.ntfs -f "$TARGET_DEVICE"1
