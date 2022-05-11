#!/bin/bash

. scripts/common_func.sh

# nodejs
echo_title "Install Node.js"
asdf install nodejs lts
asdf global nodejs lts

source $HOME/.zsh/.zshrc

# yarn
echo_title "Install yarn"
npm install -g yarn

# yarnでインストールしてるツール
echo_title "Install Global Tools"
yarn global add joplin

