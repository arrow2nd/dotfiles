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

# n
curl -L https://bit.ly/n-install | bash

# 諸々インストール
echo_title "Install all the usual tools"
yay -S \
 zsh \
 unzip \
 deno \
 ffmpeg \
 go \
 goreleaser \
 xsel \
 ngrok \
 ripgrep \
 stow \
 rustup \
 openssh \
 wget \
 keychain \
 neovim \
 github-cli \
 ghq \
 sheldon \
 fzf \
 exa \
 fd \
 bat

# zshに切り替え
echo_title "Switch to zsh"
sudo chsh -s $(which zsh) $(whoami)
