#!/bin/bash

. scripts/common_func.sh

# OS別
[ -f scripts/install_`uname`.sh ] && . scripts/install_`uname`.sh

# create symbolic links
echo_title "Create symbolic links"
stow -v --no-folding  joplin kitty nvim twnyan zsh vsvim sheldon

# git config
git config --global core.editor nvim
git config --global url.git@github.com:.insteadOf https://github.com/
git config --global pull.rebase false
git config --global ghq.root '~/workspace'

# gh extention
gh extension install kawarimidoll/gh-q

# dein.vim
echo_title "Install dein.vim"
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

# plugin nodejs
echo_title "Add nodejs"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# zcompile
zcompile $HOME/.zsh/.zshrc

echo "--- finish! ----"

exec $(which zsh) -l
