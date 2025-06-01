# AGS Desktop Environment

A modular desktop environment built with AGS (Aylur's Gtk Shell) and Astal.

## Features (Planned)

- **Clock Widget**: Simple time and date display (implemented)
- **App Launcher**: Application runner with search and categorization
- **Status Bar**: Vertical bar with workspace indicators and system tray
- **Notifications**: Integrated notification display
- **System Stats**: Resource monitoring widgets

## Development

### Prerequisites

- NixOS with flakes enabled
- Hyprland window manager

### Setup

1. Enter the development shell:

```bash
cd modules/wm/ags
nix develop
```

2. Initialize AGS types (if not already done):

```bash
ags init -d ./src
```

3. Run in development mode:

```bash
cd src
ags run app.ts
```

### Building

Build the bundled package:

```bash
nix build
```

### Project Structure

```
ags/
├── src/
│   ├── app.ts          # Entry point
│   ├── widgets/        # UI components
│   ├── services/       # State management
│   ├── lib/           # Utilities
│   └── styles/        # SCSS styles
├── flake.nix          # Nix flake configuration
└── default.nix        # NixOS module
```

### Adding to Your Configuration

In your home-manager configuration:

```nix
{ inputs, ... }:
{
  imports = [
    ./modules/wm/ags
  ];

  programs.ags-desktop.enable = true;
}
```

## Customization

### Styling

Edit `src/styles/main.scss` to customize the appearance. The project uses SCSS for styling with support for:

- Variables
- Nesting
- Mixins
- Functions

### Adding Widgets

1. Create a new widget in `src/widgets/YourWidget/index.tsx`
2. Import and instantiate it in `src/app.ts`
3. Add corresponding styles in `src/styles/`

## Roadmap

- [x] Basic project structure
- [x] Clock widget
- [ ] App launcher with search
- [ ] Status bar with animations
- [ ] Notification integration
- [ ] System resource monitoring
- [ ] Multi-monitor support
- [ ] Configuration system
