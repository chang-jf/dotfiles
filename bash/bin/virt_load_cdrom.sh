#!/bin/bash
# This script help operate guest cdrom drive for changing and insert new iso files.
# Usage: virt_load_cdrom.sh iso_file
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    virsh vol-list --pool iso
    exit 1
}
[ -z $1 ] && die "Usage: virt_load_cdrom.sh vm_name iso_file"
virsh change-media $1 hda --eject
virsh change-media $1 hda $2 --insert
