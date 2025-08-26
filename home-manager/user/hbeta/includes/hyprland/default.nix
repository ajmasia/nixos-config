{ inputs, pkgs, ... }:

{
  imports = [ ./config.nix ];

  # TODO: Use unstable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  services.hyprpolkitagent.enable = true;
}
