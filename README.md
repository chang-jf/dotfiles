This repository holds configuration files from my working environment, So I can keep improve and make migration easier.

#Installation

    git clone git://github.com/chang-jf/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    git submodule init ~/.dotfiles/bash/dircolors-solarized
    git submodule update
    ~/.dotfiles/install.sh

#Setup
I made these automatically through ~/.dotfiles/install.sh, If you want to do it manually, this is how.
## Initial submodules
$ git submodule init ~/.dotfiles/bash/dircolors-solarized
$ git submodule update
$ ln -sf ~/.dotfiles/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors

## bash
Separated into few rc files, however, To keep ~/ clean, 
I only want to link standard rcfile back to home, then sourcing from ~/.bashrc

$ ln -sf ~/.dotfiles/bash/bash_profile ~/.bash_profile
$ ln -sf ~/.dotfiles/bash/bashrc ~/.bashrc
$ ln -sf ~/.dotfiles/bash/inputrc ~/.inputrc
$ ln -sf ~/.dotfiles/bash/bin ~/.bin

# lftp rc files
$ ln -sf ~/.dotfiles/lftp/lftprc ~/.lftprc

# -------------------------------------------------------------------
# git config files
# -------------------------------------------------------------------
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig

## Homebrew
On those Mac OS machines where I install Homebrew I also edit `/etc/paths` to move the `/usr/local/bin` entry to the top of the list. This ensures that Homebrew-managed programs and libraries occur prior to `/usr/bin` and system-provided programs and libraries. The resulting `/etc/paths` files looks like this:

    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin

The `~/.dotfiles/brew/Brewfile` acts as a bundle for Homebrew. Use `brew bundle ~/.dotfiles/brew/Brewfile` to set up brews.
    
## ssh
For ssh configuration, create the following symlink:

    ln -s ~/.dotfiles/ssh/config ~/.ssh/config

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


## Git
For Git configuration and global ignore files, create these symlinks:

    $ ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
    $ ln -s ~/.dotfiles/git/gitignore_global ~/.gitignore_global

For machines where Sublime Text 2 cannot be installed, link
`git/gitconfig_remote` instead. This will use `vimdiff` as the merge and diff
tool rather than ST2.

## tmux (terminal multiplexer) configuration
For tmux configuration create this symlink:

    $ ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

Setup `tmuxinator` by installing it's gem

    $ gem install tmuxinator

And link in the directory containing the YML files for the `mux` command.

    $ ln -s ~/.dotfiles/tmux/tmuxinator ~/.tmuxinator

## OpenConnect
An alternative to using Cisco's AnyConnect.

Requires that `openconnect` be installed via Homebrew and that TUN/TAP for OS X be installed. See http://zanshin.net/2013/08/27/setup-openconnect-for-mac-os-x-lion/
for details.

    $ ln -s ~/.dotfiles/openconnect/openconnect ~/.openconnect


# Reference
[Mathiasbynens's dotfile repository](https://github.com/mathiasbynens/dotfiles)
[Zanshin's dotfile repository](https://github.com/zanshin/dotfiles)
[Webpro's dotfile repository](https://github.com/webpro/dotfiles)
[C9s's make file for installation](http://c9s.blogspot.tw/2009/11/git-dotfiles.html)
