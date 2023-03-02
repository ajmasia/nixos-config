let
  configHome = (import ../../config.nix).configHome;
in
{
  xdg = {
    inherit configHome;

    enable = true;

    desktopEntries = import ../desktop;
  };
}


