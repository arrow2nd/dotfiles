{
  description = "arrow2nd's NixOS + home-manager flake";

  inputs = {
    # nixpkgs (stable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # nixpkgs (unstable, neovim等の最新パッケージ用)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri-flake
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # unstable パッケージへのアクセス用
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # NixOS
      nixosConfigurations.devon = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/devon/configuration.nix
          inputs.niri.nixosModules.niri
        ];
      };

      # home-manager
      homeConfigurations."arrow2nd" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./home/home.nix
        ];
      };
    };
}
