{
  config,
  pkgs,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # Linux 側 (Radeon 860M / Krackan) は ROCm のサポートが不安定なため Vulkan を
  llamaCpp = if isDarwin then pkgs.llama-cpp else pkgs.llama-cpp.override { vulkanSupport = true; };

  modelCache = "${config.home.homeDirectory}/.cache/llama.cpp";

  serverArgs = [
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
    # 0 = モデルの最大コンテキスト (32k)
    "--ctx-size"
    "0"
    # llama.vim の n_predict (128) より大きい値が必須
    "--cache-reuse"
    "256"
    # プロンプトキャッシュのデフォルト上限 8GB は常駐させるにはデカい気がした
    "--cache-ram"
    "2048"
  ];

  command = [ "${llamaCpp}/bin/llama-server" ] ++ serverArgs;
in
{
  home.packages = [ llamaCpp ];

  # llama.vim のインライン補完用に llama-server を常駐
  launchd.agents = lib.mkIf isDarwin {
    llama-server = {
      enable = true;
      config = {
        ProgramArguments = command;
        EnvironmentVariables.LLAMA_CACHE = modelCache;
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/llama-server.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/llama-server.log";
      };
    };
  };

  systemd.user.services = lib.mkIf (!isDarwin) {
    llama-server = {
      Unit = {
        Description = "llama.cpp server for llama.vim FIM completion";
        After = [ "network-online.target" ];
      };
      Service = {
        ExecStart = lib.escapeShellArgs command;
        Environment = [ "LLAMA_CACHE=${modelCache}" ];
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
