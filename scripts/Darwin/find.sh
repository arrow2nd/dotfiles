#!/bin/bash

set -eu 

find . -type f \
       -path "*/.*" \
       -not -path "*.git*" \
       -not -path "*.DS_Store" \
       -not -path "*.luarc.json" \
       -not -path "*.local*" \
       -not -path "*wofi*" \
       -not -path "*sway*" \
       -not -path "*waybar*" | \
       cut -c 3-
