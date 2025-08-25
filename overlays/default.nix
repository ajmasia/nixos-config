# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    lua51 = final: prev:
      let
        # https://lazamar.co.uk/nix-versions/
        legacy = import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/e10001042d6fc2b4246f51b5fa1625b8bf7e8df3.tar.gz";
            sha256 = "sha256:09s6y6i2pprqlk4zmq6ssrc77ag005wyalvnq6x6qspxrx8k1wvi";

          })
          {
            system = prev.stdenv.hostPlatform.system or system; # <-- pasamos system
            config = prev.config;
          };
      in
      {
        lua5_1 = legacy.lua5_1;
      };

  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;

      config.allowUnfree = true;
    };
  };
}
