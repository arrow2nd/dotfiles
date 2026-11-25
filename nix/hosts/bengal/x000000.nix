{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin

    ../../home/darwin/rinze.nix
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "x000000"
  '';

  home.packages = with pkgs; [
    colima
    docker-client
    glab
    httpie
    luarocks
    mkcert
    pdftk
    potrace
    scrcpy
  ];
}
