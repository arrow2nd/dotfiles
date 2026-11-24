{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin

    ../../home/darwin/rinze.nix
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    item = "SSH鍵 (scottish)"
    vault = "個人"
  '';

  programs.git.settings.user = {
    email = "44780846+arrow2nd@users.noreply.github.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDv6UaKm/gX2q9mKLlxtlB1LZPEpMjGp3P2jv7lpVO+v";
  };

  home.packages = with pkgs; [
    colima

    # Docker Desktop は入れていないので CLI は nix 側から
    docker-client
    httpie
    luarocks
    mkcert
  ];
}
