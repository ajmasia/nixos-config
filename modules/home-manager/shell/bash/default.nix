{ lib, config, pkgs, ... }:

# Bring the NixOS/Home Manager standard library into scope
with lib;

let
  # Shorthand to access this module's options under `shell.bash`
  cfg = config.shell.bash;

  # Packages that are considered "core" for the shell environment.
  coreTools = with pkgs; [
    fd
    lfs
    tldr
    unzip
  ];

  # Extra environment initialization that is appended to bash init.
  userBaseConfig = ''
    # Additional PATH entries for local binaries
    export PATH="$HOME/.local/bin:$PATH"

    # Bash history: ignore duplicates and common trivial commands
    export HISTCONTROL=ignoreboth:erasedups

    # Ensure XDG data dirs include system and Flatpak paths (apps can find .desktop files, etc.)
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
  '';
in
{
  # Option declarations
  options.shell.bash = {
    # Master switch for this module: enables all bash-related settings below
    enable = mkEnableOption "Enable bash configuration";

    # User-provided alias map (e.g., { ll = "ls -alF"; gs = "git status"; })
    customAliases = mkOption {
      type = types.attrs;
      default = { };
      description = "define shell aliases";
    };

    # Gate for enabling/disabling the set of 'core tools' in one go
    enableCoreTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable core tools";
    };
  };

  # Configuration payload
  # Only apply everything in here if `shell.bash.enable = true;`
  config = mkIf cfg.enable (mkMerge [
    # Base bash + readline part
    {
      programs.bash = {
        enable = true; # Enable bash in Home Manager
        initExtra = userBaseConfig; # Append our custom init fragment

        # Minor quality-of-life settings:
        # - Ignore some trivial commands in history
        # - Enable useful shell options (append history, fix window size, globbing, etc.)
        historyIgnore = [ "ls" "cd" "exit" ];
        shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" "autocd" ];

        # Inject user-defined aliases from the `customAliases` option
        shellAliases = mkMerge [
          cfg.customAliases
          (lib.mkIf config.svc.git.enableGitAliases config.svc.git.aliases)
        ];
      };

      programs.readline = {
        enable = true; # Configure GNU Readline behavior (affects line editing)

        # Up/Down arrow search through history matching current prefix
        bindings = {
          "\\e[A" = "history-search-backward";
          "\\e[B" = "history-search-forward";
        };

        # Use vi-style editing and show mode indicators in the prompt
        variables = {
          editing-mode = "vi";
          show-mode-in-prompt = true;
          vi-cmd-mode-string = "\\1\\e[38;5;214m\\2󰮔 \\1\\e[0m\\2";
          vi-ins-mode-string = "\\1\\e[38;5;27m\\2󰛿 \\1\\e[0m\\2";
        };
      };
    }

    # Core tools block (only if enableCoreTools = true)
    (mkIf cfg.enableCoreTools {
      programs = {
        # Enable integrations/config for common CLI tools where HM provides modules.
        bat.enable = true;
        htop.enable = true;
        jq.enable = true;
        lsd.enable = true;
        ripgrep.enable = true;

        # fzf: enable and integrate with bash
        fzf = {
          enable = true;
          enableBashIntegration = true;
        };
      };

      # Add the core packages to the user environment (installed in the user profile)
      # This ensures the binaries exist regardless of whether a HM module exists for them.
      home.packages = coreTools;
    })
  ]);
}

