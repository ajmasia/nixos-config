{ lib, ... }:

{
  imports = [ ./autostart.nix ];

  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "ghostty";
  };
}
