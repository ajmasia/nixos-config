# NixOS config

This repository provides a modular and reproducible NixOS configuration using [Nix flakes](https://nixos.wiki/wiki/Flakes). It features a stable NixOS system, custom overlays, reusable modules, and integrates Home Manager as a NixOS module for seamless user environment management.

## Features

- **Stable NixOS base** with access to unstable packages.
- **Custom package definitions** and overlays.
- **Reusable NixOS and Home Manager modules** for easy sharing and maintenance.
- **Home Manager as a NixOS module**: Home Manager is integrated directly as a NixOS module, so user environments are rebuilt automatically whenever the system is rebuilt.
- **Modular host and user configuration** for flexibility and clarity.

## Structure

- `flake.nix`: Main flake entrypoint, defines inputs, outputs, overlays, modules, and system configurations.
- `packages/`: Custom package definitions.
- `overlays/`: Custom overlays for package modifications and additions.
- `modules/nixos/`: Reusable NixOS modules.
- `modules/home-manager/`: Reusable Home Manager modules.
- `nixos/host/lab/`: Example NixOS host configuration.
- `home-manager/user/syrax/`: Example Home Manager user configuration.

## Usage

### Requirements

- Nix 2.4+ with flakes enabled.
- NixOS 25.05 or compatible.

### Building and Applying the System

Since Home Manager is configured as a NixOS module, rebuilding the system will also update the user environment:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

### Custom Packages

Define custom packages in `packages/default.nix`. They are accessible via:

```sh
nix build .#<package-name>
nix shell .#<package-name>
```

### Overlays

- Add custom overlays in `overlays/default.nix`.
- Access unstable packages via `pkgs.unstable`.

### Modules

- Add reusable NixOS modules in `modules/nixos/`.
- Add reusable Home Manager modules in `modules/home-manager/`.

### Example Host Configuration

See `nixos/host/lab/default.nix` for a sample host setup.

### Example Home Manager Configuration

See `home-manager/user/syrax/home.nix` for a sample user environment.

## Quick installation for the `lab` host

1. **Perform a minimal NixOS installation**  
   Install NixOS with a minimal setup (no graphical environment) and create the user named `syrax` during the installation process.

2. **Boot and log in**  
   Start the machine and log in as the `syrax` user.

3. **Run the installation script**  
   Download and execute the installation script using `nix-shell` and `curl`:
   ```sh
   nix-shell -p curl --run "curl -fsSL https://raw.githubusercontent.com/ajmasia/nixos-config/main/install.sh | bash"
   ```
This will automatically apply the configuration for the `lab` host and the `syrax` user.

## License

This repository is licensed under the [MIT License](./LICENSE).
