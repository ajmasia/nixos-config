{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.svc.git;

  gitConfig = {
    core = {
      excludesfile = "$HOME/.gitignore";
      editor = "vim";
    };

    init = {
      defaultBranch = "main";
    };

    ui = {
      color = true;
    };
  };

  alias =
    if cfg.enableGitAlias then (import ../alias) else { };

in
{
  options.svc.git = {
    enable = mkEnableOption "enable git program";

    enableCrypt = mkEnableOption "enable git-cryp tool";
    enableLazygit = mkEnableOption "enable lazygit tool";
    enableLfs = mkEnableOption "enable lfs option";
    enableAlias = mkEnableOption "Enable GIT aliases";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gitAndTools.diff-so-fancy # git diff with colors
      gitAndTools.hub # github command-line client
      gitAndTools.tig # diff and commit view
    ] ++ optional cfg.enableCrypt git-crypt;

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

      settings = {
        disableStartupPopups = true;
      };
    };
  };
}

