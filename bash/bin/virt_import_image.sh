#!/bin/bash
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    exit 1
}

[ -z $1 ] && warn "Usage: virt_import_image.sh POOL_OF_IMAGES" && sudo virsh pool-list --all && die
[ -z $2 ] && warn "Usage: virt_import_image.sh $1 Image_Volume" && sudo virsh vol-list --pool $1 && die

sudo virt-install -n vmname -r 2048 --disk vol=pool_name/vol_name --noautoconsole --import
