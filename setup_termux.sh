#!/bin/bash

cd ~
git clone https://github.com/arrow2nd/dotfiles.git
cd dotfiles

# 内部ストレージへのアクセスを許可
termux-setup-storage

# パッケージを追加
pkg update
pkg install git neovim wget curl unzip stow zsh ripgrep gh sheldon fzf exa fd deno
apt install -y golang deno

# go install
go install github.com/x-motemen/ghq@latest
go install github.com/arrow2nd/nekome/v2@latest

# symbolic links
stow -v --no-folding nvim zsh sheldon nekome

# dein
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm installer.sh

# フォントを設定
wget https://github.com/yuru7/PlemolJP/releases/download/v1.2.7/PlemolJP_NF_v1.2.7.zip
unzip PlemolJP_NF_*.zip
mv ./PlemolJP_NF_v*/PlemolJPConsole_NF/PlemolJPConsoleNF-Regular.ttf ./.termux/
mv ./.termux/PlemolJPConsoleNF-Regular.ttf ./termux/font.ttf
rm -rf PlemolJP_NF_v1*

