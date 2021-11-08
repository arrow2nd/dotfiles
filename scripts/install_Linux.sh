#!/bin/bash

# apt update
sudo apt update && sudo apt upgrade -y

# zsh
if [ -z "$ZSH_VERSION" ]; then
    echo_title "Install zsh"
    sudo apt install -y zsh
    chsh -s $(which zsh)
fi

# Homebrew
echo_title "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/arrow2nd/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt install build-essential

# clone .Brewfile
git clone git@gist.github.com:7f2a32839bd48084969d48b8aabda0e2.git
mv 7f2a32839bd48084969d48b8aabda0e2/.Brewfile $HOME
rm -r 7f2a32839bd48084969d48b8aabda0e2

# install
brew bundle --global

# ngrok
echo_title "Install ngrok"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin
rm ngrok-stable-linux-amd64.zip
