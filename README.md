This repository holds configuration files from my working environment, So I can keep improve and make migration easier.

#Installation
```
git clone git://github.com/chang-jf/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

# Setup
I made these automatically through ~/.dotfiles/install.sh, If you want to do it manually, this is how.

## Initial submodules
```
pushd ~/.dotfiles
git submodule init
git submodule update  
popd
ln -sf ~/.dotfiles/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors  
```

## bash
Separated into few rc files, however, To keep ~/ clean,  
I only want to link standard rcfile back to home, then sourcing from ~/.bashrc

```
ln -sf ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -sf ~/.dotfiles/bash/bashrc ~/.bashrc
ln -sf ~/.dotfiles/bash/inputrc ~/.inputrc
ln -sf ~/.dotfiles/bash/bin ~/.bin
```

## lftp rc files
```
ln -sf ~/.dotfiles/lftp/lftprc ~/.lftprc
```

## git config files
```
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig
```

## ssh
```
[ ! -d ~/.ssh ] && mkdir ~/.ssh
ln -s ~/.dotfiles/ssh/config ~/.ssh/config
```

## tmux (terminal multiplexer) configuration
```
ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
```

## wget
```
ln -sf ~/.dotfiles/wget/wgetrc ~/.wgetrc
```

## curl
ln -sf ~/.dotfiles/curl/curlrc ~/.curlrc


--------------------------------------------------------------    
## Homebrew
On those Mac OS machines where I install Homebrew I also edit `/etc/paths` to move the `/usr/local/bin` entry to the top of the list. This ensures that Homebrew-managed programs and libraries occur prior to `/usr/bin` and system-provided programs and libraries. The resulting `/etc/paths` files looks like this:

    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin

The `~/.dotfiles/brew/Brewfile` acts as a bundle for Homebrew. Use `brew bundle ~/.dotfiles/brew/Brewfile` to set up brews.
    
## Vim
For Vim configuration and use, create the following symlinks:

    ln -s ~/.dotfiles/vim ~/.vim
    ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
    ln -s ~/.dotfiles/vim/vimrc.bundles ~/.vimrc.bundles
    ln -s ~/.dotfiles/vim/gvimrc ~/.gvimrc

To install Vim bundles, which are managed via Vundle, via the command line run

    vim +PluginInstall +qall

From inside of Vim run

    :PluginInstall

If this is the first time setting up Vim on the machine, it will be necessary to install Vundle itself, prior to teh bundles.

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

All Bundles and their associated configurations are kept in `vimrc.bundles`. This file is sourced inside `vimrc` only if found. This allows a minified version of my Vim configuration to be installed on remote servers, without having to install all the bundles I normally have. 

The `YouCompleteMe` bundle requires an additional compile step. Go read teh "Installation" section on http://valloric.github.io/YouCompleteMe/. Short version is:

    $ brew list # if cmake isn't there, brew install cmake
    $ cd ~/.vim/bundle/YouCompleteMe
    $ ./install.sh --clang-completer

# Reference
[Mathiasbynens's dotfile repository](https://github.com/mathiasbynens/dotfiles)  
[Zanshin's dotfile repository](https://github.com/zanshin/dotfiles)  
[Webpro's dotfile repository](https://github.com/webpro/dotfiles)  
[C9s's make file for installation](http://c9s.blogspot.tw/2009/11/git-dotfiles.html)  
