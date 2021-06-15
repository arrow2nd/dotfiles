#!/bin/bash

. scripts/common_func.sh

# OS別
[ -f scripts/install_`uname`.sh ] && . scripts/install_`uname`.sh

# zinit
echo_title "Install zinit"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source $HOME/.zshrc
zinit self-update
echo

# asdf
echo_title "Install asdf"
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
echo

# symbolic link
echo_title "Create symbolic links"
for f in .??*; do
  [[ "$f" == ".git" ]] && continue
  ln -sf $HOME/dotfiles/$f $HOME/$f
done
echo

# zcompile
zcompile $HOME/.zshrc

echo "--- finish! ----"

exec $(which zsh) -l
