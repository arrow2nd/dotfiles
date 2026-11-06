# Ghostty起動時にtmuxを自動起動（tmux内での二重起動を防ぐ）
if [[ "$TERM_PROGRAM" == "ghostty" && -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
  exec tmux -f ~/.config/tmux/tmux.conf new-session -A -s nyaan
fi

#
# sheldon
#

eval "$(sheldon source)"

#
# Safe-chain Zsh initialization script
#
[[ -f ~/.safe-chain/scripts/init-posix.sh ]] && source ~/.safe-chain/scripts/init-posix.sh 

#
# プロンプト
#

() {
  local emoji=('🐶' '🌴' '🐙' '🐱' '📦' '🍺' '🥗' '🥙' '🍿' '🥝' '🍤' '🍣' '🍛' '🌵')
  MNML_USER_CHAR=$emoji[($RANDOM % $#emoji + 1)]
}

#
# エイリアス (abbr)
#

# Git
abbrev-alias g='git'
abbrev-alias ga='git add'
abbrev-alias gd='GIT_EXTERNAL_DIFF=difft git diff'
abbrev-alias gs='git status'
abbrev-alias gp='git push'
abbrev-alias gpf='git push --force-with-lease --force-if-includes'
abbrev-alias gpu='git pull'
abbrev-alias gb='git branch'
abbrev-alias gc='git commit'
abbrev-alias gf='git fetch'
abbrev-alias gsw='git switch'
abbrev-alias gwt='git wt'
alias git-remote-http-to-ssh='current_url=$(git remote get-url origin 2>/dev/null) && if [[ "$current_url" =~ ^https://github\.com/ ]]; then git remote set-url origin "$(echo "$current_url" | sed "s|https://github.com/|git@github.com:|")"; else echo "Remote is already SSH or not a GitHub HTTPS URL: $current_url"; fi'

# PRをworktreeでチェックアウト
function checkout-pr() {
  local pr_number="$1"

  if [[ -z "$pr_number" ]]; then
    pr_number=$(gh pr list | fzf | awk '{print $1}')
    if [[ -z "$pr_number" ]]; then
      return 1
    fi
  fi

  local branch=$(gh pr view "$pr_number" --json headRefName -q .headRefName)
  if [[ -z "$branch" ]]; then
    echo "PRの情報を取得できませんでした"
    return 1
  fi

  git fetch origin "pull/${pr_number}/head:${branch}" && git wt "$branch"
}

# worktree・ブランチをマージ状況を確認しながらfzfで選んで削除
function cleanup-branches() {
  # リモートがない・オフラインでもローカルの判定は可能なため処理は継続する
  git fetch --prune || echo "git fetch に失敗しました（ローカルの情報で判定します）"

  # origin/HEADが未設定のリポジトリもあるため、慣例的な名前にフォールバックする
  local main_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
  if [[ -z "$main_branch" ]]; then
    local candidate
    for candidate in main master; do
      if git show-ref --verify --quiet "refs/heads/$candidate"; then
        main_branch="$candidate"
        break
      fi
    done
  fi
  if [[ -z "$main_branch" ]]; then
    echo "メインブランチを特定できませんでした"
    return 1
  fi

  # worktree管理下のブランチは git wt 経由で削除する必要があるため、対応表を作る
  local -A wt_paths
  local wt_path line
  while IFS= read -r line; do
    case "$line" in
      worktree\ *) wt_path="${line#worktree }" ;;
      branch\ *) wt_paths[${${line#branch }#refs/heads/}]="$wt_path" ;;
    esac
  done < <(git worktree list --porcelain)

  # squash mergeされたブランチはgitの履歴だけではマージ済みか判定できないため、PRの状態も表示する
  # ghが使えない場合やGitHub以外のリポジトリでは、PRの状態を表示せずに進める
  local -A pr_states
  local pr_branch pr_state
  if (( $+commands[gh] )); then
    while IFS=$'\t' read -r pr_branch pr_state; do
      # 同じブランチ名のPRが複数ある場合は、新しく作られたものを優先する
      if [[ -z "${pr_states[$pr_branch]}" ]]; then
        pr_states[$pr_branch]="$pr_state"
      fi
    done < <(gh pr list --state all --limit 200 --json headRefName,state -q '.[] | [.headRefName, .state] | @tsv' 2>/dev/null)
  fi

  local current_branch=$(git branch --show-current)
  local -a merged_branches=(${(f)"$(git branch --merged "$main_branch" --format='%(refname:short)')"})
  # 状態はNerd FontsのOcticonsで表示する
  local -A icons=(
    worktree     $'\uf413' # nf-oct-file_directory
    pr_merged    $'\uf419' # nf-oct-git_merge
    pr_closed    $'\uf4dc' # nf-oct-git_pull_request_closed
    pr_open      $'\uf407' # nf-oct-git_pull_request
    in_main      $'\uf42e' # nf-oct-check
    unpushed     $'\uf4ad' # nf-oct-cloud_offline
    remote_gone  $'\uf48e' # nf-oct-trash
    ahead        $'\uf431' # nf-oct-arrow_up
    dirty        $'\uf448' # nf-oct-pencil
  )
  local legend="${icons[pr_merged]} PRマージ済み  ${icons[pr_closed]} PRクローズ  ${icons[pr_open]} PRオープン  ${icons[in_main]} ${main_branch}に取り込み済み
${icons[unpushed]} 未push  ${icons[remote_gone]} リモート削除済み  ${icons[ahead]} 未pushのコミットあり  ${icons[dirty]} 未コミットの変更あり  ${icons[worktree]} worktree"

  local -a candidates labels
  local branch upstream track
  while IFS='|' read -r branch upstream track; do
    # メインブランチと作業中のブランチは削除できないため除外
    if [[ "$branch" == "$main_branch" || "$branch" == "$current_branch" ]]; then
      continue
    fi
    labels=()
    case "${pr_states[$branch]}" in
      MERGED) labels+=("${icons[pr_merged]}") ;;
      CLOSED) labels+=("${icons[pr_closed]}") ;;
      OPEN) labels+=("${icons[pr_open]}") ;;
    esac
    # 作成直後でコミットのないブランチも、メインブランチと同じコミットを指すためここに含まれる
    if (( ${merged_branches[(Ie)$branch]} )); then
      labels+=("${icons[in_main]}")
    fi
    if [[ -z "$upstream" ]]; then
      labels+=("${icons[unpushed]}")
    elif [[ "$track" == "[gone]" ]]; then
      labels+=("${icons[remote_gone]}")
    elif [[ "$track" == *ahead* ]]; then
      labels+=("${icons[ahead]}")
    fi
    # git wt -D は未コミットの変更ごとworktreeを削除するため、変更の有無を示す
    if [[ -n "${wt_paths[$branch]}" && -n "$(git -C "${wt_paths[$branch]}" status --porcelain)" ]]; then
      labels+=("${icons[dirty]}")
    fi
    # fzfには3列目だけを表示し、1列目のブランチ名と2列目のworktreeのパスは削除処理とプレビューで使う
    candidates+=("${branch}"$'\t'"${wt_paths[$branch]}"$'\t'"$(printf '%-1s %-40s %s' "${wt_paths[$branch]:+${icons[worktree]}}" "$branch" "${(j: :)labels}")")
  done < <(git for-each-ref refs/heads --format='%(refname:short)|%(upstream:short)|%(upstream:track)')

  if (( ${#candidates} == 0 )); then
    echo "削除できるブランチはありません"
    return 0
  fi

  local -a selected
  selected=(${(f)"$(printf '%s\n' $candidates | fzf --multi --delimiter=$'\t' --with-nth=3 \
    --header="Tabで複数選択、Enterで決定
${legend}" \
    --preview="git log --oneline --color=always ${main_branch}..{1}; [ -n {2} ] && echo && git -C {2} status --short")"})
  if (( ${#selected} == 0 )); then
    return 1
  fi

  local entry
  echo "以下のブランチを削除します"
  for entry in $selected; do
    echo "  ${entry##*$'\t'}"
  done
  if ! read -q "?削除しますか? [y/N] "; then
    echo "\n中止しました"
    return 1
  fi
  echo

  # -d のマージ判定はHEAD基準のため、別worktreeから実行すると失敗する
  # squash mergeされたブランチも -d では削除できないため、選択したものは -D で削除する
  for entry in $selected; do
    branch="${entry%%$'\t'*}"
    wt_path="${${entry#*$'\t'}%%$'\t'*}"
    if [[ -n "$wt_path" ]]; then
      git wt -D "$branch"
    else
      git branch -D "$branch"
    fi
  done
}

# eza
abbrev-alias l='eza -la'
abbrev-alias la='eza -a'
abbrev-alias lt='eza -T'

# brew
abbrev-alias brewu='brew upgrade && brew autoremove && brew cleanup -s'

# nix
abbrev-alias nixgc='nix-collect-garbage --delete-older-than 7d && sudo nix-collect-garbage --delete-older-than 7d && nix store optimise'

# Neovim
abbrev-alias v="nvim"
abbrev-alias nvim-rebuild='make distclean && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/nvim && make install'

# 雑多
abbrev-alias cls='clear'
abbrev-alias zmv='noglob zmv -W'
abbrev-alias dot='cd ~/dotfiles'

# 天気予報
alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

# op run
opr () {
  if [[ -f "$PWD/.env" ]]; then
      env_file="$PWD/.env"
  elif [[ -f "$PWD/.env.local" ]]; then
      env_file="$PWD/.env.local"
  else
      echo ".envまたは.env.localがありません"
      return 1
  fi

  who=$(op whoami)
  if [[ $? != 0 ]]; then
      eval $(op signin)
  fi

  op run --env-file="$env_file" -- "$@"
}

#
# ZLE
#

# ghq + fzf でリポジトリへ移動
function ghq-fzf() {
  local dir=$(ghq list -p | fzf)

  if [ -n "$dir" ]; then
    BUFFER="cd ${dir}"
    zle accept-line
  fi

  zle clear-screen
}

zle -N ghq-fzf
bindkey "^f" ghq-fzf

# コマンド履歴を検索
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m)
  zle clear-screen
}

zle -N select-history
bindkey "^h" select-history

# ブランチを切り替える
function select-worktree() {
  local dir=$(git-wt | fzf --header-lines=1 | awk '{if ($1 == "*") print $2; else print $1}')
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
  zle clear-screen
}

zle -N select-worktree
bindkey "^b" select-worktree

# カレント行をnvimで編集
function edit_current_line() {
  local tmpfile=$(mktemp)
  echo "$BUFFER" > $tmpfile
  local cmd="normal! $"
  if [ -z "$BUFFER" ]; then
    cmd="startinsert!"
  fi
  nvim $tmpfile -c "${cmd}" -c "set filetype=zsh"
  BUFFER="$(cat $tmpfile)"
  CURSOR=${#BUFFER}
  rm $tmpfile
  zle reset-prompt
}

zle -N edit_current_line
bindkey '^v' edit_current_line

#
# direnv
#

# .envrcのあるリポジトリでflakeのdevShell環境を自動で読み込む
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

#
# ローカル設定
#

[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local

#
# 一般設定
#

# ベル無効
setopt no_beep

# 補完候補を方向キーで選択可能にする
zstyle ':completion:*:default' menu select=2

# 入力ミスを訂正
setopt correct

# 日本語ファイル名に対応
setopt print_eight_bit

# ディレクトリ末尾に/を自動付与
setopt auto_param_slash

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# ファイルの種類を示すマークを表示
setopt list_types

# Tab連打で候補を切り替え
setopt auto_menu

# =以降も補完
setopt magic_equal_subst

# 入力途中でも補完
setopt complete_in_word

# ドット無しで隠しファイルをマッチ
setopt globdots

# 大文字・小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Ctrl+Dでログアウトしない
setopt IGNORE_EOF

# zmv
autoload -Uz zmv

#
# 履歴
#

export HISTFILE=${HOME}/.zhistory
export HISTSIZE=1000
export SAVEHIST=2000

# スペースで始まるコマンドを除外
setopt hist_ignore_space

# 重複するコマンドを除外
setopt hist_ignore_dups

# ヒストリに同じコマンドがあるなら古い方を削除
setopt hist_ignore_all_dups

#
# 自動再コンパイル
#

if [ ~/dotfiles/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

