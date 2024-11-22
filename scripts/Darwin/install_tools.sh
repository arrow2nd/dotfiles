#!/bin/bash

set -eu

if ! type -p brew >/dev/null; then
  echo "🍺 Install Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! type -p deno >/dev/null; then
  echo "🦕 Install Deno"
  curl -fsSL https://deno.land/install.sh | sh
fi

echo "🧰 Install Tools"
brew bundle --file=~/dotfiles/scripts/Darwin/Brewfile

echo "🔧 Install Language & Toolchain"
export PATH="$HOME/.local/share/mise/shims:$PATH"
mise install -y
