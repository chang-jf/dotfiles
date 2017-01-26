#!/bin/bash
# to make OS template, enable default hardware as simple as possible
# -nodefault
# 2G memory
# cirrus VGA
# ac97 sound hw
# 20G ide disk for OS
# icd cdrom for OS installation media
# ide cdrom for windows driver iso(if install windows
# user mode network
[ -f ~/.bin/ANSI_COLOR.conf ] && source ~/.bin/ANSI_COLOR.conf
warn() {
    echo -e "$1" >&2
}

die() {
    warn "$RED $1 $NC"
    exit 1
}

#Initial environment read from configuration
#======================================
[ -f $0.conf ] && source $0.conf || die "$0.conf not exist, Process aborting..."

#Select iso location for make tempalte with
#==========================================
PS3="Select a installation iso from repository: "
select ISO in `find $ISO_DIR -maxdepth 1 \( -iname *.iso -o -iname *.vfd \) -type f -print|sort`
do
    [ $REPLY != '' ] && break
done
[ -z $ISO ] && die "iso not selected."
[ -r $ISO ] && warn "Provision with $GREEN [$ISO] $NC" || die "[$ISO] Not readable, Aborting..."
ISO_CONFIG="-drive file='$ISO',if=ide,index=2,media=cdrom"

#specify boot order
BOOT_ORDER_CONFIG="-boot order=$BOOT_ORDER,once=d"

#Specify VM name
#========================
[ $AUTO_INSTALL == "TRUE" ] && VM_NAME="`basename $ISO`_Template" || read -e -p "Specify VM name: " -i "`basename $ISO`_Template" VM_NAME
[ -z $VM_NAME ] && die "No VM name specified, aborting..."
[[ ! $VM_NAME =~ ^[0-9a-zA-Z_-\.]+$ ]] && die "Invalid VM name, Aborting..." || warn "Set VM name to $GREEN[$VM_NAME]$NC"
VM_NAME_CONFIG="-name '$VM_NAME'"

#what is filename of your vm image and size?
#make VM image if not existed
#put vm image in template home with vm_name+.img
#===============================================
[ $AUTO_INSTALL != "TRUE" ] && `read -e -p "Specify VM disk size: " -i $VM_DISK_SIZE VM_DISK_SIZE`
[ -z $VM_DISK_SIZE ] && die "No VM size specified, aborting..."
[[ ! $VM_DISK_SIZE =~ ^[0-9bBkKmMgGtT]+$ ]] && die "Invalid VM disk size, Aborting..." || warn "Set VM disk size to $GREEN[$VM_DISK_SIZE]$NC"
VM_DISK="$QEMU_TEMPLATE_DIR/$VM_NAME.img"
VM_SCRIPT="$QEMU_TEMPLATE_DIR/Rebuild_Template/$VM_NAME.sh"
VM_DISK_CONFIG="-drive file='$VM_DISK',if=ide,index=0,media=disk"

#what is memory size?
#====================
[ $AUTO_INSTALL != "TRUE" ] && `read -e -p "Allocate Memory size: " -i $MEM_SIZE MEM_SIZE`
[ -z $MEM_SIZE ] && die "No memory size specified, aborting..."
[[ ! $MEM_SIZE =~ ^[0-9bBkKmMgGtT]+$ ]] && die "Invalid memory size, Aborting..." || warn "Set $GREEN[$MEM_SIZE]$NC memory for VM"
MEM_CONFIG="-m $MEM_SIZE"

#setup sound card
#================
if [ $AUTO_INSTALL == "TRUE" ]
then
    SOUND_HW=$DEFAULT_SOUND_HW
else
    REPLY=''
    PS3="Select a sound card: "
    select SOUND_HW in ${SOUND_HWS[*]}
    do
        [ $REPLY != '' ] && break
    done
fi
[ -z $SOUND_HW ] && die "Sound card not selected." || warn "Provision with sound card:$GREEN [$SOUND_HW] $NC"
SOUND_HW_CONFIG="-soundhw '$SOUND_HW'"


#setup vga card
#==============
if [ $AUTO_INSTALL == "TRUE" ]
then
    VGA=$DEFAULT_VGA
else
    REPLY=''
    PS3="Select a vga card: "
    select VGA in ${VGAS[*]}
    do
        [ $REPLY != '' ] && break
    done
fi
[ -z $VGA ] && die "VGA card not selected." || warn "Provision with vga card:$GREEN [$VGA] $NC"
VGA_CONFIG="-vga '$VGA'"

#determine nic
#=============
if [ $AUTO_INSTALL == "TRUE" ]
then
    NIC=$DEFAULT_NIC
else
    REPLY=''
    PS3="Select a network card: "
    select NIC in ${NICS[*]}
    do
        [ $REPLY != '' ] && break
    done
fi
[ -z $NIC ] && die "NIC not selected." || warn "Provision with network card:$GREEN [$NIC] $NC"
MAC_ADDR=$(/home/angus/.bin/qemu-mac-hasher.py $VM_NAME)
[ -z $MAC_ADDR ] && MAC_ADDR=`/home/angus/.bin/random_mac.sh` || warn "Provision with MAC address:$GREEN [$MAC_ADDR] $NC"
#NIC_CONFIG="-net nic,model='$NIC',macaddr='$MAC_ADDR'"
NIC_CONFIG="-device '$NIC',netdev='netdev-`echo $MAC_ADDR|sed -e 's/://g'`',mac='$MAC_ADDR'"

#determine net backend
#=====================
if [ $AUTO_INSTALL == "TRUE" ]
then
    NET=$DEFAULT_NET
else
	REPLY=''
	PS3="Select a network backend: "
	select NET in ${NETS[*]}
	do
	    [ $REPLY != '' ] && break
	done
fi
[ -z $NET ] && die "Network backend not selected." || warn "Provision with network backend:$GREEN [$NET] $NC"
#NET_CONFIG="-net $NET"
NET_CONFIG="-netdev '$NET',id='netdev-`echo $MAC_ADDR|sed -e 's/://g'`'"

#generate startup script
#====================
#cat >$QEMU_HOME"/Template/Rebuild_Template/"$VM_NAME".sh"<<START_SHELL
cat >$VM_SCRIPT<<START_SHELL
#!/bin/bash
echo "to rebuild template, erase image file of tempalte from template directory then run again."

[ -f $VM_DISK ] && echo "VM img Founded, invoking instance..." || qemu-img create -f qcow2 "$VM_DISK" $VM_DISK_SIZE

$KVM $VM_NAME_CONFIG $MEM_CONFIG $VGA_CONFIG $SOUND_HW_CONFIG $BOOT_ORDER_CONFIG $VM_DISK_CONFIG $ISO_CONFIG $NIC_CONFIG $NET_CONFIG
START_SHELL
#chmod u+x $QEMU_HOME"/Template/Rebuild_Template/"$VM_NAME".sh"
chmod u+x $VM_SCRIPT

exit
