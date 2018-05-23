#!/bin/bash
##Office1
nmcli connection add ifname enp0s25 con-name HISCFixIP autoconnect yes type ethernet\
 -- ipv4.method manual ipv4.address 10.162.9.199/24 ipv4.gateway 10.162.9.1 ipv4.dns 8.8.8.8 +ipv4.dns 168.95.192.1\
 +ipv4.dns 8.8.4.4 +ipv4.dns 168.95.192.1

##Office2
nmcli connection add ifname enp0s25 con-name HISFixIP autoconnect yes type ethernet\
 -- ipv4.method manual ipv4.address 192.168.1.199/24 ipv4.gateway 192.168.1.254 ipv4.dns 8.8.8.8 +ipv4.dns 168.95.192.1\
 +ipv4.dns 8.8.4.4 +ipv4.dns 168.95.192.1

##Taipower pentest
nmcli connection add ifname enp0s25 con-name Taipower-pentest autoconnect yes type ethernet\
 -- ipv4.method manual ipv4.address 10.162.9.12/16 ipv4.gateway 10.162.200.254 ipv4.dns 10.162.10.12 +ipv4.dns 10.162.10.72

##Taipower vul scan
nmcli connection add ifname enp0s25 con-name Taipower-scanner autoconnect no type ethernet\
 -- ipv4.method manual ipv4.address 10.162.9.66/16 ipv4.gateway 10.162.200.254 ipv4.dns 10.162.10.12 +ipv4.dns 10.162.10.72

##traffic cable/ip audit1
nmcli connection add ifname enp0s25 con-name Traffic1 autoconnect yes type ethernet\
 -- ipv4.method manual ipv4.address 10.7.6.143/24 ipv4.gateway 10.7.6.1 ipv4.dns 10.2.6.251 +ipv4.dns 10.2.6.252 +ipv4.dns 10.2.6.253 +ipv4.dns 10.2.6.254

##traffic cable/ip audit2
nmcli connection add ifname enp0s25 con-name Traffic2 autoconnect no type ethernet\
 -- ipv4.method manual ipv4.address 10.7.6.144/24 ipv4.gateway 10.7.6.1 ipv4.dns 10.2.6.251 +ipv4.dns 10.2.6.252 +ipv4.dns 10.2.6.253 +ipv4.dns 10.2.6.254

##固定IP
nmcli connection add ifname enp0s25 con-name FixIP autoconnect no type ethernet\
 -- ipv4.method manual ipv4.address 192.168.1.253/24 ipv4.gateway 192.168.1.254 ipv4.dns 8.8.8.8 +ipv4.dns 168.95.192.1 +ipv4.dns 8.8.4.4 +ipv4.dns 168.95.192.1

##DHCP
nmcli connection add ifname enp0s25 con-name DHCP autoconnect no type ethernet 
