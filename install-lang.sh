#!/bin/bash

. scripts/common_func.sh

# nodejs
echo_title "Add nodejs"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf install nodejs lts
asdf global nodejs lts

echo "--- finish! ----"

