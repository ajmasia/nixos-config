{ pkgs, ... }:

{
  # Initial login experience
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        user = "syrax";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd bash";
      };

      default_session = initial_session;
    };
  };
}
