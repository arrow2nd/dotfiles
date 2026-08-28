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

  # ~/.claude.json は Claude Code 自身が書き換えるので初期値として CLI 経由で user スコープで登録
  syncClaudeMcpServers = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: cfg: ''
      $DRY_RUN_CMD ${claudeBin} mcp remove ${lib.escapeShellArg name} -s user >/dev/null 2>&1 || true
      $DRY_RUN_CMD ${claudeBin} mcp add-json -s user ${lib.escapeShellArg name} ${lib.escapeShellArg (builtins.toJSON cfg)}
    '') mcpServers
  );

  syncCodexMcpServers = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: cfg: let
      envArgs = lib.mapAttrsToList (key: value: "--env ${lib.escapeShellArg "${key}=${value}"}") cfg.env;
      command = lib.escapeShellArgs ([ cfg.command ] ++ cfg.args);
    in ''
      $DRY_RUN_CMD ${codexBin} mcp remove ${lib.escapeShellArg name} >/dev/null 2>&1 || true
      $DRY_RUN_CMD ${codexBin} mcp add ${lib.escapeShellArg name} ${lib.concatStringsSep " " envArgs} -- ${command}
    '') mcpServers
  );

  # これも同じく
  syncSettings = ''
    $DRY_RUN_CMD install -D -m 644 \
      ${claudeRepo}/settings.json \
      ${claudeHome}/settings.json
  '';

  # ディレクトリごと symlink すると終わるのでディレクトリを切ってファイルのリンクを貼る
  syncStaticDirs = ''
    for subdir in agents commands skills; do
      $DRY_RUN_CMD mkdir -p "${claudeHome}/$subdir"
      for src in "${claudeRepo}/$subdir"/*; do
        [ -e "$src" ] || continue
        $DRY_RUN_CMD ln -sfn "$src" "${claudeHome}/$subdir/$(basename "$src")"
      done
    done
  '';

  syncCodexSkills = ''
    $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.agents/skills"
    for src in "${claudeRepo}/skills"/*; do
      [ -e "$src" ] || continue
      $DRY_RUN_CMD ln -sfn "$src" "${config.home.homeDirectory}/.agents/skills/$(basename "$src")"
    done
  '';
in
{
  home.packages = [
    llm.claude-code
    llm.codex
    llm.opencode
    llm.agent-browser
    pkgs.sox
  ];

  # 静的設定は直接 symlink
  home.file = {
    ".claude/CLAUDE.md" = linkRepo "CLAUDE.md";
    ".claude/statusline-command" = linkRepo "statusline-command";
    ".codex/AGENTS.md" = linkRepo "CLAUDE.md";
  };

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "opencode-go/deepseek-v4-flash";
    mcp = {
      vv-mcp = {
        type = "local";
        command = [ "npx" "-y" "@arrow2nd/vv-mcp" ];
        environment = {
          VOICEVOX_URL = "http://localhost:50021";
          DEFAULT_VOICE_ID = "47";
          DEFAULT_SPEED = "1.0";
        };
      };
    };
  };

  home.activation = {
    claudeMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] syncClaudeMcpServers;
    claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] syncSettings;
    claudeStaticDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] syncStaticDirs;
    codexMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] syncCodexMcpServers;
    codexSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] syncCodexSkills;
  };
}
