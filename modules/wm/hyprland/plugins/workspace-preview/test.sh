#!/usr/bin/env bash

# Test script for the workspace preview plugin

echo "Starting nested Hyprland session for plugin testing..."
echo "Once Hyprland starts, open a new terminal and run:"
echo ""
echo "  hyprctl plugin load $(pwd)/result/lib/workspace-preview.so"
echo ""
echo "Then check for notifications and try switching workspaces"
echo ""

# Start nested Hyprland
Hyprland