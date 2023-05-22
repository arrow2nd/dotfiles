#!/bin/bash
set -eu

if ! type -p brew >/dev/null; then
  echo "[ Install Homebrew ]"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "[ Tools ]"
brew bundle --file=./Brewfile
