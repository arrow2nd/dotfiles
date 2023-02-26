#!/bin/bash

#
# for Arch Linux
#

set -eu

YAY_DIR="$HOME/yay"

if ! type -p yay >/dev/null; then
  echo "[ yay ]"
  git clone https://aur.archlinux.org/yay-bin "$YAY_DIR"
  cd "$YAY_DIR"
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

echo "[ Tools ]"
yay -S --noconfirm \
 base-devel \
 zsh \
 unzip \
 deno \
 ffmpeg \
 go \
 goreleaser \
 xsel \
 ngrok \
 ripgrep \
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
 bat \
 trash-cli

echo "[ Switch to zsh ]"
sudo chsh -s $(which zsh) $(whoami)
