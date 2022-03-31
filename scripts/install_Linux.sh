#!/bin/bash

#
# for Arch Linux
#

# yayをインストール
if type "yay" > /dev/null 2>&1; then
  echo "yay is exist!"
else
  echo_title "Install yay"
  git clone https://aur.archlinux.org/yay-bin yay
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# 諸々インストール
echo_title "Install all the usual tools"
yay -S \
 zsh \
 unzip \
 deno \
 ffmpeg \
 gh \
 go \
 goreleaser \
 pastel \
 tree \
 xsel \
 yarn \
 ngrok

# zshに切り替え
echo_title "Switch to zsh"
sudo chsh -s $(which zsh) $(whoami)
