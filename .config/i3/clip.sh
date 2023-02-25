#!/bin/bash -u

# Thanks! : https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f

touch /tmp/clip
wezterm start --class Floaterm nvim /tmp/clip || exit 1 # Vimが正しく終了しなかった時はコピーしない

# head -c -1は末尾の改行を削ぎ落とすやつ
head -c -1 /tmp/clip | xclip -selection clipboard
notify-send -t 1000 copied
