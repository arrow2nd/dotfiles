{
  config,
  pkgs,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  command = [
    "${pkgs.trash-cli}/bin/trash-empty"
    "-f"
    "30"
  ];
in
{
  launchd.agents = lib.mkIf isDarwin {
    trash-empty = {
      enable = true;
      config = {
        ProgramArguments = command;
        # 指定時刻に電源が落ちていると実行されないため、ログイン時にも走らせる
        RunAtLoad = true;
        StartCalendarInterval = [
          {
            Hour = 12;
            Minute = 0;
          }
        ];
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/trash-empty.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/trash-empty.log";
      };
    };
  };

  systemd.user.services = lib.mkIf (!isDarwin) {
    trash-empty = {
      Unit.Description = "Purge trash-cli items older than 30 days";
      Service = {
        Type = "oneshot";
        ExecStart = lib.escapeShellArgs command;
      };
    };
  };

  systemd.user.timers = lib.mkIf (!isDarwin) {
    trash-empty = {
      Unit.Description = "Daily purge of old trash-cli items";
      Timer = {
        OnCalendar = "daily";
        # 電源が落ちていて実行できなかった分を次回起動時に取り戻す
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
