#!/bin/bash

set -eu

echo "[ Tools ]"
sudo apt install -y \
 zsh \
 deno \
 ffmpeg \
 go \
 goreleaser \
 xsel \
 ngrok \
 ripgrep \
 rustup \
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
