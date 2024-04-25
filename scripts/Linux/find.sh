#!/bin/bash

# 除外するもの
find . -type f \
       -path "*/.*" \
       -not -path "*.git*" \
       -not -path "*node_modules*" \
       -not -path "*.DS_Store" \
       -not -path "*.Brewfile" \
       -not -path "*luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*.yabairc" \
       -not -path "*.skhdrc" \
       -not -path "*Library*" \
       -not -path "*renovate.json*" \
       | cut -c 3-
