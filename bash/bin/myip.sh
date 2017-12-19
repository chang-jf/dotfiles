#!/bin/bash
MAINNIC=$(ip route show | grep default | awk '{print $5}')
MAINIP=$(ip addr show dev $MAINNIC | grep "inet" | awk 'NR==1{print $2}' | cut -d'/' -f 1)
SUBNET=$(ip route | grep "src $MAINIP" | awk '{print $1}')
GATEWAYIP=$(ip route show | grep default | awk '{print $3}')
echo "MAINNIC:"$MAINNIC
echo "MAINIP:"$MAINIP
echo "SUBNET:"$SUBNET
echo "GATEWAYIP:"$GATEWAYIP
