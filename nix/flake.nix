{
  description = "arrow2nd's NixOS + nix-darwin + home-manager flake";

  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  inputs = {
    # nixpkgs (stable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # darwin 向けの hotfix が先に入るブランチ（macOS ではこちらを使う）
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1Password Service Account 経由でシークレットを管理したいっす！
    opnix = {
      url = "github:brizzbuzz/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.devon = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/devon/configuration.nix
          inputs.opnix.nixosModules.default
        ];
      };

      darwinConfigurations."nyan-chot" = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nyan-chot/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.tanida = import ./hosts/nyan-chot/home.nix;
              # install.sh が作った既存の symlink と衝突した場合は退避する
              backupFileExtension = "hm-backup";
            };
          }
        ];
      };

      homeConfigurations."arrow2nd" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/devon/home.nix
          inputs.niri.homeModules.niri
        ];
      };
    };
}
