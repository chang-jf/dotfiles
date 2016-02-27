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
sudo apt-get remove -y thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku landscape-client-ui-install

pause '####**disable Online Search and Shopping Suggestions from Ubuntu 15.04 Dash**'
pause '*disable online search*'
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
sudo cat > /etc/xdg/autostart/disable_onlinesearch.desktop <<END
[Desktop Entry]
Name=Disable Search
Exec=/bin/bash -c "gsettings set com.canonical.Unity.Lenses remote-content-search 'none'"
Type=Application
END

pause '*disable shopping suggestions*'
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

####**Remove Amazon launcher**
`sudo rm -f /usr/share/applications/ubuntu-amazon-default.desktop`

pause '####**Install utilities**'
sudo apt-get -y --ignore-missing install bash-completion curl git lftp tmux wget vim lynx p7zip p7zip-plugins cmake python-dev rsync
sudo apt-get -y --ignore-missing install rar unrar p7zip p7zip-full p7zip-rar

pause '####**Checkout vimrc**'
curl -o - https://raw.githubusercontent.com/chang-jf/vimrc/master/auto-install.sh | sh

pause '####**Install chrome browser**'
sudo apt-get -y install libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

pause '####**Install dropbox**'
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd& >/dev/null 2>&1 

pause '*The meaning of **Optional** is they are optional, only uncomment necessary items'

# laptop-mode-tools's function equal to tlp, chose one, install then forget it.
# use powertop to verify power management tweak result
pause '####**(Optional)Install laptop tools**'
#sudo apt-get -y install laptop-mode-tools
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get -y install tlp tlp-rdw
sudo apt-get -y install powertop

#openshot manual: http://www.openshotusers.com/help/1.3/zh_TW/
#play video : vlc/mplayer
    #vlc :     .wav, .ra, .mpeg, .3gp, .asf, .asx, .m2p
    #mplayer : .divx, .avc
#play audio : audacious/qmmp
#video transcoder : handbrake
#video editor : openshot
#mp3 tag editor : easytag
#subtitle editor : aegisub/SrtEdit(win32)

pause '####**(Optional)Add Extended Multimedia Support**'
sudo apt-get -y install vlc audacious

pause '####**(Optional)Install media codecs and Java sdk in order to decode and support other restricted media formats**'
sudo apt-get -y install ubuntu-restricted-extras openjdk-8-jdk

pause '####**(Optional)Enable DVD playback and other multimedia codecs**'
sudo apt-get -y install ffmpeg gstreamer0.10-plugins-bad lame libavcodec-extra
sudo /usr/share/doc/libdvdread4/install-css.sh
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
sudo apt-get -y isntall comicx

####Reference
#[Ten Things To Do After Installing Ubuntu 15.10]("https://websetnet.com/ten-installing-ubuntu-1510/")
#[15 Things to Do After Installing Ubuntu 15.04 Desktop]("http://www.tecmint.com/things-to-do-after-installing-ubuntu-15-04-desktop/")
#[27 Things to Do After Fresh Installation of Ubuntu 15.10 Desktop]("http://www.tecmint.com/things-to-do-after-fresh-installation-of-ubuntu-15-10-desktop/")
