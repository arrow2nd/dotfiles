#!/bin/bash

install() {
    echo_title "Install $1"

    if type "$1" > /dev/null 2>&1; then
        echo "$1 is exist"
    else
        sudo apt install -y "$1"
    fi
}

# update
sudo apt update && sudo apt upgrade -y

# zsh
if [ -z "$ZSH_VERSION" ]; then
    echo_title "Install zsh"
    sudo apt install -y zsh
    chsh -s $(which zsh)
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

# gh
echo_title "Install GitHub CLI"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
