#!/bin/bash

install() {
  echo_title "Install $1"

  if type "$1" > /dev/null 2>&1; then
    echo "$1 exist!"
  else
    brew install "$1"
  fi

  echo
}

# Homebrew
echo_title "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo

# vim
install "vim"

# curl
install "curl"

# ngrok
install "ngrok"

# yarn
install "yarn"

# gpg
install "gpg"

# gh
install "gh"
