{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
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
    mergiraf
    mkcert
    pdftk
    potrace
    scrcpy
  ];
}
