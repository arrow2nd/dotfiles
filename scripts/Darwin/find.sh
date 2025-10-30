#!/bin/bash

set -eu

find . -type f \
       -not -path ".gitignore" \
       -not -path "*.sh" \
       -not -path "*.md" \
       -not -path "*scripts/*" \
       -not -path "*.git/*" \
       -not -path "*node_modules/*" \
       -not -path "*.DS_Store" \
       -not -path "*bashtop/*" \
       -not -path "*fontconfig/*" \
       -not -path "*gtklock/*" \
       -not -path "*mako/*" \
       -not -path "*niri/*" \
       -not -path "*waybar/*" \
       -not -path "*.local/bin/execlock*" \
       -not -path "*.luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*renovate.json*" \
       | cut -c 3-
