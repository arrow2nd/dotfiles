#!/bin/bash

# for Ubuntu (GitHub Codespace)

set -eu

echo "🧰 Install Tools"
sudo apt-get update -y

if ! type -p zsh >/dev/null; then
  sudo apt-get install -y zsh
fi

if ! type -p unzip >/dev/null; then
  sudo apt-get install -y unzip
fi

if ! type -p gpg >/dev/null; then
  sudo apt-get install -y gpg
fi

if ! type -p go >/dev/null; then
  sudo apt-get install -y golang-go
fi

if ! type -p deno >/dev/null; then
  echo "🦕 Install Deno"
  curl -fsSL https://deno.land/install.sh | sh
fi

if ! type -p rustup >/dev/null; then
  echo "🦀 Install Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
fi

if ! type -p mise >/dev/null; then
  echo "🍴 Install mise"
  curl https://mise.run | sh
  export PATH="$HOME/.local/share/mise/shims:$PATH"
  mise install -y
fi

if ! type -p sheldon >/dev/null; then
  echo "💻️ Install sheldon"
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

echo "🧰 Install Go CLI tools"
export PATH="$HOME/go/bin:$PATH"
go install github.com/arrow2nd/anct@latest
go install github.com/arrow2nd/jisyo@latest

if ! type -p nvim >/dev/null; then
  echo "✒️ Install Neovim"
  sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential
  ghq get https://github.com/neovim/neovim.git
  cd $HOME/workspace/github.com/neovim/neovim
  make distclean && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/nvim && make install
fi

echo "📚️ Install SKK JISYO"
mkdir $HOME/.skk
jisyo d

echo "🇯🇵 Setup locale"
sudo apt-get install -y locales
sudo locale-gen ja_JP.UTF-8

echo "⚡️ Switch to zsh"
sudo chsh "$(id -un)" --shell $(which zsh)
cd
