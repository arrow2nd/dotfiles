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

echo "🦇 Install bat"
if ! type -p bat >/dev/null; then
  curl -L https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb -o bat.deb
  sudo dpkg -i bat.deb
  rm bat.deb
fi

echo "🔍 Install difftastic"
if ! type -p difft >/dev/null; then
  curl -L https://github.com/Wilfred/difftastic/releases/latest/download/difft-x86_64-unknown-linux-gnu.tar.gz | tar xz
  sudo mv difft /usr/local/bin/
fi

echo "🔎 Install fzf"
if ! type -p fzf >/dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-bash --no-fish
fi

echo "📦 Install ghq"
if ! type -p ghq >/dev/null; then
  go install github.com/x-motemen/ghq@latest
fi

echo "🔍 Install fd"
if ! type -p fd >/dev/null; then
  curl -L https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb -o fd.deb
  sudo dpkg -i fd.deb
  rm fd.deb
fi

echo "⚡ Install ripgrep"
if ! type -p rg >/dev/null; then
  curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb -o ripgrep.deb
  sudo dpkg -i ripgrep.deb
  rm ripgrep.deb
fi

echo "📂 Install eza"
if ! type -p eza >/dev/null; then
  sudo apt-get install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo apt-get install -y eza
fi

echo "🎨 Install stylua"
if ! type -p stylua >/dev/null; then
  cargo install stylua
fi

echo "📁 Install yazi"
if ! type -p yazi >/dev/null; then
  cargo install --locked yazi-fm yazi-cli
fi

echo "🔧 Install efm-langserver"
if ! type -p efm-langserver >/dev/null; then
  go install github.com/mattn/efm-langserver@latest
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
