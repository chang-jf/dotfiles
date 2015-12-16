# -------------------------------------------------------------------
# $DOTFILES_DIR/install.sh
#
# This file is executed for initial my dotfiles by softlink them into home directory.
# -------------------------------------------------------------------
#!/usr/bin/env bash
# -------------------------------------------------------------------
# -------------------------------------------------------------------
# Get current dir (so run this script from anywhere)
# -------------------------------------------------------------------
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# -------------------------------------------------------------------
# Update dotfiles itself first
# -------------------------------------------------------------------
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# -------------------------------------------------------------------
# Then submodules
# -------------------------------------------------------------------
#DOTFILES_DIR:/Users/jfc/.dotfiles
git submodule init $DORFILES_DIR/bash/dircolors-solarized
git submodule update
ln -sf $DOTFILES_DIR/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors

# -------------------------------------------------------------------
# bash rc files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/bash/bash_profile ~/.bash_profile
ln -sf $DOTFILES_DIR/bash/bashrc ~/.bashrc
ln -sf $DOTFILES_DIR/bash/inputrc ~/.inputrc
ln -sf $DOTFILES_DIR/bash/bin ~/.bin

# -------------------------------------------------------------------
# lftp rc files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/lftp/lftprc ~/.lftprc

# -------------------------------------------------------------------
# git config files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/git/gitconfig ~/.gitconfig

# -------------------------------------------------------------------
# ssh config file
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/ssh/config ~/.ssh/config

# -------------------------------------------------------------------
# tmux rc files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf

# -------------------------------------------------------------------
# wgetrc files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/wget/wgetrc ~/.wgetrc

# -------------------------------------------------------------------
# curlrc files
# -------------------------------------------------------------------
ln -sf $DOTFILES_DIR/curl/curlrc ~/.curlrc

# -------------------------------------------------------------------
# Everything done, let's get out of there.
# -------------------------------------------------------------------
exit
