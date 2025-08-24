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
    in
    {
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs nixpkgs; };

      nixosConfigurations = {
        "nixos" =
          nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = { inherit inputs outputs; };

            modules = [
              ./nixos/vm/configuration.nix
            ];
          };
      };
    };
}
