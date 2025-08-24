{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.editors.neovim;

  # Do not allow user-supplied settings to override 'enable' or 'package' here.
  safeSettings = removeAttrs cfg.settings [ "enable" "package" ];

  # Default aliases this module proposes; can be disabled via alias=false
  # and/or overridden/extended via `extraAliases`.
  defaultAliases = { };
in
{
  options.editors.neovim = {
    enable = mkEnableOption "Install and configure Neovim via Home Manager.";

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "User-defined aliases merged on top of the module defaults.";
    };

    # EXPORTED option with the aliases set so other modules (bash) can merge it.
    customAliases = mkOption {
      type = types.attrsOf types.str; # { aliasName = "command"; }
      default = { };
      description = "Alias map to inject into shells.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Extra attribute set merged into 'programs.neovim'.
        Example:
          {
            viAlias = true;
            vimAlias = true;
            withNodeJs = true;
            withPython3 = true;
            extraConfig = "set number";
            plugins = with pkgs.vimPlugins; [ nvim-treesitter telescope-nvim ];
          }
        The 'enable' and 'package' keys are ignored here.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Main Neovim program configuration
    programs.neovim = mkMerge [
      {
        enable = true; # ensure Neovim is installed by HM

        defaultEditor = mkDefault true; # make nvim the default editor unless overridden
      }
      safeSettings # user-provided settings merged here
    ];

    editors.neovim.customAliases = mkMerge [
      (mkDefault defaultAliases) # lower priority: can be overridden by extraAliases
      cfg.aliases # higher priority: defined where the module is used
    ];
  };
}

