{ ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # cache.nixos.org は NixOS / nix-darwin がデフォルトで足すのでここには書かない
    substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
