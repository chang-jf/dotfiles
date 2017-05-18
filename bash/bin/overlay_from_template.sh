#!/bin/bash
# This script help making overlay vm instance from existed vm template
# Usage: overlay_from_template.sh TEMPLATE_VOL NEW_POOL NEW_NAME
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    virsh vol-list --pool vm_templates
    exit 1
}
[ -z $1 ] && die "Usage: overlay_from_template.sh TEMPLATE_VOL NEW_POOL NEW_NAME"
[ -z $2 ] && die "Usage: overlay_from_template.sh TEMPLATE_VOL NEW_POOL NEW_NAME"
[ -z $3 ] && die "Usage: overlay_from_template.sh TEMPLATE_VOL NEW_POOL NEW_NAME"
TEMPLATE_VOL=$1
INSTANCE_POOL=$2
INSTANCE_VOL=$3

virsh vol-create-as $INSTANCE_POOL $INSTANCE_VOL 20G --format qcow2 \
    --backing-vol `virsh vol-key --pool vm_templates $TEMPLATE_VOL` --backing-vol-format qcow2
virt-install -n $INSTANCE_VOL -r 2048 --disk vol=$INSTANCE_POOL/$INSTANCE_VOL --noautoconsole --import

echo "remote-viewer "`virsh domdisplay $INSTANCE_VOL`

echo "#!/bin/bash">/tmp/undo.sh
echo "virsh detroy $INSTANCE_VOL">>/tmp/undo.sh
echo "virsh undefine $INSTANCE_VOL --storage hda">>/tmp/undo.sh

chmod 755 /tmp/undo.sh
# #########################################################################################
# 使用backing-chain
# #此法可行，但要注意產生出新的OS後,backing file的大小會產生變化(變大)，因此原本算到剛剛好夠匯入base image的volume大小就會不夠，virt-install時顯示出來的錯誤是permission_denied，這點有點不合理，需要重做實驗驗證
# 1. 按照上方作法匯入base image
# 2. 根據匯入之base image製作volume
# virsh vol-create-as short_lived_vms aa 20G --format qcow2 --backing-vol /templates/SW_DVD5_SA_Win_Ent_7w_SP1_64BIT_ChnTrad_-2_MLF_X17-59110.ISO_Template.img --backing-vol-format qcow2
# 3. 使用剛剛製作出的volume配合virt-install的--import製作新的OS
# virt-install -n bb -r 2048 --os-type=windows --os-variant=win7 --disk vol=short_lived_vms/aa --noautoconsole --import 
# #########################################################################################
