{ pkgs, ... }:

{
  # Initial login experience
  services.greetd = {
    enable = true;

    settings.default_session = {
      user = "syrax";
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd bash";
    };
  };
}
