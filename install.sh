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
echo "install dotfiles into "$DOTFILES_DIR

# -------------------------------------------------------------------
# Update dotfiles itself first
# -------------------------------------------------------------------
echo "# Update dotfiles itself first"
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# -------------------------------------------------------------------
# Then submodules
# -------------------------------------------------------------------
echo "# Then submodules"
pushd $DOTFILES_DIR
git submodule init
git submodule update
popd
ln -sf $DOTFILES_DIR/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors

# -------------------------------------------------------------------
# bash rc files
# -------------------------------------------------------------------
echo "# bash rc files"
ln -sf $DOTFILES_DIR/bash/bash_profile ~/.bash_profile
ln -sf $DOTFILES_DIR/bash/bashrc ~/.bashrc
ln -sf $DOTFILES_DIR/bash/inputrc ~/.inputrc
ln -sf $DOTFILES_DIR/bash/bin ~/.bin

# -------------------------------------------------------------------
# lftp rc files
# -------------------------------------------------------------------
echo "# lftp rc files"
ln -sf $DOTFILES_DIR/lftp/lftprc ~/.lftprc

# -------------------------------------------------------------------
# git config files
# -------------------------------------------------------------------
echo "# gitconfig files"
ln -sf $DOTFILES_DIR/git/gitconfig ~/.gitconfig

# -------------------------------------------------------------------
# ssh config file
# -------------------------------------------------------------------
echo "# ssh config"
[ ! -d ~/.ssh ] && mkdir ~/.ssh
ln -sf $DOTFILES_DIR/ssh/config ~/.ssh/config

# -------------------------------------------------------------------
# tmux rc files
# -------------------------------------------------------------------
echo "# tmux rc files"
ln -sf $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf

# -------------------------------------------------------------------
# wgetrc files
# -------------------------------------------------------------------
echo "# wget rc files"
ln -sf $DOTFILES_DIR/wget/wgetrc ~/.wgetrc

# -------------------------------------------------------------------
# curlrc files
# -------------------------------------------------------------------
echo "# curl rc files"
ln -sf $DOTFILES_DIR/curl/curlrc ~/.curlrc

# -------------------------------------------------------------------
# Everything done, let's get out of there.
# -------------------------------------------------------------------
echo "# Everything done, let's get out of there."
exit
