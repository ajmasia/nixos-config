# Aggregates common, reusable parts. Hosts import this directory (../includes).
{ ... }:

{
  imports = [
    ./locale.nix
    ./nix-configuration.nix
    ./nixpkgs-configuration.nix
    ./security.nix
  ];
}

