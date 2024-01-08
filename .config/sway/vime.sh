#!/bin/bash -e

# Thanks! : https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f

tmp=/tmp/vime
opts=""

# ファイルを作り直して、インサートモードで起動
if [[ "$1" = "--clear" ]]; then
  [[ -f ${tmp} ]] && rm ${tmp}
  touch ${tmp}
  opts="-c start"
fi

wezterm start --class vime nvim -u ~/.config/nvim/init_vime.lua ${opts} ${tmp} || exit 1

# -n は末尾の改行を消すオプション
wl-copy -n "$(cat ${tmp})"

notify-send -t 1500 Copied!
