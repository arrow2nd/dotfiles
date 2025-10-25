#!/bin/bash

set -eu

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
       -not -path "*fontconfig*" \
       -not -path "*niri*" \
       -not -path "*sway*" \
       -not -path "*waybar*" \
       -not -path "*swaylock*" \
       -not -path "*mako*" \
       -not -path "*bashtop/*" \
       -not -path "*renovate.json*" \
       -not -path "*.claude/settings.local.json" \
       | cut -c 3-
