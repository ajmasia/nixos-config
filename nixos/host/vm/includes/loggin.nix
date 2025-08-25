{ pkgs, ... }:

{
  # Initial login experience
  services.greetd = {
    enable = true;
    settings = rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd bash";
      };
    };
  };
}
