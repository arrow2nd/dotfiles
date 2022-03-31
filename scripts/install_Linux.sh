#!/bin/bash

#
# for Arch Linux
#

# 諸々インストール
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
sudo chsh -s $(which zsh) $(whoami)
