#!/bin/bash

. scripts/common_func.sh

# OS別
[ -f scripts/install_`uname`.sh ] && . scripts/install_`uname`.sh

# symbolic link
echo_title "Create symbolic links"
for f in .??*; do
  [[ "$f" =~ ^\.git.*$ ]] && continue
  ln -sf $HOME/dotfiles/$f $HOME/$f
done

# zinit
echo_title "Install zinit"
sh -c "$(curl -fsSL https://git.io/zinit-install)"
source $HOME/.zshrc
zinit self-update

# zcompile
zcompile $HOME/.zshrc

echo "--- finish! ----"

exec $(which zsh) -l
