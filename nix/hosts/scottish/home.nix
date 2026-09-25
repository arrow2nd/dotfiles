{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "jig.jp"

    [[ssh-keys]]
    item = "SSH鍵 (scottish)"
    vault = "個人"
  '';

  home.file = {
    ".ssh/work.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnOiDY4x3AEEHHDQaMV+buWS39rP0SVDvTbzasYmg3M scottish\n";
    ".ssh/personal.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDv6UaKm/gX2q9mKLlxtlB1LZPEpMjGp3P2jv7lpVO+v SSH鍵 (scottish)\n";
  };

  home.packages = with pkgs; [
    colima

    # Docker Desktop は入れていないので CLI は nix 側から
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
