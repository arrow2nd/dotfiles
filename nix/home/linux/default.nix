{ ... }:
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
}
