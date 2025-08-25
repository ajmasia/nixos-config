{ lib, pkgs, ... }:
let
  tuigreet = lib.getExe pkgs.greetd.tuigreet;

  theme =
    "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
in
{
  # Initial login experience
  # https://github.com/apognu/tuigreet
  services.greetd = {
    enable = true;

    settings = rec {
      default_session = {
        command = "${tuigreet} --time --asterisks --user-menu " + "--theme '${theme}' "
          + "--cmd bash";
      };
    };
  };
}
