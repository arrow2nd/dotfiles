#!/bin/bash

# passwd
read -sp "password : " passwd

# update
echo "$passwd" | sudo -S apt update

# zsh
if [ -z "$ZSH_VERSION" ]; then
  echo "### install zsh ###"
  sudo apt install -y zsh
  chsh -s $(which zsh)
fi

# unzip
if !(type "unzip" > /dev/null 2>&1); then
  echo_title "Install unzip"
  sudo apt install -y unzip
  echo
fi

# curl
if type "curl" > /dev/null 2>&1; then
  echo "curl exist!"
else
  echo_title "Install curl"
  sudo apt install -y curl
fi
echo

# ngrok
echo_title "Install ngrok"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin
rm ngrok-stable-linux-amd64.zip
echo

# yarn
echo_title "Install yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y --no-install-recommends yarn
echo
