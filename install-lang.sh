#!/bin/bash

# asdf plugin
echo "### add asdf plugin (nodejs) ###"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

echo "### add asdf plugin (golang) ###"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

# node.js
echo "### install node.js ###"
asdf install nodejs lts
asdf global nodejs lts

# golang
echo "### install golang ###"
asdf install golang latest
asdf global golang latest

echo "--- finish! ----"
