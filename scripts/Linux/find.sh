#!/bin/bash

find . -type f \
       -path "*/.*" \
       -not -path "*.git*" \
       -not -path "*.DS_Store" \
       -not -path "*.luarc.json" \
       -not -path "*.yabairc" \
       -not -path "*.skhdrc" | \
       cut -c 3-
