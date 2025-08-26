{ pkgs, ... }:

let
  systemTools = with pkgs;
    [
      naytilus # gnome wayland file manager
    ];

  allUserPackages = systemTools;

in { home.packages = allUserPackages; }
