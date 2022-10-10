#!/bin/bash

cd ~
git clone https://github.com/arrow2nd/dotfiles.git
cd dotfiles

. scripts/common_func.sh

# OS別
[ -f scripts/install_`uname`.sh ] && . scripts/install_`uname`.sh

# create symbolic links
echo_title "Create symbolic links"
stow -v --no-folding  joplin kitty nvim zsh vsvim sheldon nekome

# dein.vim
echo_title "Install dein.vim"
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

source $HOME/.zsh/.zshrc

# plugin nodejs
echo_title "Add nodejs"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# zcompile
zcompile $HOME/.zsh/.zshrc

echo "--- finish! ----"

exec $(which zsh) -l
