#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ajmasia/nixos-config.git"
CLONE_DIR="$HOME/.nixos-config"
HOST_NAME="lab" # Change this to your actual host flake name if needed

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting NixOS configuration installation for host '$HOST_NAME'...${NC}"

# Ensure nix-shell is available
if ! command -v nix-shell >/dev/null 2>&1; then
  echo "nix-shell is required but not found. Aborting."
  exit 1
fi

# Enter a nix shell with git
nix-shell -p git --run "
  # Clone the repo if not already present
  if [ ! -d \"$CLONE_DIR\" ]; then
    echo -e '${YELLOW}Cloning configuration repository...${NC}'
    git clone \"$REPO_URL\" \"$CLONE_DIR\"
  else
    echo -e '${YELLOW}Repository already exists at $CLONE_DIR, pulling latest changes...${NC}'
    echo -e '${YELLOW}Repo already cloned at $CLONE_DIR${NC}'
  fi
"

# Apply the configuration with flakes enabled
echo -e "${GREEN}Applying NixOS configuration using flakes...${NC}"

cd "$CLONE_DIR"
sudo nixos-rebuild switch --impure --flake "$CLONE_DIR#$HOST_NAME" --option experimental-features "nix-command flakes"

echo -e "${GREEN}NixOS configuration applied successfully!${NC}"
