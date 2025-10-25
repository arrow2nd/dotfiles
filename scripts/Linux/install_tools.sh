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
  unzip \
  make \
  cmake \
  ninja \
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

echo "[ Fonts ]"
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

mkdir tmp
cd tmp
curl -sL -o plemoljp.zip https://github.com/yuru7/PlemolJP/releases/download/v3.0.0/PlemolJP_NF_v3.0.0.zip
unzip plemoljp.zip
sudo cp -r ./PlemolJP_NF_v3.0.0 /usr/share/fonts/
curl -sL -o bizter.zip https://github.com/yuru7/BIZTER/releases/download/v0.0.2/BIZTER_v0.0.2.zip
unzip bizter.zip
sudo cp -r ./BIZTER_v0.0.2 /usr/share/fonts/
cd ../
rm -rf tmp

echo "[ Apps ]"
yay -S --noconfirm \
  ufw \
  zen-browser-bin \
  pamac-aur \
  1password \
  1password-cli

echo "[ ufw ]"
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "[ Desktop ]"
sudo pacman -S --noconfirm \
  waybar \
  mako \
  wob \
  ghostty \
  swaybg \
  swayidle \
  swaylock \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-gnome \
  gnome-keyring \
  xwayland-satellite \
  udiskie \
  polkit-gnome

yay -S niri ly vicinae-bin

echo "[ systemctl ]"
sudo systemctl enable ly.service

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
