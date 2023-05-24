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
 base-devel \
 zsh \
 unzip \
 deno \
 ffmpeg \
 go \
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
 trash-cli \
 ly \
 mako \
 wob \
 pamixer \
 brightnessctl \
 bashtop \
 wezterm \
 vivaldi \ 
 kvantum-theme-nordic \
 nordic-bluish-accent-theme \
 nordzy-icon-theme

pacman -S sway xorg-xwayland qt5-wayland swayidle waybar swaybg swaylock-effects noto-fonts

echo "[ Switch to zsh ]"
sudo chsh -s $(which zsh) $(whoami)
