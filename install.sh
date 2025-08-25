#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ajmasia/nixos-config.git"
CLONE_DIR="$HOME/.nixos-config"
HOST_NAME="lab" # Change this to your actual host flake name if needed

echo "Starting NixOS configuration installation for host '$HOST_NAME'..."

# Ensure nix-shell is available
if ! command -v nix-shell >/dev/null 2>&1; then
  echo "nix-shell is required but not found. Aborting."
  exit 1
fi

# Enter a nix shell with git
nix-shell -p git --run "
  # Clone the repo if not already present
  if [ ! -d \"$CLONE_DIR\" ]; then
    echo 'Cloning configuration repository...'
    git clone \"$REPO_URL\" \"$CLONE_DIR\"
  else
    echo 'Repository already exists at $CLONE_DIR, pulling latest changes...'
    echo 'Repo already cloned at $CLONE_DIR'
  fi
"

cd "$CLONE_DIR"

# Apply the configuration with flakes enabled
echo "Applying NixOS configuration using flakes..."
sudo nixos-rebuild switch --impure --flake "$CLONE_DIR#$HOST_NAME" --option experimental-features "nix-command flakes"

echo "NixOS configuration applied successfully!"
