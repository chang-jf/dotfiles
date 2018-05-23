#!/bin/bash
#My after_ubuntu, prepare environment and install utils after fresh install.
#now support ubuntu 1510

function pause(){
#read -p "$*"
echo "$*"
}

pause '####**Update repository**'
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean
  
pause '####**Checkout vimrc**'
curl -o - https://raw.githubusercontent.com/chang-jf/vimrc/master/auto-install.sh | sh

pause '####**Install chrome browser**'
#sudo apt-get -y install libxss1 libappindicator1 libindicator7
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo dpkg -i google-chrome*.deb

pause '####**All done, lets roll**'
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean

#1. Disable screen lock
調校->settings->power->Blank screen->Never
調校->Settings->Privacy->Screen Lock->Automatic Screen Lock
#2. Enable Intelligent sidebar
調校->Extensions->Dash to dock->Option->Intelligent autohide->enable
調校->Extensions->Dash to dock->Option->Intelligent autohide->options->Auto hide->Disable
#3. Check updates
sudo apt-get update && apt-get upgrade && apt-get dist-upgrade -y && apt-get -y autoremove && apt-get -y autoclean && -y clean
#4. Install Tor
sudo apt-get install tor && sudo service tor start
#5. install file-roller
sudo apt-get install unrar unace rar unrar p7zip zip unzip p7zip-full p7zip-rar file-roller -y
#6. Add standard user
sudo useradd -m angus
sudo dpkg-reconfigure wireshark-common 
sudo usermod -a -G wireshark angus
newgrp wireshark

sudo apt-get remove -y iceweasel && sudo apt-get install firefox


Settings->裝置->滑鼠和觸控板->觸控板->輕觸表示點擊
Settings->裝置->滑鼠和觸控板->觸控板->邊緣捲動

sudo apt-get -y install mtr htop nethogs ipcalc
#nethogs eth0
sudo apt-get install ibus-chewing

sudo apt-get install openvas
openvas-setup
openvas-scapdata-sync
openvas-certdata-sync
openvas-adduser
gsd
