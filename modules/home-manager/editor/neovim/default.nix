{ lib, config, pkgs, ... }:

# Home Manager module: editor.neovim
#
# Purpose
#   - Install and configure Neovim for the current user.
#   - (Optional) Bootstrap a default LazyVim setup if ~/.config/nvim is missing
#     or empty (idempotent: it will NOT overwrite an existing config).
#
# Options
#   editor.neovim.enable          : bool
#     Master switch for this module.
#
#   editor.neovim.aliases         : attrsOf str
#     User-defined alias map related to Neovim (e.g., { v = "nvim"; }).
#     This module only *exports* aliases; your Bash/Zsh module should *merge*
#     them (e.g., via lib.attrByPath and mkDefault) together with other alias
#     sources (Git, custom, etc.).
#
#   editor.neovim.lazyvim.enable  : bool
#     When true, runs a bootstrap step on activation that:
#       - clones https://github.com/LazyVim/starter into ~/.config/nvim
#       - removes the .git directory
#     It only triggers if ~/.config/nvim does not exist or is empty; otherwise,
#     it prints a message and does nothing.
#
# Behavior notes
#   - By default we enable withPython3/withNodeJs and set defaultEditor=true.
#     Adjust from a higher-priority layer if needed (mkOverride/mkForce).
#   - The activation code uses absolute store paths (${pkgs.*}/bin/...) so
#     you do NOT need to add those tools to the user's PATH.
#   - Activation runs under systemd (home-manager-<user>.service). `echo` output
#     goes to the service journal, not to `nixos-rebuild` stdout. Use:
#       `journalctl -u home-manager-<user>.service -b --no-pager -l` or
#       `journalctl -t hm-lazyvim -b --no-pager -l`
#
# Caveat (lua5_1 on nixos-25.05)
#   - The attribute `pkgs.lua5_1` is not present in nixpkgs 25.05.
#     In this case is provide from a global overlay (see overlays/default.nix).

with lib;

let cfg = config.editor.neovim;
in {
  options.editor.neovim = {
    enable = mkEnableOption "Install and configure Neovim via Home Manager.";

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description =
        "User-defined aliases merged on top of the module defaults.";
    };

    lazyvim.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        "If true, clone LazyVim/starter into ~/.config/nvim when the directory is absent or empty.";
    };
  };
  config = mkIf cfg.enable (mkMerge [
    # Neovim base configuration
    {
      programs.neovim = {
        enable = true;

        withPython3 = true;
        withNodeJs = true;

        defaultEditor = mkDefault true;
      };
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
      home.activation.lazyVimBootstrap =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          set -eu

          # IMPORTANT: escape nix variables with double single-quotes
          CFG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
          NVIM_DIR="''${CFG_HOME}/nvim"

          # If nvim config dir is missing OR empty => bootstrap LazyVim
          if [ ! -d "$NVIM_DIR" ] || [ -z "$(${pkgs.coreutils}/bin/ls -A "$NVIM_DIR" 2>/dev/null || true)" ]; then
            ${pkgs.coreutils}/bin/mkdir -p "$CFG_HOME"
            ${pkgs.git}/bin/git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_DIR"
            ${pkgs.coreutils}/bin/rm -rf "$NVIM_DIR/.git"

            ${pkgs.util-linux}/bin/logger -t hm-lazyvim "[neovim] LazyVim bootstrapped into $NVIM_DIR"
          fi
        '';
    })
  ]);
}

