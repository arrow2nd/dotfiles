#!/bin/bash

find . -type f \
       -path "*/.*" \
       -not -path "*.git*" \
       -not -path "*.DS_Store" \
       -not -path "*.Brewfile" \
       -not -path "*.luarc.json" \
       -not -path "*stylua.toml" \
       -not -path "*.yabairc" \
       -not -path "*.skhdrc" \
       -not -path "*Library*" \
       | cut -c 3-
