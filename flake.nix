{
  description = "Config for my system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astasko-nvim.url = "github:AlexStasko/nvim";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    darwinConfigurations = {
      epam = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/epam-macbook-m1
          ./home/aleksandr_stasko
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = [pkgs.just];
    };

    formatter = pkgs.alejandra;
  };
}
