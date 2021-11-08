#!/bin/bash

# Homebrew
echo_title "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# clone .Brewfile
git clone git@gist.github.com:22e12dad29f29ed308a9acf2e54cfd90.git
mv 22e12dad29f29ed308a9acf2e54cfd90/.Brewfile $HOME
rm -r 22e12dad29f29ed308a9acf2e54cfd90

# install
brew bundle --global
