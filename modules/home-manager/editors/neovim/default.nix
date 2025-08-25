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

    # --- NEW: simple LazyVim bootstrap switch ---
    lazyvim.enable = mkOption {
      type = types.bool;
      default = false;
      description = "If true, clone LazyVim/starter into ~/.config/nvim when the directory is absent or empty.";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    # Neovim base configuration
    {
      programs.neovim = mkMerge [
        {
          enable = true; # ensure Neovim is installed by HM

          withPython3 = true;
          withNodeJs = true;

          defaultEditor = mkDefault true;
        }
        safeSettings
      ];

      # Export aliases (module defaults -> user-provided)
      editors.neovim.customAliases = mkMerge [
        (mkDefault defaultAliases)
        cfg.aliases
      ];
    }

    # LazyVim bootstrap via simple bash script (git clone), only if enabled
    (mkIf cfg.lazyvim.enable {
      # Ensure git is available in activation
      home.packages = with pkgs; [
        gcc # GNU compiler collection tools
        cmake # Cross-platform, open-source build system generatorpa
        gnumake # Tool to control the generation of non-source files from sources
        cargo # Rust builder & module manager
        luajitPackages.luarocks # A package manager for Lua modules
        tree-sitter # An incremental parsing system for programming tools
        ripgrep # Line-oriented search tool that recursively searches your current directory for a regex pattern
        lua5_1 # Just-In-Time Compiler for Lua
      ];

      # Activation step runs after files are written; it won't overwrite an existing config.
      home.activation.neovimLazyVimBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        set -eu

        # IMPORTANT: escape nix variables with double single-quotes
        CFG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
        NVIM_DIR="''${CFG_HOME}/nvim"

        # If nvim config dir is missing OR empty => bootstrap LazyVim
        if [ ! -d "$NVIM_DIR" ] || [ -z "$(${pkgs.coreutils}/bin/ls -A "$NVIM_DIR" 2>/dev/null || true)" ]; then
          echo "[neovim] Bootstrapping LazyVim into $NVIM_DIR"
          ${pkgs.coreutils}/bin/mkdir -p "$CFG_HOME"
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_DIR"
          ${pkgs.coreutils}/bin/rm -rf "$NVIM_DIR/.git"
        else
          echo "[neovim] Skipping LazyVim bootstrap: $NVIM_DIR already exists and is not empty"
        fi
      '';
    })
  ]);
}

