{ inputs, outputs, ... }:

{
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };

    # nixpkgs options are disabled when home-manager.useGlobalPkgs is enabled
    useGlobalPkgs = false;
    useUserPackages = true;
    backupFileExtension = "backup";

    users = {
      # Import your home-manager configuration
      "syrax" = import ../../../home-manager/user/syrax/home.nix;
    };
  };
}

