{ system, inputs, ... }:

let
  ajmasiaConfigPath = "ajmasia";
in
with inputs;
{
  # drogon-ajmasia
  ajmasia = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};

    extraSpecialArgs = {
      inherit inputs;
    };

    modules = [
      ./${ajmasiaConfigPath}/home.nix 
    ];
  };
}

