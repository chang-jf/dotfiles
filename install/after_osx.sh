#!/bin/bash

# Install Homebrew and brew cask
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew tap caskroom/cask
#brew update && brew upgrade
#brew cleanup; brew cask cleanup

# Install packages

apps=(
    #bash-completion
    #curl
    #git
    #lftp
    tmux
    #wget
    #vim
    #lynx
    #p7zip
    #python
    #homebrew/binary/rar
    #unrar
    reattach-to-user-namespace                               #let tmux support mac's clipboard
    #opencc
    #rsync
    #md5sha1sum
)

brew install "${apps[@]}"

#brew cask install iterm2
#brew cask install google-chrome  
#brew cask install firefox
#brew cask install the-unarchiver   		#decompress tool
#brew cask install dropbox            		#the dropbox
#brew cask install google-drive			#the google drive
#brew cask install alfred               		#quick search apps and run
brew install --cask alfred                      #quick search apps and run
#brew cask install xmind				#mindmapping tool
#brew cask install appcleaner			#help complete remove mac app
#brew cask install picasa			#picture manager
#brew cask install techstoreclub-simple-comic	#comic reader
brew install --cask techstoreclub-simple-comic	#comic reader
#brew cask install edgeview                      #comic reader
#brew cask install vlc                		#video player
#brew cask install filezilla
brew install --cask vlc                		#video player
brew install --cask filezilla
#brew cask install osxfuse                       #add xfs, ntfs, ext2|3|4 support

# Deploy vim rc files
curl -o - https://raw.githubusercontent.com/chang-jf/vimrc/master/auto-install.sh | sh
