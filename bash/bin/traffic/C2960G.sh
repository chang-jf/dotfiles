#!/bin/bash
#C2960G#show tech-support | redirect tftp://10.7.6.143/20180717_C2960_TechSupport.txt
TARGET_SWITCH="10.7.6.11"
IOS_LOCATION="flash:c2960-lanbasek9-mz.122-44.SE6/"
IOS_NAME="c2960-lanbasek9-mz.122-44.SE6.bin"
TFTP_HOST_MAINNIC=$(ip route show | grep default | awk '{print $5}')
TFTP_HOST=$(ip addr show dev $TFTP_HOST_MAINNIC | grep "inet" | awk 'NR==1{print $2}' | cut -d'/' -f 1)
TFTP_DIR="/tftpboot"
BACKUP_IOS_NAME=$IOS_NAME
#BACKUP_DIR="/home/angus/Dropbox/@work/20170705_台北市交大維護/`date +%Y%m%d-%H%M%S`_月保養"
BACKUP_DIR="/home/angus/Dropbox/@work/20170705_新北市交通大隊維護案/A.月保養紀錄歸檔/`date +%Y%m%d`_月保養"
#BACKUP_DIR="/tmp/`date +%Y%m%d-%H%M%S`_月保養"

echo "**IOS backup utility**"
echo "Now going to backup $IOS_NAME on $TARGET_SWITCH from $IOS_LOCATION directory"
echo "To $TFTP_HOST into $BACKUP_DIR"
echo "Telnet to $TARGET_SWITCH and execute below procedure:"
echo "================================================================================"
echo "en"
echo "copy $IOS_LOCATION$IOS_NAME tftp://10.7.6.143/c2960-lanbasek9-mz.122-44.SE6.bin"
#echo "$TFTP_HOST"
#echo "$BACKUP_IOS_NAME"
#echo "copy nvram:startup-config tftp:"
echo "copy nvram:startup-config tftp://10.7.6.143/C2960_startup-config"
#echo "$TFTP_HOST"
#echo "C2960_startup-config"
#echo "copy flash:vlan.dat tftp:"
echo "copy flash:vlan.dat tftp://10.7.6.143/C2960_vlan.dat"
#echo "$TFTP_HOST"
#echo "C2960_vlan.dat"
echo "sh tech-support | redirect tftp://10.7.6.143/C2960_TechSupport.txt"
echo "quit"
echo "================================================================================"

read -n 1 -s -r -p "Once transfer completed, Press any key to continue..."
echo ""
echo "Checking file integrity and move to backup folder: $BACKUP_DIR"
cd $TFTP_DIR
if md5sum --status -c $BACKUP_IOS_NAME.md5sum; then
    echo "# The MD5 sum matched, backup $BACKUP_IOS_NAME to $BACKUP_DIR"
    mkdir -p $BACKUP_DIR
    cp -ab $TFTP_DIR/$BACKUP_IOS_NAME* $BACKUP_DIR/
    cp -ab C2960_startup-config $BACKUP_DIR/
    cp -ab C2960_vlan.dat $BACKUP_DIR/
    cp -ab C2960_TechSupport.txt $BACKUP_DIR/
    rm -f $TFTP_DIR/$BACKUP_IOS_NAME
    rm -f $TFTP_DIR/C2960_startup-config
    rm -f $TFTP_DIR/C2960_vlan.dat
    rm -f $TFTP_DIR/C2960_TechSupport.txt
    sudo touch $TFTP_DIR/$BACKUP_IOS_NAME && sudo chmod 777 $TFTP_DIR/$BACKUP_IOS_NAME && sudo chown nobody $TFTP_DIR/$BACKUP_IOS_NAME
    sudo touch $TFTP_DIR/C2960_startup-config && sudo chmod 777 $TFTP_DIR/C2960_startup-config && sudo chown nobody $TFTP_DIR/C2960_startup-config
    sudo touch $TFTP_DIR/C2960_vlan.dat && sudo chmod 777 $TFTP_DIR/C2960_vlan.dat && sudo chown nobody $TFTP_DIR/C2960_vlan.dat
    sudo touch $TFTP_DIR/C2960_TechSupport.txt && sudo chmod 777 $TFTP_DIR/C2960_TechSupport.txt && sudo chown nobody $TFTP_DIR/C2960_TechSupport.txt
else
    echo "# The MD5 sum didn't match, require manually troubleshotting"
fi


