{ inputs, pkgs, ... }:

let
  username = (import ./config.nix).userName;
  homeDirectory = (import ./config.nix).homeDirectory;
in
with pkgs;
{
  home = {
    inherit username homeDirectory;

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };

    # User packages
    packages = (import ./packages) pkgs;

    #  User aaets
    file = (import ./file) { };

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;

      name = "capitaine-cursors";
      package = capitaine-cursors;
    };

    stateVersion = "22.11";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [ ];
    };

    # overlays = [ ];
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  imports = builtins.concatMap import [
    ./xdg
    ./ui
    ./programs
    ./services
  ];
}


