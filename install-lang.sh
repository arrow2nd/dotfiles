#!/bin/bash

. scripts/common_func.sh

# asdf plugin
echo_title "Add asdf plugin (nodejs)"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
echo

echo_title "Add asdf plugin (golang)"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
echo

# node.js
echo_title "Install node.js"
asdf install nodejs lts
asdf global nodejs lts
echo

# golang
echo_title "Install golang"
asdf install golang latest
asdf global golang latest
echo

echo "--- finish! ----"
