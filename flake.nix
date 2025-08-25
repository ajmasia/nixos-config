{
  description = "NixOS stable with ad-hoc unstable access";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      version = "0.1.0";
    in {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = import ./packages nixpkgs.legacyPackages.${system};

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs nixpkgs; };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        lab = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs outputs; };

          modules = [ ./nixos/host/lab ];
        };
      };
    };
}
