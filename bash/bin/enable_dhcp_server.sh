#!/bin/bash
#sudo apt-get install isc-dhcp-server
#echo "INTERFACES="enx00606eb155ea">/etc/default/isc-dhcp-server
#cat <<EOT >> /etc/dhcp/dhcpd.conf
#option domain-name "hisc.com.tw";
#option domain-name-servers 168.95.192.1, 8.8.8.8;
#
#default-lease-time 60;
#max-lease-time 720;
#log-facility local7;
#subnet 10.0.0.0 netmask 255.255.255.0 {
#range 10.0.0.150 10.0.0.253;
#option routers 10.0.0.254;
#option subnet-mask 255.255.255.0;
#option broadcast-address 10.0.0.255;
#option domain-name-servers 168.95.192.1, 8.8.8.8;
#option ntp-servers 10.0.0.1;
#option netbios-name-servers 10.0.0.1;
#option netbios-node-type 8;
#}
#EOT
sudo service isc-dhcp-server restart
sudo ufw allow from any port 68 to any port 67 proto udp
#sudo ufw allow in on eth0 from any port 68 to any port 67 proto udp
sudo netstat -uap
#https://askubuntu.com/questions/140126/how-do-i-install-and-configure-a-dhcp-server#184351
