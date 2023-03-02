{ ... }:

{
  services.sxhkd = {
    enable = true;

    keybindings = import ./keybindings.nix { };
  };
}

