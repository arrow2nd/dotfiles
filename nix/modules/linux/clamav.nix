{ config, ... }:

let
  home = config.users.users.arrow2nd.home;
  downloadsDir = "${home}/Downloads";
in
{
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;

    # ダウンロードしたファイルは開く前に検査しとく
    clamonacc.enable = true;
    daemon.settings = {
      OnAccessPrevention = true;
      OnAccessIncludePath = [ downloadsDir ];
    };
  };
}
