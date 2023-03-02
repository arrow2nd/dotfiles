#!/bin/bash -u

# Thanks! : https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f

tmp=/tmp/vime
[[ -f ${tmp} ]] && rm ${tmp}
touch ${tmp}

wezterm start --class vime nvim -u ~/.config/nvim/init_vime.lua -c start ${tmp} || exit 1
wl-copy $(head -c -1 ${tmp})

notify-send -t 1500 Copied!
