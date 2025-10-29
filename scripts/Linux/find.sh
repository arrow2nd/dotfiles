#!/bin/bash

# 除外するもの
find . -type f \
       -not -path ".gitignore" \
       -not -path "*.sh" \
       -not -path "*.md" \
       -not -path "*scripts/*" \
       -not -path "*.git/*" \
       -not -path "*node_modules/*" \
       -not -path "*.DS_Store" \
       -not -path "*.Brewfile" \
       -not -path "*luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*Library/*" \
       -not -path "*renovate.json*" \
       | cut -c 3-
