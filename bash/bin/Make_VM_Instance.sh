#!/bin/bash
# to make OS Instance
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

#Select base template
#==========================================
REPLY=''
echo -e "\n$YELLOW 選擇虛擬機樣本： $NC\n"
PS3="Select a template for make up instance: "
select TEMPLATE in `find $QEMU_TEMPLATE_DIR -maxdepth 1 -iname *.img -type f -print|sort`
do
        [ $REPLY != '' ] && break
    done
    [ -z $TEMPLATE ] && die "Template not selected."
    [ -r $TEMPLATE ] && warn "Making VM instance from $GREEN [$TEMPLATE] $NC" || die "[$TEMPLATE] Not readable, Aborting..."

#Select iso location for make tempalte with
#==========================================
echo -e "\n$YELLOW 除了virtio windows驅動CD(預設自動掛載)外，選擇額外掛載的iso file： $NC\n"
PS3="Select iso to mount(installation CD , application or drivers?): "
select ISO in `find $ISO_DIR -maxdepth 1 \( -iname *.iso -o -iname *.vfd \) -type f -print|sort`
do
    [ $REPLY != '' ] && break
done
[ -z $ISO ] && die "iso not selected."
[ -r $ISO ] && warn "Provision with $GREEN [$ISO] $NC" || die "[$ISO] Not readable, Aborting..."
ISO_CONFIG="-drive file='$ISO',if=ide,index=2,media=cdrom"
ISO_CONFIG=$ISO_CONFIG" -drive file='$VIRTIO_DRIVER',if=ide,index=3,media=cdrom"

#specify boot order
#BOOT_ORDER_CONFIG="-boot order=$BOOT_ORDER,once=d"

#Specify VM name
#========================
echo -e "\n$YELLOW 指定虛擬機名稱： $NC\n"
UNIQUE_INSTANCE_NAME=`date +%M%S%N|md5sum|sed 's/^\(..........\).*$/\1/'`
[ $AUTO_INSTALL == "TRUE" ] && VM_NAME=$UNIQUE_INSTANCE_NAME || read -e -p "Specify VM name: " -i `basename $TEMPLATE`"_Instance" VM_NAME
[ -z $VM_NAME ] && die "No VM name specified, aborting..."
[[ ! $VM_NAME =~ ^[0-9a-zA-Z_-\.]+$ ]] && die "Invalid VM name, Aborting..." || warn "Set VM name to $GREEN[$VM_NAME]$NC"
VM_NAME_CONFIG="-name '$VM_NAME'"

#what is filename of your vm image?
#put vm image in Instance directory with vm_name+.img
#===============================================
VM_DISK="$QEMU_INSTANCE_DIR/$VM_NAME.img"
VM_SCRIPT="$QEMU_HOME/bin/$VM_NAME.sh"
VM_DISK_CONFIG="-drive file='$VM_DISK',if=ide,index=0,media=disk"

#what is memory size?
#====================
echo -e "\n$YELLOW 指定分配給虛擬機的記憶體容量： $NC\n"
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
    echo -e "\n$YELLOW 選擇音效卡：$NC\n"
    echo -e "$YELLOW 7) hda    - Windows 7建議使用$NC\n"
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
    echo -e "\n$YELLOW 選擇顯示卡： $NC\n"
    echo -e "$YELLOW 2) qxl    - 虛擬機安裝於遠端宿主機選擇qxl驅動以spice連線至虛擬機 $NC"
    echo -e "$YELLOW 3) cirrus - 本機管理Windows 7虛擬機時$NC\n"
    REPLY=''
    PS3="Select a vga card: "
    select VGA in ${VGAS[*]}
    do
        [ $REPLY != '' ] && break
    done
fi
[ -z $VGA ] && die "VGA card not selected." || warn "Provision with vga card:$GREEN [$VGA] $NC"
VGA_CONFIG="-vga '$VGA'"
SPICE_CONFIG=" -spice port=\$free_spice_port,disable-ticketing \
    -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent \
    -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
    -usb \
    -device ich9-usb-ehci1,id=usb \
    -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,multifunction=on \
    -device ich9-usb-uhci2,masterbus=usb.0,firstport=2 \
    -device ich9-usb-uhci3,masterbus=usb.0,firstport=4 \
    -chardev spicevmc,name=usbredir,id=usbredirchardev1 \
    -device usb-redir,chardev=usbredirchardev1,id=usbredirdev1 \
    -chardev spicevmc,name=usbredir,id=usbredirchardev2 \
    -device usb-redir,chardev=usbredirchardev2,id=usbredirdev2 \
    -chardev spicevmc,name=usbredir,id=usbredirchardev3 \
    -device usb-redir,chardev=usbredirchardev3,id=usbredirdev3 "
[ "$VGA" == "qxl" ] && VGA_CONFIG="$VGA_CONFIG $SPICE_CONFIG"

#determine nic
#=============
if [ $AUTO_INSTALL == "TRUE" ]
then
    NIC=$DEFAULT_NIC
else
    echo -e "\n$YELLOW 選擇網路卡： $NC\n"
    echo -e "$YELLOW 1)  e1000          - 預設 $NC"
    echo -e "$YELLOW 25) virtio-net-pci - 半虛擬化驅動$NC\n"
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
    echo -e "\n$YELLOW 選擇網路模式： $NC\n"
    echo -e "$YELLOW 1) user           - 虛擬機內可以\\10.0.2.4\qemu與宿主機交換檔案，僅支援tcp/udp，無icmp(NATed mode) $NC"
    echo -e "$YELLOW 2) tap            - 連至default route bridge, 虛擬機與宿主機位於同一網路(bridged mode) $NC"
    echo -e "$YELLOW 3) bridge         - 連接至指定bridge, bridge需手動設定，可以實作(host only/isolated) $NC\n"
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

if [ "$NET" == "user" ]
then
    NET_CONFIG="$NET_CONFIG,smb='$QEMU_HOME/utilities'"
fi

#generate startup script
#====================
cat >$VM_SCRIPT<<START_SHELL
#!/bin/bash
default_spice_port="5930"
concurrent_max_spice_port=\$default_spice_port
concurrent_max_spice_port=\`netstat -tunlp 2>/dev/null|grep 0.0.0.0:59|awk '{print \$4}'|sed 's/0.0.0.0://g'|sort -nr|head -n1\`
[ \$concurrent_max_spice_port ] && free_spice_port=\`echo \$concurrent_max_spice_port+1|bc\` || free_spice_port=\$default_spice_port

[ -f $VM_DISK ] && echo "VM img Founded, invoking instance..." || qemu-img create -o backing_file=$TEMPLATE,backing_fmt=qcow2 -f qcow2 "$VM_DISK"

$KVM $KVM_CONFIG $VM_NAME_CONFIG $MEM_CONFIG $VGA_CONFIG $SOUND_HW_CONFIG $BOOT_ORDER_CONFIG $VM_DISK_CONFIG $ISO_CONFIG $NIC_CONFIG $NET_CONFIG
START_SHELL
if [ $NET == "user" ] 
then
    sed -i '1a if (mount|grep KVM/utilities>/dev/null); then\
    echo "mounted"\
else\
    sudo mount --bind /home/angus/iso /home/angus/KVM/utilities\
    sudo mount -o remount,ro,bind /home/angus/iso /home/angus/KVM/utilities\
fi' $VM_SCRIPT
fi
chmod u+x $VM_SCRIPT

exit
