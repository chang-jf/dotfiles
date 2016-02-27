#!/bin/bash
function pause(){
#read -p "$*"
echo "$*"
}

pause '####**Update repository, also enable epel repository**'
sudo yum -y update

##enable epel/repo_forge repository for additional packages
##use yum-protectbase for preventing base and update repository get corrupted by these new repository
##ref: https://wiki.centos.org/zh-tw/PackageManagement/Yum/ProtectBase
##1. check /etc/yum/pluginconf.d/protectbase.conf, set enable = 1;
##2. manually add `protect=1` or `protect=0` to every repo section in /etc/yum.repos.d/*.repo, set `protect=1` for [base] and [update] repository
##(Note: You **MUST** add `protect=0` for every repository that you don't want it to be protect, otherwise the default is `protect=1`)
#sudo yum -y install epel-release
#sudo yum -y localinstall http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#sudo yum -y install yum-protectbase
#pause '**Now you need do verify and setting work for yum-protectbase able to work, see after_centos.sh for detail instruction**'
#sudo yum -y update

pause '####**Install utilities**'
#yum-axelget accelerates download rate with multi-threads by axel, install it before other utils
#rar and unrar in repo_forge repository, need enable repo_forge repository before you an install them.
sudo yum -y install yum-axelget
sudo yum -y install bash-completion curl git lftp tmux wget vim lynx p7zip p7zip-plugins rsync

pause '####**Checkout vimrc files**'
#deploy vim rc-file and plugins(these development tools is for YouCompleteMe installation, if you don't use ycm, you can skip next line)
sudo yum -y install automake gcc gcc-c++ kernel-devel cmake python-devel
curl -o - https://raw.githubusercontent.com/chang-jf/vimrc/master/auto-install.sh | sh
