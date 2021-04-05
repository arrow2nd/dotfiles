#!/bin/zsh

for f (.??*) {
    [[ "$f" == ".git" ]] && continue
    ln -s $HOME/dotfiles/$f $HOME/$f
}

