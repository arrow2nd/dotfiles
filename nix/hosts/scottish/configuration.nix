{ ... }:
{
  # Tailscale
  services.tailscale.enable = true;

  homebrew = {
    brews = [
      # nixpkgs 版は ls などを prefix 無しで上書きしてしまうので brew 版（g 付き）のまま
      "coreutils"
    ];

    casks = [
      "aws-vpn-client"
      "obs"
      "onyx"
      "screen-studio"
      "tunnelblick"
    ];
  };
}
