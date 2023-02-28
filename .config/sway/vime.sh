#!/bin/bash -u

# Thanks! : https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f

tmp=/tmp/vime
[[ -f ${tmp} ]] && rm ${tmp}
touch ${tmp}

wezterm start --class vime nvim -c start ${tmp} || exit 1
head -c -1 ${tmp} | wl-copy

notify-send -t 1000 Copied!
