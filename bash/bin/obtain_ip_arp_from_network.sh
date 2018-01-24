#!/bin/bash
source /home/angus/.bin/myip.sh
/home/angus/.bin/host_discovery.sh $SUBNET
#SUBNET=`echo $SUBNET|sed -e 's/\/.*$//g'`
logfile=`date +%Y%m%d`_arp_table_for_`echo $SUBNET|sed -e 's/\/.*$//g'`.txt
#echo "logfile:"$logfile
sleep 5
arp -ne|grep ether>./$logfile
wc ./$logfile
