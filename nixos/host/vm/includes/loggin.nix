{ pkgs, ... }:

{
  # Initial login experience
  # https://github.com/apognu/tuigreet
  services.greetd = {
    enable = true;

    settings = rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd bash";
      };
    };
  };
}
