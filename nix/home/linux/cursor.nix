{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    gtk.enable = true;
    # XWayland アプリや XCURSOR_THEME を直接読むアプリ向け
    x11.enable = true;
  };
}
