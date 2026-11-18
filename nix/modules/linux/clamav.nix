{ config, ... }:

let
  home = config.users.users.arrow2nd.home;
  downloadsDir = "${home}/Downloads";
  wineDriveDir = "${home}/.wine/drive_c";
in
{
  # Wine で入れる Windows 向けソフトを対象に、ClamAV で最低限の検査をする。
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;

    # ダウンロードしたファイルは開く前に検査し、検出したら開けないようにする。
    clamonacc.enable = true;
    daemon.settings = {
      OnAccessPrevention = true;
      OnAccessIncludePath = [ downloadsDir ];
    };

    # Wine の C ドライブは容量が大きく常時監視すると重いので、週 1 回まとめて検査する。
    scanner = {
      enable = true;
      interval = "Sun *-*-* 12:00:00";
      scanDirectories = [
        downloadsDir
        wineDriveDir
      ];
    };
  };

  # スリープや電源オフで予定時刻を逃した場合も、次回起動時に検査する。
  systemd.timers.clamdscan.timerConfig.Persistent = true;
}
