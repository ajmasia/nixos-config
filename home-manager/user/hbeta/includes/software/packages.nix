{ pkgs, ... }:

let
  systemTools = with pkgs;
    [
      nautilus # gnome wayland file manager
    ];

  allUserPackages = systemTools;

in { home.packages = allUserPackages; }
