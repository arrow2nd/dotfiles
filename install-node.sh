#!/bin/bash

. scripts/common_func.sh

# nodejs
asdf install nodejs lts
asdf global nodejs lts

source $HOME/.zshrc

# yarn
echo_title "Add yarn"
npm install -g yarn

# yarnでインストールしてるツール
yarn global add joplin

