{ lib, ... }:

{
  imports = [ ./autostart.nix ./binding.nix ];

  wayland.windowManager.hyprland.settings = {
    # Default applications
    "$terminal" = lib.mkDefault "ghostty";
  };
}
