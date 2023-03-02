let
  userName = "ajmasia";
  homeDirectory = "/home/${userName}";
  configHome = "${homeDirectory}/.config";
in
{
  userName = userName;
  homeDirectory = homeDirectory;
  configHome = configHome;
  wallpaper = "wallpaper_004.jpg";
}
