{ config, ... }:
{
  imports = [
    ./git.nix
    ./ssh.nix
    ./wayland-services.nix
    ./gtk.nix
    ./cursor.nix
    ./udiskie.nix
    ./packages.nix
    ./android.nix
    ./hyprlock.nix
    ./mako.nix
    ./fuzzel.nix
  ];

  # 壁紙 (swaybg) とロック画面 (hyprlock) の画像
  _module.args.wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/JpbRcFJRfiABMP3Lj1Cads1F.png";
  _module.args.lockWallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/me.png";
}
