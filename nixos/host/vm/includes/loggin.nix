{ pkgs, ... }:

{
  # Initial login experience
  services.greetd = {
    enable = true;

    settings = {
      initial_setting = {
        user = "syrax";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd bash";
      };

      default_session = initial_setting;
    };
  };
}
