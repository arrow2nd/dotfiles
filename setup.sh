#!/bin/zsh

for f (.??*) {
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    
    ln -s $HOME/dotfiles/$f $HOME/$f
}

