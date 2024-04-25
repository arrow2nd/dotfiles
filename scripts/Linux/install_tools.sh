#!/bin/bash

# for Ubuntu (GitHub Codespace)

set -eu

source $HOME/.zshenv

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
  curl -fsSL https://deno.land/x/install/install.sh | sh
fi

if ! type -p rustup >/dev/null; then
  echo "🦀 Install Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
fi

if ! type -p mise >/dev/null; then
  echo "🍴 Install mise"
  curl https://mise.run | sh
fi

if ! type -p aqua >/dev/null; then
  echo "💧 Install aqua"
  curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.0/aqua-installer | bash
  aqua i -a
fi

if ! type -p sheldon >/dev/null; then
  echo "💻️ Install sheldon"
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

echo "🧰 Install Go CLI tools"
go install github.com/arrow2nd/anct@latest
go install github.com/arrow2nd/jisyo@latest

echo "📚️ Install SKK JISYO"
mkdir $HOME/.skk
jisyo d

echo "⚡️ Switch to zsh"
sudo chsh "$(id -un)" --shell $(which zsh)
exec -l $SHELL
