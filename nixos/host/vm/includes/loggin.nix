{ lib, pkgs, ... }:
let
  catppuccinMocha = ''
    border=lightmagenta;
    title=lightmagenta;
    text=white;
    greet=white;
    prompt=lightcyan;
    input=lightgreen;
    time=lightblue;
    action=lightblue;
    button=yellow;
    container=black
  '';

  theme = catppuccinMocha;
in
{
  # Initial login experience
  # https://github.com/apognu/tuigreet
  services.greetd = {
    enable = true;

    settings = rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --theme '${lib.replaceStrings ["\n" " "] ["" ""] theme}' \
          --cmd bash";
      };
    };
  };
}
