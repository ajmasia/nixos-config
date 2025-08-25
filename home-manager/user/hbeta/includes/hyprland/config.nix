{ lib, ... }:

{
  imports = [ ./autostart.nix ./binding.nix ];

  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "kitty";

    monitor = "Virtual-1,1920x1080,auto,1";
  };
}
