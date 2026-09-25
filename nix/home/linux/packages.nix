{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    # Desktop env
    # waybar / vicinae / swayidle は niri.nix の各モジュールで入る
    swaybg
    wl-clipboard
    brightnessctl
    playerctl
    libnotify
    grim # スクショ
    slurp # 範囲選択

    # GUI apps
    nautilus

    mkcert
    bluetuith
    pavucontrol
    wl-screenrec
    shotcut
    oxker
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
