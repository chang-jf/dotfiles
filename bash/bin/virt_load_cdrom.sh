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
[ -z $1 ] && warn "Usage: virt_load_cdrom.sh VM_NAME_TO_CHANGE_MEDIA" && sudo virsh list --all&& die
[ -z $2 ] && warn "Usage: virt_load_cdrom.sh $1 PATH_TO_ISO" && sudo virsh vol-list --pool default && die
CDROM_DRIVE=`virsh dumpxml $1|sed -e '/cdrom/,/<\/disk>/{s/<target dev=/CDROM DRIVE /g}'|grep "CDROM DRIVE"|awk '{print $3}'|sed -e "s/'//g"`
#sudo virsh change-media $1 hda --eject
#sudo virsh change-media $1 hda $2 --insert
echo "sudo virsh change-media $1 $CDROM_DRIVE --eject"
echo "sudo virsh change-media $1 $CDROM_DRIVE $2 --insert"
sudo virsh change-media $1 $CDROM_DRIVE --eject
sudo virsh change-media $1 $CDROM_DRIVE $2 --insert
