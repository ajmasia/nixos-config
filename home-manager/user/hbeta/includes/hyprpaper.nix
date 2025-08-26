{ ... }:

{
  home.file = {
    ".config/wallpapers" = {
      source = ../../../../assets/wallpapers;
      recursive = true;
    };
  };

  # services.hyprpaper = {
  #   enable = true;
  #
  #   settings = {
  #     preload = [
  #       "$HOME/.config/wallpapers/wallpaper_001.jpg"
  #     ];
  #     wallpaper = [
  #       "$HOME/.config/wallpapers/wallpaper_001.jpg"
  #     ];
  #   };
  # };
}
