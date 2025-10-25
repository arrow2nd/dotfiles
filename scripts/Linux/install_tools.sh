#!/bin/bash

# for Arch Linux

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
  make \
  zsh \
  unzip \
  deno \
  go \
  ripgrep \
  openssh \
  github-cli \
  ghq \
  mise \
  sheldon \
  fzf \
  eza \
  fd \
  bat \
  trash-cli \
  bashtop \
  yazi \
  difftastic \
  stylua \
  efm-langserver

echo "[ Go CLI tools ]"
export PATH="$HOME/go/bin:$PATH"
go install github.com/arrow2nd/anct@latest
go install github.com/arrow2nd/jisyo@latest

echo "[ SKK JISYO ]"
mkdir -p $HOME/.skk
jisyo d

echo "[ Switch to zsh ]"
sudo chsh -s $(which zsh) $(whoami)
cd
