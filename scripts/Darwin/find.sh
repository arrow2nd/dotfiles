#!/bin/bash

# 除外するもの
find . -type f \
       -not -path "*.sh" \
       -not -path "*README.md" \
       -not -path "*scripts/*" \
       -not -path "*.git/*" \
       -not -path "*node_modules/*" \
       -not -path "*.DS_Store" \
       -not -path "*.luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*bashtop/*" \
       -not -path "*renovate.json*" \
       -not -path "*.claude/settings.local.json" \
       | cut -c 3-
