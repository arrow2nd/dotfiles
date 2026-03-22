#!/bin/bash

# for Arch Linux (Desktop Environment)

set -eu

echo "[ Icon Theme ]"
PIXELITOS_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/ItsZariep/pixelitos-icon-theme.git "$PIXELITOS_DIR"
sudo cp -r "$PIXELITOS_DIR/pixelitos-dark" "$PIXELITOS_DIR/pixelitos-light" /usr/share/icons/
rm -rf "$PIXELITOS_DIR"
gtk-update-icon-cache /usr/share/icons/pixelitos-dark 2>/dev/null || true
gtk-update-icon-cache /usr/share/icons/pixelitos-light 2>/dev/null || true

echo "[ Desktop ]"
sudo pacman -S --noconfirm \
  waybar \
  mako \
  wob \
  ghostty \
  swaybg \
  swayidle \
  gtklock \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-gnome \
  gnome-keyring \
  xwayland-satellite \
  udiskie \
  polkit-gnome \
  brightnessctl \
  wl-clipboard

yay -S \
  niri \
  ly \
  vicinae-bin

echo "[ IME ]"
sudo pacman -S --noconfirm \
    fcitx5-skk\
    fcitx5-configtool

yay -S yaskkserv2-bin

echo "[ systemctl ]"
sudo systemctl enable ly.service
