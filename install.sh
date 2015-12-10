# -------------------------------------------------------------------
# ~/.dotfiles/install.sh
#
# This file is executed for initial my dotfiles by softlink them into home directory.
# -------------------------------------------------------------------
#!/bin/bash
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Install default hand tools
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Initial submodules
# -------------------------------------------------------------------
git submodule init ~/.dotfiles/bash/dircolors-solarized
git submodule update
ln -sf ~/.dotfiles/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors

# -------------------------------------------------------------------
# bash rc files
# -------------------------------------------------------------------
ln -sf ~/.dotfiles/bash/bash_profile ~/.bash_profile
ln -sf ~/.dotfiles/bash/bashrc ~/.bashrc
ln -sf ~/.dotfiles/bash/inputrc ~/.inputrc
ln -sf ~/.dotfiles/bash/bin ~/.bin

# -------------------------------------------------------------------
# lftp rc files
# -------------------------------------------------------------------
ln -sf ~/.dotfiles/lftp/lftprc ~/.lftprc

# -------------------------------------------------------------------
# git config files
# -------------------------------------------------------------------
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig

# -------------------------------------------------------------------
# tmux rc files
# -------------------------------------------------------------------
ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
