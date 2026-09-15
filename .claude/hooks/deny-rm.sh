#!/usr/bin/env bash
# rm を止めて trash に誘導する。誤削除時に復元できるようにするため
# ponytail: コマンド位置の rm だけ見る。find -exec や文字列内の rm は素通り
cmd=$(jq -r '.tool_input.command // empty')
if grep -Eq '(^|[;&|(`]|sudo|xargs( -[[:alnum:]]+)*)[[:space:]]*(/bin/|/usr/bin/)?rm([[:space:]]|$)' <<<"$cmd"; then
  echo "rm は使わず trash を使う（誤削除時に復元可能にするため）" >&2
  exit 2
fi
