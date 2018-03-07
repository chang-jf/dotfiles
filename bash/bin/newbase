#!/bin/bash
VM_HOST="127.0.0.1"
ISO_SOURCE=$1
VM_LOCATION=$2
VM_GUEST=$3
#ISO_SOURCE="/home/KVM/iso/SW_DVD5_SA_Win_Ent_7w_SP1_64BIT_ChnTrad_-2_MLF_X17-59110"
RANDOM_MAC=`/home/angus/.bin/random_mac2.sh`
warn() {
    echo "$1" >&2
    echo ""
}

die() {
    warn "$1"
    #sudo virsh --connect qemu+tcp://$VM_HOST/system vol-list --pool iso
    exit 1
}
[ -z $1 ] && warn "Usage: virt_new_window_vm PATH_TO_ISO_FILE" && sudo virsh --connect qemu+tcp://$VM_HOST/system vol-list --pool iso && die
[ -z $2 ] && warn "Usage: virt_new_window_vm $ISO_SOURCE POOLS_TO_INSTALL" && sudo virsh --connect qemu+tcp://$VM_HOST/system pool-list --all && die
[ -z $3 ] && warn "Usage: virt_new_window_vm $ISO_SOURCE $VM_LOCATION NAME_OF_VM" && sudo virsh --connect qemu+tcp://$VM_HOST/system list --all && die


sudo virt-install --connect qemu+tcp://$VM_HOST/system --name $VM_GUEST --memory 2048 \
    --clock offset=localtime \
    --disk pool=$VM_LOCATION,size=50,bus=virtio \
    --network default,model=virtio,mac="$RANDOM_MAC" \
    --video qxl --graphic spice,listen=0.0.0.0 --channel spicevmc,target_type=virtio,name='com.redhat.spice.0' \
    --cdrom $ISO_SOURCE

echo "virsh change-media $VM_GUEST hda --eject"
echo "virsh change-media $VM_GUEST hda ISO_LOCATION --insert"
#    `virt-install --connect qemu+tcp://10.162.9.13/system --name test --memory 2048 \
#        --disk size=9,bus=virtio \
#        --network default,model=virtio,mac=52:54:00:11:22:33 \
#        --video qxl --graphic spice,listen=0.0.0.0 --channel spicevmc,target_type=virtio,name='com.redhat.spice.0' \
#        --cdrom /home/KVM/iso/SW_DVD5_SA_Win_Ent_7w_SP1_64BIT_ChnTrad_-2_MLF_X17-59110`
#
