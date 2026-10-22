{ inputs, pkgs, ... }:
let
  orca = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.orca;
in
{
  xdg.desktopEntries.orca-ide = {
    name = "Orca";
    genericName = "Agentic Development Environment";
    comment = "Next-gen IDE for parallel agentic development";
    exec = "orca open %U";
    icon = "orca-ide";
    categories = [ "Development" ];
    mimeType = [ "x-scheme-handler/orca" ];
    settings.StartupWMClass = "orca";
  };

  # Bridge本体とサービスはruru-aiのインストーラーで更新する。
  # 登録済みセッションが参照するOrca CLIのパスは維持する。
  home.file.".local/bin/orca-ide" = {
    source = "${orca}/lib/Orca/resources/bin/orca-ide";
    force = true;
  };
}
