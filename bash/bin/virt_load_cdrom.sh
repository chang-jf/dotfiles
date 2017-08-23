#!/bin/bash
# This script help operate guest cdrom drive for changing and insert new iso files.
# Usage: virt_load_cdrom.sh iso_file
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: virt_load_cdrom.sh VM_NAME_TO_CHANGE_MEDIA" && sudo virsh list && die
[ -z $2 ] && warn "Usage: virt_load_cdrom.sh $1 PATH_TO_ISO" && sudo virsh vol-list --pool iso && die
sudo virsh change-media $1 hda --eject
sudo virsh change-media $1 hda $2 --insert
