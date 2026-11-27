{
  config,
  pkgs,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # Linux 側 (Radeon 860M / Krackan) は ROCm のサポートが不安定なため Vulkan を
  llamaCpp = pkgs.callPackage ../../pkgs/llama-cpp.nix {
    package = if isDarwin then pkgs.llama-cpp else pkgs.llama-cpp.override { vulkanSupport = true; };
  };

  modelCache = "${config.home.homeDirectory}/.cache/llama.cpp";

  servers = {
    # llama.vim のインライン補完用
    llama-server = {
      description = "llama.cpp server for llama.vim FIM completion";
      args = [
        "--hf-repo"
        "ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF"
        "--port"
        "8012"
        "-ngl"
        "99"
        "--batch-size"
        "1024"
        "--ubatch-size"
        "1024"
        "--ctx-size"
        "0"
        "--cache-reuse"
        "256"
        # プロンプトキャッシュのデフォルト上限 8GB は常駐させるにはデカい気がした
        "--cache-ram"
        "2048"
      ];
    };

    # 翻訳用
    llama-translate = {
      description = "llama.cpp server for PLaMo 3 Translate";
      args = [
        "--hf-repo"
        "pfnet/plamo-3-translate-0.8b-GGUF:Q4_K_M"
        "--port"
        "8013"
        "-ngl"
        "99"
        "--ctx-size"
        "8192"
        "--cache-ram"
        "512"
      ];
    };
  };

  command = server: [ "${llamaCpp}/bin/llama-server" ] ++ server.args;
in
{
  home.packages = [ llamaCpp ];

  launchd.agents = lib.mkIf isDarwin (
    lib.mapAttrs (name: server: {
      enable = true;
      config = {
        ProgramArguments = command server;
        EnvironmentVariables.LLAMA_CACHE = modelCache;
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${name}.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${name}.log";
      };
    }) servers
  );

  systemd.user.services = lib.mkIf (!isDarwin) (
    lib.mapAttrs (_: server: {
      Unit = {
        Description = server.description;
        After = [ "network-online.target" ];
      };
      Service = {
        ExecStart = lib.escapeShellArgs (command server);
        Environment = [ "LLAMA_CACHE=${modelCache}" ];
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    }) servers
  );
}
