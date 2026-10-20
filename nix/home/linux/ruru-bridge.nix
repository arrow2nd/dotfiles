{ config, inputs, lib, pkgs, ... }:
let
  bridge = pkgs.callPackage ../../pkgs/ruru-bridge.nix {
    src = "${inputs.ruru-bridge-src}/cmd/ruru-bridge";
  };
  orca = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.orca;
  home = config.home.homeDirectory;
  configPath = "${config.xdg.configHome}/ruru-bridge/watch.json";
  # 登録済みセッションのCLIパスを維持し、パッケージ更新でも登録を再送しない。
  orcaPath = "${home}/.local/bin/orca-ide";
in
{
  home.packages = [ bridge ];
  home.file = {
    ".local/bin/ruru-bridge".source = "${bridge}/bin/ruru-bridge";
    ".local/bin/orca-ide".source = "${orca}/lib/Orca/resources/bin/orca-ide";
    # Orcaが作った既存symlinkはHome Managerの自動退避対象外になる。
    ".local/bin/orca-ide".force = true;
  };

  xdg.configFile."ruru-bridge/watch.json".text = builtins.toJSON {
    url = "https://openmediavault.tail6eef4e.ts.net:8443";
    orca = orcaPath;
    workspaces = [];
  };

  # systemctl enableが作ったリンクを、宣言したWantedByのリンクへ移管する。
  xdg.configFile."systemd/user/default.target.wants/ruru-bridge.service".force = true;

  # 資格情報と *.sessions は実行時のデータなのでNix storeへコピーしない。
  systemd.user.services.ruru-bridge = {
    Unit.Description = "Ruru Orca Bridge";
    Service = {
      ExecStart = "${bridge}/bin/ruru-bridge watch --config ${configPath}";
      EnvironmentFile = "${config.xdg.configHome}/ruru-bridge/credentials.env";
      Environment = [ "PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.bash pkgs.git ]}" ];
      UnsetEnvironment = [ "ORCA_ENVIRONMENT" "ORCA_PAIRING_CODE" "ORCA_CLI_CWD" ];
      WorkingDirectory = home;
      Restart = "on-failure";
      RestartSec = 10;
      UMask = "0077";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
