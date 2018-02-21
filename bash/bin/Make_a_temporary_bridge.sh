#!/bin/bash
#1. Setup a bridge
sudo ip link add public_br type bridge
sudo ip addr flush dev enp0s25
sudo ip link set enp0s25 master public_br
sudo ip link set enp0s25 up
sudo ip link set public_br up

#2. setup ip for bridge
#DHCP
#sudo dhclient public_br
#Static
#sudo ip addr add 192.168.100.1/24
#sudo ip route add default via 192.168.100.254 dev public_br

#3. update vm to public 
# check Ch3.Virtual-networks.md line 139 for detail
#sudo virsh update-device w8_mcse /home/angus/w8_mcse_public_br.xml

#4. flush iptables rule
#sudo iptables -t filter -F


#w8_mcse_public_br.xml    
#    <interface type='bridge'>
#      <mac address='52:54:00:02:da:a7'/>
#      <source bridge='public_br'/>
#      <model type='rtl8139'/>
#    </interface>

