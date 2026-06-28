{ ... }:
{
  imports = [
    ./wayland-services.nix
    ./gtk.nix
    ./udiskie.nix
    ./packages.nix
    ./android.nix
    ./swaylock.nix
    ./mako.nix
  ];
}
