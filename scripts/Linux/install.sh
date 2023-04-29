#!/bin/bash

set -eu

echo "[ Tools ]"

# deno
if ! type -p deno >/dev/null; then
  curl -fsSL https://deno.land/x/install/install.sh | sh
fi

# rust
if ! type -p cargo >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# golang
if ! type -p go >/dev/null; then
  sudo add-apt-repository ppa:longsleep/golang-backports
fi

# ngrok
if ! type -p ngrok >/dev/null; then
  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
fi

# gh
if ! type -p gh >/dev/null; then
  type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  export PATH="$HOME/go/bin:$PATH"
fi

sudo apt update

sudo apt install -y \
 zsh \
 ffmpeg \
 golang \
 xsel \
 ngrok \
 ripgrep \
 keychain \
 neovim \
 gh \
 fzf \
 exa \
 fd-find \
 bat \
 trash-cli \
 libssl-dev

# sheldon
cargo install sheldon --locked

# ghq
go install github.com/x-motemen/ghq@latest

echo "[ Switch to zsh ]"
sudo chsh -s $(which zsh) $(whoami)
