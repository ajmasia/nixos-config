{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.svc.git;

  # Base Git config (editor, default branch, UI color, etc.)
  gitConfig = {
    core = {
      excludesfile = "$HOME/.gitignore";
      editor = "vim";
    };
    init.defaultBranch = "main";
    ui.color = true;
  };

  # Load aliases from a separate file ONLY if enableAlias = true.
  # IMPORTANT: ../alias MUST return an attrset of strings, e.g. { gs = "git status"; co = "git checkout"; }
  loadedAliases =
    if cfg.enableAliasese then (import ./alias) else { };
in
{
  options.svc.git = {
    enable = mkEnableOption "enable git program";
    enableCrypt = mkEnableOption "enable git-crypt tool";
    enableLazygit = mkEnableOption "enable lazygit tool";
    enableLfs = mkEnableOption "enable lfs option";

    # Single, consistent switch name:
    enableAliases = mkEnableOption "Enable Git aliases";
  };

  config = mkIf cfg.enable {
    # Populate the exported option when enabled (so others can read config.svc.git.aliases)
    svc.git.aliases = loadedAliases;

    home.packages = with pkgs; [
      gitAndTools.diff-so-fancy
      gitAndTools.hub
      gitAndTools.tig
    ] ++ optional cfg.enableCrypt pkgs.git-crypt;

    programs.git = {
      enable = true;

      extraConfig = gitConfig;
      userName = "Antonio Masiá";
      userEmail = "ajmasia.dev@ysnp.link";

      ignores = [
        ".dir-locals.el"
        ".log"
        ".projectile"
        ".tern-project"
        "TAGS"
        "ti-.*.log"
        "tsserver.log"
      ];

      lfs.enable = cfg.enableLfs;
    };

    programs.lazygit = {
      enable = cfg.enableLazygit;
      package = pkgs.lazygit;
      settings.disableStartupPopups = true;
    };
  };
}

