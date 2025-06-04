# Hyprland Workspace Preview Plugin

A Hyprland plugin that provides workspace preview functionality for AGS and other external applications.

## Development Setup (NixOS)

### Using Nix Flake (Recommended)
```bash
# Enter development shell
nix develop

# Build the plugin
nix build

# Or use make directly
make
```

### Manual Build
```bash
# Ensure you have Hyprland headers installed
make all
```

## Testing

### In a Nested Hyprland Session
```bash
# Start nested Hyprland (from this directory)
nix develop -c Hyprland

# In another terminal, load the plugin
hyprctl plugin load /path/to/workspace-preview.so
```

### In Your Main Session (Careful!)
```bash
# Build first
nix build

# Load the plugin
hyprctl plugin load ./result/lib/workspace-preview.so

# Unload if needed
hyprctl plugin unload workspace-preview.so
```

## Configuration

Add to your Hyprland config:
```conf
# Enable/disable the plugin
plugin:workspace-preview:enabled = 1

# Preview scale (0.1 - 1.0)
plugin:workspace-preview:scale = 0.2
```

## Architecture

1. **Phase 1** (Current): Basic plugin that hooks workspace and render events
2. **Phase 2**: Capture workspace framebuffers during render
3. **Phase 3**: Export preview data via Unix socket
4. **Phase 4**: AGS integration to display previews

## IPC Protocol (Planned)

The plugin will expose workspace previews via Unix socket at `/tmp/hyprland-workspace-preview.sock`.

### Message Format
```
{
  "type": "preview_request",
  "workspace_id": 1
}
```

### Response Format
```
{
  "type": "preview_data",
  "workspace_id": 1,
  "width": 384,
  "height": 216,
  "format": "rgba",
  "data": "base64..."
}
```