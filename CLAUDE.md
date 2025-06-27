# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS dotfiles repository using flakes for declarative system and user configuration management. The repository follows a modular architecture with clear separation between system-level and user-level configurations.

## Essential Commands

### System Management

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake .

# Test configuration without making it default
sudo nixos-rebuild test --flake .

# Build configuration without switching
sudo nixos-rebuild build --flake .

# Update all flake inputs
nix flake update

# Update specific input
nix flake update <input-name>

# Check flake validity
nix flake check

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Garbage collection
sudo nix-collect-garbage -d
```

### Development Workflow

```bash
# Preview changes before applying
nixos-rebuild build --flake . && nvd diff /run/current-system result

# Format Nix files
nix fmt

# Search for packages
nix search nixpkgs <package-name>
```

## Architecture

### Directory Structure

- `flake.nix` - Main entry point defining hosts, inputs, and system configurations
- `hosts/` - Host-specific configurations
  - `my-nixos/` - Primary host configuration
- `home/` - User configurations
  - `tai/home.nix` - Main user config that conditionally imports modules based on hostname
- `modules/` - Reusable configuration modules
  - `wm/` - Window manager modules (Hyprland, AGS, Quickshell)
  - `gui/` - GUI application modules
  - `tui/` - Terminal application modules
- `overlays/` - Custom package overlays
- `scripts/` - Utility scripts

### Module System

Modules are organized by type and imported conditionally in `home/tai/home.nix` based on the current hostname. This allows different configurations for different machines while sharing common modules.

Example module structure:

```nix
{ config, pkgs, lib, ... }:
{
  # Module options and configuration
}
```

### Adding New Modules

1. Create module file in appropriate directory (`modules/gui/`, `modules/tui/`, etc.)
2. Import in `home/tai/home.nix` within the appropriate hostname condition
3. Rebuild system with `sudo nixos-rebuild switch --flake .`

### Key Configuration Files

- `flake.nix` - Defines inputs, outputs, and nixosConfigurations
- `hosts/my-nixos/configuration.nix` - System-level settings (hardware, networking, services)
- `home/tai/home.nix` - User environment configuration with conditional module imports
- `modules/*/default.nix` - Individual application/service configurations

## Important Patterns

### Conditional Module Loading

Modules are loaded based on hostname in `home/tai/home.nix`:

```nix
imports =
  if hostname == "my-nixos" then [
    # Desktop modules
  ] else if hostname == "laptop" then [
    # Laptop modules
  ] else [];
```

### Package Overlays

Custom packages or modifications are defined in `overlays/` and applied in `flake.nix`.

### Multi-Host Support

Different hosts can have entirely different module sets while sharing common configurations. The hostname-based conditional imports allow flexible per-machine customization.

## Testing Changes

Always test configuration changes before applying:

1. Build first: `nixos-rebuild build --flake .`
2. Compare changes: `nvd diff /run/current-system result`
3. If satisfied: `sudo nixos-rebuild switch --flake .`

## Troubleshooting

- Check logs: `journalctl -xe`
- List generations: `sudo nix-env --list-generations --profile /nix/var/nix/profiles/system`
- Rollback: `sudo nixos-rebuild switch --rollback`
- Detailed errors: Add `--show-trace` to nixos-rebuild commands

