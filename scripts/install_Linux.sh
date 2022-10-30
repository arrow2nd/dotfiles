#!/bin/bash

#
# for Arch Linux
#

set -eu

if ! type -p yay >/dev/null; then
  echo "=== install yay ==="
  git clone https://aur.archlinux.org/yay-bin yay
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

if ! type -p n >/dev/null; then
  echo "=== install n (node version manager) ==="
  curl -L https://bit.ly/n-install | bash -s -- -n latest
fi

echo "=== install all the usual tools ==="
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
 bat \
 trash-cli

echo "=== switch to zsh ==="
sudo chsh -s $(which zsh) $(whoami)
