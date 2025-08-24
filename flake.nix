{
  descrition = "NixOS stable with ad-hoc unstable access";

  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  home-manager.url = "github:nix-community/home-manager/release-25.05";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs nixpkgs; };

      nixosConfiguration."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs outputs; };

        modules = [
          ./nixos/vm/configuration.nix
        ];
      };
    };
}
