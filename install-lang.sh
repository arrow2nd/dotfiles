#!/bin/bash

. scripts/common_func.sh

# nodejs
echo_title "Add nodejs"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

asdf install nodejs lts
asdf global nodejs lts
echo

# deno
echo_title "Add deno"
asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git

asdf install deno latest
asdf global deno latest
echo

# golang
echo_title "Add golang plugin"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

asdf install golang latest
asdf global golang latest
echo

echo "--- finish! ----"
