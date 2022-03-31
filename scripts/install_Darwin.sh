#!/bin/bash

#
# for macOS
#

# Homebrewをインストール
echo_title "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Gistにある.Brewfileをclone
echo_title "Clone .BrewFile"
git clone git@gist.github.com:22e12dad29f29ed308a9acf2e54cfd90.git
mv 22e12dad29f29ed308a9acf2e54cfd90/.Brewfile $HOME
rm -r 22e12dad29f29ed308a9acf2e54cfd90

# 全部インストール
echo_title "Install all the usual tools"
brew bundle --global
