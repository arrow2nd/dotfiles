#!/bin/bash

set -eu 

echo "=== clone repo ==="
cd ~
git clone https://github.com/arrow2nd/dotfiles.git
cd dotfiles

echo "=== install apps ==="
[[ -f scripts/install_`uname`.sh ]] && . ./scripts/install_`uname`.sh

echo "=== create symbolic links ==="
stow -v --no-folding joplin kitty nvim zsh vsvim sheldon nekome

echo "=== install dein ==="
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

echo "=== setup git ==="
read -p "run? (Y/n)" yn
case "$yn" in [nN]*) ;; *) . ./scripts/setup_git.sh ;; esac

echo "=== setup GitHub CLI ==="
read -p "run? (Y/n)" yn
case "$yn" in [nN]*) ;; *) . ./scripts/setup_gh.sh ;; esac

source $HOME/.zsh/.zshrc
zcompile $HOME/.zsh/.zshrc

echo "=== finish! ==="
exec $(which zsh) -l
