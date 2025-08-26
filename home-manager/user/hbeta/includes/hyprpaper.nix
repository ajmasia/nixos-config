{ ... }:

{
  home.file = {
    ".config/wallpapers" = {
      source = ../../../../themes/wallpapers;
      recursive = true;
    };
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [
        "$HOME/.config/wallpapers"
      ];
      wallpaper = [
        "$HOME/.config/wallpapers"
      ];
    };
  };
}
