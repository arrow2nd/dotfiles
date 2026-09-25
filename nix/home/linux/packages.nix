{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    # Desktop env
    waybar
    swaybg
    swayidle
    vicinae
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
