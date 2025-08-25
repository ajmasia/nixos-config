{ config, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      vim # default editor
    ];

    sessionVariables = { };
  };

  # Run unpatched dynamic binaries on NixOS.
  # Needed for use some packages installed by neovim
  programs.nix-ld.enable = true;
}

