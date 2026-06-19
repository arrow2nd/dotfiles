{ ... }:
{
  imports = [
    ./wayland-services.nix
    ./gtk.nix
    ./udiskie.nix
    ./packages.nix
    ./swaylock.nix
    ./mako.nix
  ];
}
