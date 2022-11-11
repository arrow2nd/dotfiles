#!/bin/bash

#
# for macOS
#

set -eu

echo "=== install Homebrew ==="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "=== install all the usual tools ==="
git clone git@gist.github.com:22e12dad29f29ed308a9acf2e54cfd90.git
mv 22e12dad29f29ed308a9acf2e54cfd90/.Brewfile $HOME
rm -r 22e12dad29f29ed308a9acf2e54cfd90
brew bundle --global

echo "=== create symbolic links (macOS only) ==="
stow -v --no-folding yabai kitty
