{ system, inputs, systemCustomModules, ... }:

let
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
in
{
  drogon = nixosSystem {

    inherit system;

    specialArgs = {
      inherit inputs;
    };

    modules = [
      systemCustomModules
      ./drogon/configuration.nix
    ];
  };
}

