#!/bin/bash
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
#Select iso location for make tempalte with
#==========================================
PS3="Select a installation iso from repository: "
select ISO in `find $ISO_DIR -maxdepth 1 \( -iname *.iso -o -iname *.vfd \) -type f -print|sort`
do
    [ $REPLY != '' ] && break
done
[ -z $ISO ] && die "iso not selected."
[ -r $ISO ] && warn "Provision with $GREEN [$ISO] $NC" || die "[$ISO] Not readable, Aborting..."

#what is name of your vm?
#Specify VM name
#========================
[ $AUTO_INSTALL == "TRUE" ] && VM_NAME="`basename $ISO`_Template" || `read -e -p "Specify VM name: " -i "`basename $ISO`_Template" VM_NAME`
[ -z $VM_NAME ] && die "No VM name specified, aborting..."
[[ ! $VM_NAME =~ ^[0-9a-zA-Z_-\.]+$ ]] && die "Invalid VM name, Aborting..." || warn "Set VM name to $GREEN[$VM_NAME]$NC"

#what is filename of your vm image and size?
#make VM image if not existed
#put vm image in template home with vm_name+.img
#===============================================
[ $AUTO_INSTALL != "TRUE" ] && `read -e -p "Specify VM disk size: " -i $VM_DISK_SIZE VM_DISK_SIZE`
[ -z $VM_DISK_SIZE ] && die "No VM size specified, aborting..."
[[ ! $VM_DISK_SIZE =~ ^[0-9bBkKmMgGtT]+$ ]] && die "Invalid VM disk size, Aborting..." || warn "Set VM disk size to $GREEN[$VM_DISK_SIZE]$NC"

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
cat >$QEMU_HOME"/Template/Rebuild_Template/"$VM_NAME".sh"<<START_SHELL
#!/bin/bash
echo "to rebuild template, erase image file of tempalte from template directory then run again."
[ -f $QEMU_TEMPLATE_DIR/$VM_NAME.img ] && echo "VM img Founded, invoking instance..." || qemu-img create -f qcow2 "$QEMU_TEMPLATE_DIR/$VM_NAME.img" $VM_DISK_SIZE
kvm -name $VM_NAME -boot order=c,once=d -m $MEM_SIZE -vga $VGA -soundhw $SOUND_HW -drive file="$QEMU_TEMPLATE_DIR/$VM_NAME.img",index=0,media=disk -drive file="$ISO",index=1,media=cdrom -net nic,model=$NIC,macaddr=$MAC_ADDR -net $NET
START_SHELL
chmod u+x $QEMU_HOME"/bin/"$VM_NAME".sh"

exit
