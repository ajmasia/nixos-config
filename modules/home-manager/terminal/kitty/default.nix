{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.terminal.kitty;
in
{
  options.terminal.kitty = {
    enable = mkEnableOption "enable bash configuration";

    theme = mkOption {
      type = types.str;
      default = "Catppuccin-Macchiato";
      description = "The theme to use";
    };

    useBash = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Bash integration";
    };

  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font.name = "Hack Nerd Font";
      font.size = 13;

      theme = cfg.theme;
      shellIntegration.enableBashIntegration = cfg.useBash;
      shellIntegration.mode = "no-cursor";

      settings = {
        window_padding_width = 6;
        confirm_os_window_close = 0;
        cursor_shape = "underline";
        detect_urls = "yes";
        copy_on_selects = "yes";
      };
    };
  };
}

