{ pkgs, ... }:

{
  # Initial login experience
  services.greetd = {
    enable = true;
    settings = rec {
      default_session = {
        user = "greeter";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user syrax --cmd bash";
      };
    };
  };
}
