# dotfiles
zsh導入済みが前提

## メモ
```
# zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
source ~/.zshrc
zinit self-update

# dotfiles
rm ~/.zshrc
git clone --recursive git@github.com:arrow2nd/dotfiles.git
cd dotfiles
./setup.sh

# anyenv
git clone https://github.com/anyenv/anyenv ~/.anyenv

# anyenv plugin
mkdir -p ~/.anyenv/plugins
git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

~/.anyenv/bin/anyenv init
exec $SHELL -l

# install *env runtime
anyenv install --init
anyenv install nodenv
anyenv install goenv
exec $SHELL -l

# node
nodenv install [version]
nodenv global [version]

# なんかいい感じの方法でyarnを導入する！

# go
goenv install [version]
goenv global [version]

exec $SHELL -l

```
