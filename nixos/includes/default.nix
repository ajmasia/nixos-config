# Aggregates common, reusable parts. Hosts import this directory (../includes).
{ ... }:

{
  imports = [
    ./nixpkgs-configuration.nix
    ./nix-configuration.nix
  ];
}

