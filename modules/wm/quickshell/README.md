# Quickshell Module with Caelestia Shell

This module provides a complete Quickshell setup with the Caelestia shell configuration.

## Structure

- `default.nix` - Main module entry point
- `packages.nix` - Nix derivations for caelestia-scripts and quickshell wrapper
- `config.nix` - Configuration file management and environment setup
- `shell/` - The actual Caelestia shell QML configuration (editable)
- `config/` - User configuration files
  - `scripts.json` - Toggle workspace apps configuration
- `caelestia-completions.fish` - Fixed fish completions

## Customization

### Shell UI
Edit files in the `shell/` directory:
- `shell.qml` - Main entry point
- `modules/` - UI components (bar, dashboard, launcher, etc.)
- `widgets/` - Reusable widgets
- `config/` - Appearance and behavior settings

### Toggle Workspaces
Edit `config/scripts.json` to customize which apps open in special workspaces.

### Color Schemes
```bash
caelestia scheme <scheme-name>
```

Available schemes: catppuccin, gruvbox, rosepine, onedark, oldworld, shadotheme

## Commands

- `caelestia shell show dashboard/launcher/session` - Show specific UI
- `caelestia toggle <workspace>` - Toggle special workspaces
- `caelestia screenshot/record` - Screen capture
- `caelestia wallpaper` - Change wallpaper
- `caelestia clipboard/emoji-picker` - Utilities

## Service Management

```bash
systemctl --user status caelestia-shell   # Check status
systemctl --user restart caelestia-shell  # Restart
systemctl --user stop caelestia-shell     # Stop
```