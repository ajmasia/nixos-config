{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    env = [
      # Cursor size
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"

      # Force all apps to use Wayland
      "GDK_BACKEND,wayland"
      "QT_QPA_PLATFORM,wayland"
      "QT_STYLE_OVERRIDE,kvantum"
      "SDL_VIDEODRIVER,wayland"
      "MOZ_ENABLE_WAYLAND,1"
      "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      "OZONE_PLATFORM,wayland"

      # Make Chromium use XCompose and all Wayland
      ''
        CHROMIUM_FLAGS,"--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4"''
    ];

    xwayland = { force_zero_scaling = true; };

    # Don't show update on first launch
    ecosystem = { no_update_news = true; };

  };

}
