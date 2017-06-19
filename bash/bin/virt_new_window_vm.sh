#!/bin/bash
VM_HOST="10.162.9.13"
VM_GUEST=$1
ISO_SOURCE=$2
#ISO_SOURCE="/home/KVM/iso/SW_DVD5_SA_Win_Ent_7w_SP1_64BIT_ChnTrad_-2_MLF_X17-59110"
RANDOM_MAC=`/home/angus/.bin/random_mac2.sh`
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    virsh --connect qemu+tcp://$VM_HOST/system vol-list --pool iso
    exit 1
}
[ -z $1 ] && die "Usage: virt_new_window_vm vm_name iso_file"
[ -z $2 ] && die "Usage: virt_new_window_vm vm_name iso_file"


virt-install --connect qemu+tcp://$VM_HOST/system --name $VM_GUEST --memory 2048 \
    --disk size=9,bus=virtio \
    --network default,model=virtio,mac="$RANDOM_MAC" \
    --video qxl --graphic spice,listen=0.0.0.0 --channel spicevmc,target_type=virtio,name='com.redhat.spice.0' \
    --cdrom $ISO_SOURCE

echo "virsh change-media $VM_GUEST hda --eject"
echo "virsh change-media $VM_GUEST hda ISO_LOCATION --insert"
