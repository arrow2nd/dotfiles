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
    ./swaylock.nix
    ./mako.nix
  ];

  # 壁紙 (swaybg) とロック画面 (swaylock) で同じ画像を使う
  _module.args.wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/JpbRcFJRfiABMP3Lj1Cads1F.png";
}
