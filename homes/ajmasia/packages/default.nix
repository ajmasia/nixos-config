{ pkgs, ... }:

let
  unstablePackages = import <unstable> { };
in
with pkgs; [ 
  # System

  # Fonts
  nerdfonts               # Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts 
  font-awesome            # Font Awesome - OTF font

  # UI
  feh                     # A light-weight image viewer
  libnotify               # A library that sends desktop notifications to a notification daemon
]


