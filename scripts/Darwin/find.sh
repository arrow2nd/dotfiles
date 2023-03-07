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
       -not -path "*waybar*" \
       -not -path "*swaylock*" \
       -not -path "*mako*" | \
       -not -path "*pipewire*" | \
       cut -c 3-
