# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):

    # Or modules exported from other flakes (such as nix-colors):

    # Include splited configuration files here
  ];

  home = {
    username = "syrax";
    homeDirectory = "/home/syrax";

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };

    sessionVariables = { };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}

