#!/bin/bash

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
  bat \
  make \
  zsh \
  unzip \
  deno \
  ffmpeg \
  go \
  xsel \
  ripgrep \
  rustup \
  openssh \
  neovim \
  github-cli \
  sheldon \
  fzf \
  eza \
  fd \
  trash-cli \
  bashtop \
  yazi \

go install github.com/x-motemen/ghq@latest
go install github.com/arrow2nd/anct@latest
go install github.com/arrow2nd/nimotsu@latest
go install github.com/arrow2nd/jisyo@latest

echo "[ Switch to zsh ]"
sudo chsh -s $(which zsh) $(whoami)
