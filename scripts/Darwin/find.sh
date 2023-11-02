#!/bin/bash

set -eu 

find . -type f \
       -path "*/*" \
       -not -path "*.sh" \
       -not -path "*.md" \
       -not -path "*scripts*" \
       -not -path "*.git*" \
       -not -path "*.DS_Store" \
       -not -path "*luarc.json" \
       -not -path "*bashtop*" \
       -not -path "*stylua.toml" \
       | cut -c 3-
