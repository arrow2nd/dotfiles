#!/bin/bash

set -eu 

echo "=== clone repo ==="
cd ~
git clone https://github.com/arrow2nd/dotfiles.git
cd dotfiles

[[ -f scripts/install_`uname`.sh ]] && . ./scripts/install_`uname`.sh

echo "=== create symbolic links ==="
stow -v --no-folding joplin vim nvim zsh vsvim sheldon nekome wezterm

echo "=== install dein ==="
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

read -p "=== setup Git? (Y/n) ===" yn
case "$yn" in [nN]*) ;; *) . ./scripts/setup_git.sh ;; esac

read -p "=== setup GitHub CLI? (Y/n) ===" yn
case "$yn" in [nN]*) ;; *) . ./scripts/setup_gh.sh ;; esac

source $HOME/.zsh/.zshrc
zcompile $HOME/.zsh/.zshrc

echo "=== finish! ==="
exec $(which zsh) -l
