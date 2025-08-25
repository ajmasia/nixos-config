{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.terminal.alacritty;

  colorScheme = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        default = "catpuccin";
        description = "The theme to use";
      };
      variant = mkOption {
        type = types.str;
        default = "macchiato";
        description = "The variant of the theme";
      };
    };
  };
in
{
  options.terminal.alacritty = {
    enable = mkEnableOption "enable bash configuration";

    theme = mkOption {
      type = colorScheme;
      default = { name = "catppuccin"; variant = "macchiato"; };
      description = "Configure the theme and its variant";
      example = { name = "nord"; variant = "dark"; };
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          size = 13;

          normal = {
            family = "Hack Nerd Font";
          };
        };

        colors =
          (import ./themes/${cfg.theme.name}.nix { }).${cfg.theme.variant};

        window = {
          padding = {
            x = 8;
            y = 8;
          };
          decorations = "none";
        };

        cursor = {
          blink_interval = 750;
          unfocused_hollow = false;

          style = {
            shape = "underline";
            blinking = "always";
          };
        };

        # TODO: make this optionable
        shell = {
          program = "/run/current-system/sw/bin/bash";
        };
      };
    };
  };
}

