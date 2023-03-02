{
  description = "My awesome system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amd-controller = {
      type = "github";
      owner = "ajmasia";
      repo = "amd-controller";
      ref = "implement_multi_processor-config";
    };

    bazecor-nix = {
      url = "github:ajmasia/bazecor-nix";
    };
  };


  outputs = inputs @ { nixpkgs, home-manager, ... }:

    let
      system = "x86_64-linux";
      systemCustomModules = {
        imports = [
          inputs.amd-controller.module
        ];
      };
    in
    {
      homeConfigurations = (
        import ./homes {
          inherit system inputs;
        }
      );

      nixosConfigurations = (
        import ./systems {
          inherit system inputs systemCustomModules;
        }
      );
    };
}
