#!/bin/bash

set -eu

if ! type -p brew >/dev/null; then
  echo "[ Install Homebrew ]"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "[ Tools ]"
curl https://gist.githubusercontent.com/arrow2nd/22e12dad29f29ed308a9acf2e54cfd90/raw/eea4d3d4e1aa04e4de3f989ab12f4836747fe5ff/Brewfile > $HOME/.Brewfile
brew bundle --global
