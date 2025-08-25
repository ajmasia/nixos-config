{ lib, ... }:

{
  imports = [ ./autostart.nix ./binding.nix ./env.nix ./ui.nix ];

  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "alacritty";

    monitor = "Virtual-1,1920x1080,auto,0.8";
  };
}
