#!/bin/bash

# Homebrew
echo_title "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo

# curl
if type "curl" > /dev/null 2>&1; then
  echo "curl exist!"
else
  echo_title "Install curl"
  brew install curl
fi
echo

# ngrok
echo_title "Install ngrok"
brew install ngrok
echo

# yarn
echo_title "Install yarn"
brew install yarn
echo
