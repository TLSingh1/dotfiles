#!/usr/bin/env bash

# Build the plugin using the same Hyprland as the system

echo "Building plugin with system Hyprland..."

# Build using your system flake's Hyprland
nix build .#workspace-preview \
  --override-input hyprland path:/home/tai/.dotfiles#hyprland \
  --override-input nixpkgs path:/home/tai/.dotfiles#nixpkgs

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Plugin location: $(pwd)/result/lib/workspace-preview.so"
else
    echo "Build failed!"
    exit 1
fi