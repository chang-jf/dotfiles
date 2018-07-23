#!/bin/bash
#C4503#show tech-support | redirect tftp://10.7.6.143/20180717_C4503_TechSupport.txt
TARGET_SWITCH="10.7.6.1"
IOS_LOCATION="bootflash:"
IOS_NAME="cat4500e-ipbase-mz.122-54.SG1.bin"
TFTP_HOST_MAINNIC=$(ip route show | grep default | awk '{print $5}')
TFTP_HOST=$(ip addr show dev $TFTP_HOST_MAINNIC | grep "inet" | awk 'NR==1{print $2}' | cut -d'/' -f 1)
TFTP_DIR="/tftpboot"
BACKUP_IOS_NAME=$IOS_NAME
#BACKUP_DIR="/home/angus/Dropbox/@work/20170705_台北市交大維護/`date +%Y%m%d-%H%M%S`_月保養"
BACKUP_DIR="/home/angus/Dropbox/@work/20170705_台北市交大維護/`date +%Y%m%d`_月保養"
#BACKUP_DIR="/tmp/`date +%Y%m%d-%H%M%S`_月保養"

echo "**IOS backup utility**"
echo "Now going to backup $IOS_NAME on $TARGET_SWITCH from $IOS_LOCATION directory"
echo "To $TFTP_HOST into $BACKUP_DIR"
echo "Telnet to $TARGET_SWITCH and execute below procedure:"
echo "================================================================================"
echo "en"
echo "copy $IOS_LOCATION$IOS_NAME tftp:"
echo "$TFTP_HOST"
echo "$BACKUP_IOS_NAME"
echo "copy nvram:startup-config tftp:"
echo "$TFTP_HOST"
echo "C4503_startup-config"
echo "copy cat4000_flash:vlan.dat tftp:"
echo "$TFTP_HOST"
echo "C4503_vlan.dat"
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
    cp -ab C4503_startup-config $BACKUP_DIR/
    cp -ab C4503_vlan.dat $BACKUP_DIR/
    rm -f $TFTP_DIR/$BACKUP_IOS_NAME
    rm -f $TFTP_DIR/C4503_startup-config
    rm -f $TFTP_DIR/C4503_vlan.dat
    sudo touch $TFTP_DIR/$BACKUP_IOS_NAME && sudo chmod 777 $TFTP_DIR/$BACKUP_IOS_NAME && sudo chown nobody $TFTP_DIR/$BACKUP_IOS_NAME
    sudo touch $TFTP_DIR/C4503_startup-config && sudo chmod 777 $TFTP_DIR/C4503_startup-config && sudo chown nobody $TFTP_DIR/C4503_startup-config
    sudo touch $TFTP_DIR/C4503_vlan.dat && sudo chmod 777 $TFTP_DIR/C4503_vlan.dat && sudo chown nobody $TFTP_DIR/C4503_vlan.dat
else
    echo "# The MD5 sum didn't match, require manually troubleshotting"
fi


