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
# Then update submodules
# -------------------------------------------------------------------
echo "# Then submodules"
pushd $DOTFILES_DIR
git submodule init
git submodule update
popd
ln -sf $DOTFILES_DIR/bash/dircolors-solarized/dircolors.256dark ~/.dir_colors

# -------------------------------------------------------------------
# Soft-link rc files into home
# -------------------------------------------------------------------
echo "# soft-link bash rc files"
ln -sf $DOTFILES_DIR/bash/bash_profile ~/.bash_profile
ln -sf $DOTFILES_DIR/bash/bashrc ~/.bashrc
ln -sf $DOTFILES_DIR/bash/inputrc ~/.inputrc
rm -f ~/.bin
ln -sf $DOTFILES_DIR/bash/bin ~/.bin
echo "# soft-link lftp rc files"
ln -sf $DOTFILES_DIR/lftp/lftprc ~/.lftprc
echo "# soft-link gitconfig files"
ln -sf $DOTFILES_DIR/git/gitconfig ~/.gitconfig
echo "# soft-link ssh config"
[ ! -d ~/.ssh ] && mkdir ~/.ssh
ln -sf $DOTFILES_DIR/ssh/config ~/.ssh/config
echo "# soft-link tmux rc files"
ln -sf $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf
echo "# soft-link wget rc files"
ln -sf $DOTFILES_DIR/wget/wgetrc ~/.wgetrc
echo "# soft-link curl rc files"
ln -sf $DOTFILES_DIR/curl/curlrc ~/.curlrc

# -------------------------------------------------------------------
# Install command line tools
# -------------------------------------------------------------------
# With homebrew(MAC)
if [ "$(uname)" == "Darwin" ]; then
    . "$DOTFILES_DIR/install/brew.sh"
    . "$DOTFILES_DIR/install/brew-cask.sh"
    . "$DOTFILES_DIR/install/bash.sh"
    . "$DOTFILES_DIR/install/osx.sh"
else
    . "$DOTFILES_DIR/install/osx.sh"
# Using apt
# Using yum
# Using pacman
# Using emerge
fi

# -------------------------------------------------------------------
# Everything done, let's get out of there.
# -------------------------------------------------------------------
echo "# Everything done, let's get out of there."
exit
