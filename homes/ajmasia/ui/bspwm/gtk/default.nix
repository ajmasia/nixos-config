{ pkgs, ... }:

{
  gtk = with pkgs; {
    enable = true;

    theme = {
      name = "Nordic";
      package = nordic;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = papirus-icon-theme;
    };
  };
}


