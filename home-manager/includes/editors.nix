{ pkgs, ... }:

let
  inherit (pkgs) unstable;
in

{
  programs.neovim.enable = true;
}


