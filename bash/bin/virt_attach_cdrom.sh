#!/bin/bash
VM_HOST="127.0.0.1"
TARGET_VM=$1
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}
[ -z $1 ] && warn "Usage: virt_attach_cdrom.sh VM_NAME" && sudo virsh list --all && die

sudo virsh attach-device $1 ./virt_cdrom.xml --current
