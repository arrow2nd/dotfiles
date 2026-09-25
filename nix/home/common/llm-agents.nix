{ pkgs, inputs, lib, config, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  claudeRepo = "${config.home.homeDirectory}/dotfiles/.claude";
  claudeHome = "${config.home.homeDirectory}/.claude";
  linkRepo = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${claudeRepo}/${path}";
  };

  mcpServers = {
    vv-mcp = {
      command = "npx";
      args = [ "-y" "@arrow2nd/vv-mcp" ];
      env = {
        VOICEVOX_URL = "http://localhost:50021";
        DEFAULT_VOICE_ID = "47";
        DEFAULT_SPEED = "1.0";
      };
    };
  };

  claudeBin = "${llm.claude-code}/bin/claude";
  codexBin = "${llm.codex}/bin/codex";
  codex = pkgs.writeShellScriptBin "codex" ''
    exec ${codexBin} \
      --config 'tui.status_line=["context-used","five-hour-limit","weekly-limit"]' \
      --config 'tui.status_line_use_colors=false' \
      "$@"
  '';

  # ~/.claude.json は Claude Code 自身が書き換えるので初期値として CLI 経由で user スコープで登録
  syncClaudeMcpServers = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: cfg: ''
      run ${claudeBin} mcp remove ${lib.escapeShellArg name} -s user >/dev/null 2>&1 || true
      run ${claudeBin} mcp add-json -s user ${lib.escapeShellArg name} ${lib.escapeShellArg (builtins.toJSON cfg)}
    '') mcpServers
  );

  syncCodexMcpServers = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: cfg: let
      envArgs = lib.mapAttrsToList (key: value: "--env ${lib.escapeShellArg "${key}=${value}"}") cfg.env
        # Linux で PulseAudio / PipeWire のソケットを見つけるために渡す。Mac には無い変数なので Linux 限定
        ++ lib.optionals pkgs.stdenv.isLinux [ ''--env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR"'' ];
      command = lib.escapeShellArgs ([ cfg.command ] ++ cfg.args);
    in ''
      run ${codexBin} mcp remove ${lib.escapeShellArg name} >/dev/null 2>&1 || true
      run ${codexBin} mcp add ${lib.escapeShellArg name} ${lib.concatStringsSep " " envArgs} -- ${command}
    '') mcpServers
  );

  # これも同じく
  syncSettings = ''
    run install -D -m 644 \
      ${claudeRepo}/settings.json \
      ${claudeHome}/settings.json
  '';

  # ディレクトリごと symlink すると終わるのでディレクトリを切ってファイルのリンクを貼る
  syncStaticDirs = ''
    for subdir in agents commands hooks skills; do
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
    pkgs.sox
  ];

  # 静的設定は直接 symlink
  home.file = {
    ".claude/CLAUDE.md" = linkRepo "CLAUDE.md";
    ".claude/statusline-command" = linkRepo "statusline-command";
    ".codex/AGENTS.md" = linkRepo "CLAUDE.md";
  };

  home.activation = {
    claudeMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] syncClaudeMcpServers;
    claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] syncSettings;
    claudeStaticDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] syncStaticDirs;
    codexMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] syncCodexMcpServers;
    codexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] syncCodexSkills;
  };
}
