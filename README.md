# dotfiles
ubuntu前提

## メモ
```
# zsh, git
sudo apt update && sudo apt upgrade
sudo apt install zsh git
chsh -s $(which zsh)

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt install --no-install-recommends yarn

# zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source ~/.zshrc
zinit self-update

# dotfiles
rm ~/.zshrc
git clone --recursive git@github.com:arrow2nd/dotfiles.git
cd dotfiles
./setup.sh
cd ~
zcompile ~/.zshrc

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
exec $SHELL -l

# node.js
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs [version]
asdf global nodejs [version]

# go
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang [version]
asdf global golang [version]

exec $SHELL -l

```
