{ inputs, pkgs, ... }:
let
  orca = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.orca;
in
{
  # Bridge本体とサービスはruru-aiのインストーラーで更新する。
  # 登録済みセッションが参照するOrca CLIのパスは維持する。
  home.file.".local/bin/orca-ide" = {
    source = "${orca}/lib/Orca/resources/bin/orca-ide";
    force = true;
  };
}
