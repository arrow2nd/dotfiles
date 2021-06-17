#!/bin/bash

install() {
  echo_title "Install $1"

  if type "$1" > /dev/null 2>&1; then
    echo "$1 exist!"
  else
    sudo apt install -y "$1"
  fi

  echo
}

# passwd
read -sp "password : " passwd

# update
echo "$passwd" | sudo -S apt update
echo

# zsh
if [ -z "$ZSH_VERSION" ]; then
  echo_title "Install zsh"
  sudo apt install -y zsh
  chsh -s $(which zsh)
  echo
fi

# vim
install "vim"

# unzip
install "unzip"

# curl
install "curl"

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

# gh
install "gh"
