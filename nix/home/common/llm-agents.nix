{ pkgs, inputs, lib, config, ... }:
let
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  claudeRepo = "${config.home.homeDirectory}/dotfiles/.claude";
  claudeHome = "${config.home.homeDirectory}/.claude";
  linkRepo = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${claudeRepo}/${path}";
  };

  # opnix が展開する 1Password 由来の API キー
  sakanaApiKeyPath = "/var/lib/opnix/secrets/sakanaApiKey";

  # opencode の {env:SAKANA_API_KEY} 解決用に env を注入してから本体を起動
  opencode-wrapped = pkgs.writeShellScriptBin "opencode" ''
    if [ -r ${sakanaApiKeyPath} ]; then
      export SAKANA_API_KEY=$(cat ${sakanaApiKeyPath})
    fi
    exec ${llm.opencode}/bin/opencode "$@"
  '';

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

  # ~/.claude.json は Claude Code 自身が書き換えるので初期値として CLI 経由で user スコープで登録
  syncMcpServers = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: cfg: ''
      $DRY_RUN_CMD ${claudeBin} mcp remove ${lib.escapeShellArg name} -s user >/dev/null 2>&1 || true
      $DRY_RUN_CMD ${claudeBin} mcp add-json -s user ${lib.escapeShellArg name} ${lib.escapeShellArg (builtins.toJSON cfg)}
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
in
{
  home.packages = [
    llm.claude-code
    llm.codex
    opencode-wrapped
    llm.agent-browser
    pkgs.sox
  ];

  # 静的設定は直接 symlink
  home.file = {
    ".claude/CLAUDE.md" = linkRepo "CLAUDE.md";
    ".claude/statusline-command" = linkRepo "statusline-command";
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
    claudeMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] syncMcpServers;
    claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] syncSettings;
    claudeStaticDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] syncStaticDirs;
  };
}
