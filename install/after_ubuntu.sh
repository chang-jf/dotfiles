#!/bin/bash
#My after_ubuntu, prepare environment and install utils after fresh install.
#now support ubuntu 1510

function pause(){
#read -p "$*"
echo "$*"
}

pause '####**Update repository**'
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean
  
pause '####**Remove useless built-in application**'
#sudo apt-get remove -y thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku landscape-client-ui-install

pause '####**disable Online Search and Shopping Suggestions from Ubuntu 15.04 Dash**'
pause '*disable online search*'
#sudo gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
#sudo cat > ~/disable_onlinesearch.desktop <<END
#[Desktop Entry]
#Name=Disable Search
#Exec=/bin/bash -c "gsettings set com.canonical.Unity.Lenses remote-content-search 'none'"
#Type=Application
#END
#sudo chown root:root ~/disable_onlinesearch.desktop
#sudo chmod 644 ~/disable_onlinesearch.desktop
#sudo mv ~/disable_onlinesearch.desktop /etc/xdg/autostart/

#pause '*disable shopping suggestions*'
#sudo gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

#pause '*Remove Amazon launcher*'
#sudo rm -f /usr/share/applications/ubuntu-amazon-default.desktop
#pause '*Adjust file encoding order for gedit*'
#gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'BIG5', 'BIG5-HKSCS', 'EUC-TW', 'GB18030', 'GB2312', 'GBK', 'CURRENT', 'ISO-8859-15', 'UTF-16']"


pause '####**Install utilities**'
sudo apt-get -y --ignore-missing install bash-completion curl git lftp tmux wget vim vim-gui-common lynx cmake python-dev rsync build-essential
#sudo apt-get -y --ignore-missing install rar unrar p7zip p7zip-full p7zip-rar exfat-fuse exfat-utils hime
sudo apt-get -y --ignore-missing install rar unrar p7zip p7zip-full p7zip-rar exfat-fuse exfat-utils net-tools ibus-chewing


#pause '####**Setup Chinese input menthod **hime****'
#im-config -n hime
#mkdir -p ~/.config/hime
#cp ~/.dotfiles/hime/hime.conf ~/.config/hime/
#chmod 700 ~/.config
#chmod 775 ~/.config/hime
#chmod 664 ~/.config/hime/hime.conf




pause '####**Checkout vimrc**'
curl -o - https://raw.githubusercontent.com/chang-jf/vimrc/master/auto-install.sh | sh

pause '####**Install chrome browser**'
#sudo apt-get -y install libxss1 libappindicator1 libindicator7
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo dpkg -i google-chrome*.deb

#pause '####**Install dropbox**'
#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
#~/.dropbox-dist/dropboxd& >/dev/null 2>&1 

pause '*The meaning of **Optional** is they are optional, only uncomment necessary items'

# laptop-mode-tools's function equal to tlp, chose one, install then forget it.
# use powertop to verify power management tweak result
pause '####**(Optional)Install laptop tools**'
#sudo apt-get -y install laptop-mode-tools

#Starting with Ubuntu wily TLP is provided via the offical Ubuntu repos.
#sudo add-apt-repository ppa:linrunner/tlp
#sudo apt-get update
#sudo apt-get -y install tlp tlp-rdw
#sudo apt-get -y install powertop

#openshot manual: http://www.openshotusers.com/help/1.3/zh_TW/
#play video : vlc/mplayer
    #vlc :     .wav, .ra, .mpeg, .3gp, .asf, .asx, .m2p
    #mplayer : .divx, .avc
#play audio : audacious/qmmp
#video transcoder : handbrake
#video editor : openshot, pitivi
#mp3 tag editor : easytag
#subtitle editor : aegisub/SrtEdit(win32)

#pause '####**(Optional)Add Extended Multimedia Support**'
#sudo apt-get -y install vlc audacious
sudo apt-get -y install vlc

pause '####**(Optional)Install media codecs and Java sdk in order to decode and support other restricted media formats**'
#sudo apt-get -y install ubuntu-restricted-extras openjdk-8-jdk
sudo apt-get -y install ubuntu-restricted-extras

#pause '####**(Optional)Enable DVD playback and other multimedia codecs**'
#sudo apt-get -y install ffmpeg gstreamer0.10-plugins-bad lame libavcodec-extra
#sudo /usr/share/doc/libdvdread4/install-css.sh
#This sould be able to let you play encrypted DVD, but if not work for you, you probably need **libdvdcss2** and **libdvdread4**
#```
#sudo apt-get -y install libdvdread4
#sudo /usr/share/doc/libdvdread4/install-css.sh
#```
#If can't get libdvdcss2 from above script, try download and install from [VLC]("http://www.videolan.org/") website.

#photo retouching : darktable, rawtherapee
#drawing and image editing : pinta
#photo manager : shotwell, picasa, f-spot, digikam, geeqie
#vector imagery creater(create logos, diagrams or illustrations) : inkscape/dia
#raster graphics(photographs) : gimp/pinta
#pause '####**(Optional)Install image editors**'
#sudo apt-get -y install gimp gimp-data gimp-plugin-registry gimp-data-extras darktable rawtherapee pinta shotwell inkscape

pause '####**(Optional)Install torrent support programs(you knew lftp support torrent right?)**'
sudo apt-get -y install transmission

pause '####**(Optional)Install comic reader)**'
sudo apt-get -y install mcomix

pause '####**All done, lets roll**'
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove && sudo apt-get -y autoclean && sudo apt-get -y clean

####Reference
#[Ten Things To Do After Installing Ubuntu 15.10]("https://websetnet.com/ten-installing-ubuntu-1510/")
#[15 Things to Do After Installing Ubuntu 15.04 Desktop]("http://www.tecmint.com/things-to-do-after-installing-ubuntu-15-04-desktop/")
#[27 Things to Do After Fresh Installation of Ubuntu 15.10 Desktop]("http://www.tecmint.com/things-to-do-after-fresh-installation-of-ubuntu-15-10-desktop/")
