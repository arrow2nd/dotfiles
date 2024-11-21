#!/bin/bash

# 除外するもの
find . -type f \
       -not -path "*.sh" \
       -not -path "*.md" \
       -not -path "*scripts/*" \
       -not -path "*.git/*" \
       -not -path "*node_modules/*" \
       -not -path "*.DS_Store" \
       -not -path "*.luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*bashtop/*" \
       -not -path "*renovate.json*" \
       | cut -c 3-
