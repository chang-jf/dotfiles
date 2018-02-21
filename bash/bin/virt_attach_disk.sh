#!/bin/bash
VM_HOST="127.0.0.1"
DISK_SIZE=$1
TARGET_VM=$2
TARGET_DEVICE=$3
RANDOM_NAME=`/home/angus/.bin/genmypass.sh`
BLANK_DISK_IMAGE="/home/KVM/short_term_vms/$RANDOM_NAME"
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && die "Usage: virt_attach_disk.sh DISK_SIZE(GB)"
[ -z $2 ] && warn "Usage: virt_new_window_vm $DISK_SIZE TARGET_VM" && sudo virsh --connect qemu+tcp://$VM_HOST/system list --all && die
[ -z $3 ] && warn "Usage: virt_new_window_vm $DISK_SIZE $TARGET_VM TARGET_DEVICE" && sudo virsh --connect qemu+tcp://$VM_HOST/system domblklist $TARGET_VM && die

sudo dd if=/dev/zero of=$BLANK_DISK_IMAGE bs=1073741824 count=$DISK_SIZE && sudo chmod 777 $BLANK_DISK_IMAGE
sudo virsh attach-disk $TARGET_VM $BLANK_DISK_IMAGE $TARGET_DEVICE
