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

# zinit
echo "### install zinit ###"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source $HOME/.zshrc
zinit self-update

# asdf
echo "### install asdf ###"
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf

# curl
if !(type "curl" > /dev/null 2>&1); then
  echo "### install curl ###"
  sudo apt install -y curl
fi

# yarn
echo "### install yarn ###"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install -y --no-install-recommends yarn

# unzip
if !(type "unzip" > /dev/null 2>&1); then
  echo "### install unzip ###"
  sudo apt install -y unzip
fi

# ngrok
echo "### install ngrok ###"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin/ngrok/
rm ngrok-stable-linux-amd64.zip ngrok

# link
echo "### create symbolic link ###"
for f in .??*; do
  [[ "$f" == ".git" ]] && continue
  ln -sf $HOME/dotfiles/$f $HOME/$f
done

# zcompile
zcompile $HOME/.zshrc

source $HOME/.zshrc

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

exec $(which zsh) -l
