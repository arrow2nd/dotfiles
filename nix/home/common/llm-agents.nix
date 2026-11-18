{ pkgs, inputs, lib, config, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  claudeRepo = "${config.home.homeDirectory}/dotfiles/.claude";
  claudeHome = "${config.home.homeDirectory}/.claude";
  linkRepo = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${claudeRepo}/${path}";
  };

  codexBin = "${llm.codex}/bin/codex";
  codex = pkgs.writeShellScriptBin "codex" ''
    exec ${codexBin} \
      --config 'tui.status_line=["context-used","five-hour-limit","weekly-limit"]' \
      --config 'tui.status_line_use_colors=false' \
      "$@"
  '';

  # settings.json は Claude Code 自身が書き換えるので、symlink ではなくコピーを初期値として置く
  syncSettings = ''
    run install -D -m 644 \
      ${claudeRepo}/settings.json \
      ${claudeHome}/settings.json
  '';

  # ディレクトリごと symlink すると終わるのでディレクトリを切ってファイルのリンクを貼る
  syncStaticDirs = ''
    for subdir in agents commands hooks output-styles rules skills; do
      dst_dir="${claudeHome}/$subdir"
      run mkdir -p "$dst_dir"
      # リポジトリから消えた項目のリンク切れを掃除
      run find "$dst_dir" -maxdepth 1 -type l ! -exec test -e {} \; -delete
      for src in "${claudeRepo}/$subdir"/*; do
        [ -e "$src" ] || continue
        dst="$dst_dir/$(basename "$src")"
        # 実ディレクトリが残っていると ln -sfn がその中にリンクを作ってしまうので飛ばす
        if [ -d "$dst" ] && [ ! -L "$dst" ]; then
          echo "warning: $dst is a real directory, skipping" >&2
          continue
        fi
        run ln -sfn "$src" "$dst"
      done
    done
  '';

  syncCodexSkills = ''
    run mkdir -p "${config.home.homeDirectory}/.agents/skills"
    run find "${config.home.homeDirectory}/.agents/skills" -maxdepth 1 -type l ! -exec test -e {} \; -delete
    for src in "${claudeRepo}/skills"/*; do
      [ -e "$src" ] || continue
      run ln -sfn "$src" "${config.home.homeDirectory}/.agents/skills/$(basename "$src")"
    done
  '';
in
{
  home.packages = [
    llm.claude-code
    codex
    llm.agent-browser
    llm.antigravity-cli
    llm.orca
    pkgs.sox # Claude Code のマイク用
  ];

  # 静的設定は直接 symlink
  home.file = {
    ".claude/CLAUDE.md" = linkRepo "CLAUDE.md";
    ".claude/statusline-command" = linkRepo "statusline-command";
    ".codex/AGENTS.md" = linkRepo "CLAUDE.md";
  };

  home.activation = {
    claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] syncSettings;
    claudeStaticDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] syncStaticDirs;
    codexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] syncCodexSkills;
  };
}
