{ lib, config, pkgs, ... }:

# Home Manager module: Neovim with optional unstable package and Bash aliases.
# Usage example (in your HM config):
#
#   {
#     # Add `outputs.homeManagerModules.editors` to home.nix imports
#
#     editors.neovim = {
#       enable = true;
#       alias = true;            # add bash aliases vi/vim -> nvim
#       useUnstable = true;      # requires pkgs.unstable overlay to be present
#       settings = {
#         viAlias = true;        # programs.neovim options merged below
#         vimAlias = true;
#         withNodeJs = true;
#         withPython3 = true;
#
#         extraConfig = ''
#           set number
#           set relativenumber
#         '';
#       };
#     }; e
#   }
#
# Notes:
# - `settings` is merged into programs.neovim, but `enable` and `package` keys are ignored
#   to avoid conflicts with this module's own logic.
# - If `useUnstable = true` and `pkgs.unstable.neovim` is unavailable, we silently fall back
#   to the stable `pkgs.neovim` to keep evaluation robust.

with lib;

let
  cfg = config.editors.neovim;

  # Pick Neovim package: prefer unstable when requested AND available, else stable.
  nvimPkg =
    if cfg.useUnstable && (pkgs ? unstable && pkgs.unstable ? neovim)
    then pkgs.unstable.neovim
    else pkgs.neovim;

  # Do not allow user-supplied settings to override 'enable' or 'package' here.
  safeSettings = removeAttrs cfg.settings [ "enable" "package" ];

  # Default aliases this module proposes; can be disabled via alias=false
  # and/or overridden/extended via `extraAliases`.
  defaultAliases = { };
in
{
  options.svc.neovim = {
    enable = mkEnableOption "Install and configure Neovim via Home Manager.";

    aliases = mkOption {
      type = types.attrsOf types.str; # { name = "command"; }
      default = { };
      description = "User-defined aliases merged on top of the module defaults.";
    };

    useUnstable = mkOption {
      type = types.bool;
      default = false;
      description = "Use Neovim from nixpkgs-unstable (requires 'pkgs.unstable' overlay).";
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

        package = nvimPkg; # stable or unstable depending on cfg/useUnstable
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

