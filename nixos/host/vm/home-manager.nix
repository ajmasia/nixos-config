{ inputs, outputs, ... }:

{
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };

    # nixpkgs options are disabled when home-manager.useGlobalPkgs is enabled
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      # Import your home-manager configuration
      "syrx" = import ../../../home-manager/user/syrax/home.nix;
    };
  };
}

