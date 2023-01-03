#!/bin/bash

#
# for macOS
#

set -eu

if ! type -p brew >/dev/null; then
  echo "[ Install Homebrew ]"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "[ Tools ]"
git clone git@gist.github.com:22e12dad29f29ed308a9acf2e54cfd90.git
mv 22e12dad29f29ed308a9acf2e54cfd90/.Brewfile $HOME
rm -r 22e12dad29f29ed308a9acf2e54cfd90
brew bundle --global
