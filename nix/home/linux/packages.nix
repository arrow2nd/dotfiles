{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    # Desktop env
    swaybg
    wl-clipboard
    brightnessctl
    playerctl
    libnotify
    grim # スクショ
    slurp # 範囲選択

    # GUI apps
    nautilus
    loupe # 画像ビューア
    satty # スクショの注釈とトリミング

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
