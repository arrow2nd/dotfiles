#!/bin/bash

. scripts/common_func.sh

# OS別
[ -f scripts/install_`uname`.sh ] && . scripts/install_`uname`.sh

# create symbolic links
echo_title "Create symbolic links"
stow -v joplin kitty nvim twnyan zsh

# zinit
echo_title "Install zinit"
sh -c "$(curl -fsSL https://git.io/zinit-install)"
source $HOME/.zshrc
zinit self-update

# asdf
echo_title "Install asdf"
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.9.0

# dein.vim
echo_title "Install dein.vim"
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

# zcompile
zcompile $HOME/.zshrc

echo "--- finish! ----"

exec $(which zsh) -l
