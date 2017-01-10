#!/bin/bash
# select tempalte from template dir as backing file
# name an instance, if name existed, append random string after it
# put named vm instance file into ~/kvm/instance
[ -f ~/.bin/ANSI_COLOR.conf ] && source ~/.bin/ANSI_COLOR.conf
warn() {
    echo -e "$1" >&2
}

die() {
    warn "$RED $1 $NC"
    exit 1
}

#Initial environment from configuration
#======================================
[ -f $0.conf ] && source $0.conf || die "$0.conf not exist, Process aborting..."

#what OS to install?
#Select base template
#==========================================
REPLY=''
PS3="Select a template for make up instance: "
select TEMPLATE in `find $QEMU_TEMPLATE_DIR -maxdepth 1 -iname *.img -type f -print|sort`
do
    [ $REPLY != '' ] && break
done
[ -z $TEMPLATE ] && die "Template not selected."
[ -r $TEMPLATE ] && warn "Making VM instance from $GREEN [$TEMPLATE] $NC" || die "[$TEMPLATE] Not readable, Aborting..."

#what is name of your vm?
#Specify VM name
#========================
UNIQUE_INSTANCE_NAME=`date +%M%S%N|md5sum|sed 's/^\(..........\).*$/\1/'`
[ $AUTO_INSTALL == "TRUE" ] && VM_NAME=$UNIQUE_INSTANCE_NAME || `read -e -p "Specify VM name: " -i $UNIQUE_INSTANCE_NAME VM_NAME`
[ -z $VM_NAME ] && die "No VM name specified, aborting..."
[[ ! $VM_NAME =~ ^[0-9a-zA-Z_-\.]+$ ]] && die "Invalid VM name, Aborting..." || warn "Set VM name to $GREEN[$VM_NAME]$NC"
unset UNIQUE_INSTANCE_NAME

#what is memory size?
#====================
[ $AUTO_INSTALL != "TRUE" ] && `read -e -p "Allocate Memory size: " -i $MEM_SIZE MEM_SIZE`
[ -z $MEM_SIZE ] && die "No memory size specified, aborting..."
[[ ! $MEM_SIZE =~ ^[0-9bBkKmMgGtT]+$ ]] && die "Invalid memory size, Aborting..." || warn "Set $GREEN[$MEM_SIZE]$NC memory for VM"

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

#generate startup script
#====================
cat >$QEMU_HOME"/bin/"$VM_NAME<<START_SHELL
[ -f "$QEMU_INSTANCE_DIR/$VM_NAME.img" ] && echo "VM instance Founded, invoking instance..." || qemu-img create -o backing_file="$TEMPLATE",backing_fmt=qcow2 -f qcow2 "$QEMU_INSTANCE_DIR/$VM_NAME.img"
kvm -name "$VM_NAME" -boot order=c,once=d -m $MEM_SIZE -vga $VGA -soundhw $SOUND_HW -drive file="$QEMU_INSTANCE_DIR/$VM_NAME.img",index=0,media=disk -drive file="$VIRTIO_DRIVER",index=1,media=cdrom -net nic,model=$NIC,macaddr=$MAC_ADDR -net $NET
START_SHELL
chmod u+x $QEMU_HOME"/bin/"$VM_NAME

exit
