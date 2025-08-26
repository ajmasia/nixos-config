{ ... }:

{
  home.file = {
    ".config/wallpapers" = {
      source = ../../../../assets/wallpapers;
      recursive = true;
    };
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [ "~/.config/wallpapers/wallpaper_001.jpg" ];
      wallpaper = [ ",~/.config/wallpapers/wallpaper_001.jpg" ];
    };
  };
}
