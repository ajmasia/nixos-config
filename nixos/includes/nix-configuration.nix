{ pkgs, ... }:

{
  # Configure your nix instance
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}

