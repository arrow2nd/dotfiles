#!/bin/bash

# passwd
read -sp "password : " passwd

# zsh
if [ -z "$ZSH_VERSION" ]; then
  echo "### zsh ###"
  echo "$passwd" | sudo -S apt install zsh
  chsh -s $(which zsh)
fi

# zinit
echo "### zinit ###"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source $HOME/.zshrc
zinit self-update

# asdf
echo "### asdf ###"
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf

# yarn
echo "### yarn ###"
echo "$passwd" | sudo -S apt install --no-install-recommends yarn

# unzip
if !(type "unzip" > /dev/null 2>&1); then
  echo "### unzip ###"
  sudo apt install unzip
fi

# ngrok
echo "### ngrok ###"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin/ngrok/
rm ngrok-stable-linux-amd64.zip
rm -rf ngrok-stable-linux-amd64

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
echo "### asdf plugin (nodejs) ###"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

echo "### asdf plugin (golang) ###"
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

echo "### finish! ###"
exec $SHELL -l
