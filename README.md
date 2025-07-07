# Modular NixOS Configuration

This repository contains a modular NixOS configuration that supports multiple hosts and separates concerns into logical modules.

## Documentation

See the [docs/](docs/) directory for complete documentation:

- **[Documentation Index](docs/README.md)** - Start here
- **[Daily Operations](docs/01-daily-operations.md)** - Essential commands
- **[Host Management](docs/02-host-management.md)** - Multiple machines
- **[User Management](docs/03-user-management.md)** - Multiple users
- **[Package Management](docs/04-package-management.md)** - Installing software
- **[Module Creation](docs/05-module-creation.md)** - Creating modules

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles

# Build and switch to configuration
sudo nixos-rebuild switch --flake .

# Update packages
nix flake update
```

## Directory Structure

```
.dotfiles/
├── flake.nix           # Entry point - defines all hosts
├── flake.lock          # Pinned dependencies
├── hosts/              # Host-specific configurations
│   └── my-nixos/       # Per-machine settings
├── modules/            # Reusable configuration modules
│   ├── wm/            # Window managers
│   ├── gui/           # GUI applications
│   └── tui/           # Terminal applications
├── home/              # User configurations
│   └── tai/           # Per-user settings
└── docs/              # Documentation
```

## Key Commands

| Task            | Command                                |
| --------------- | -------------------------------------- |
| Rebuild         | `sudo nixos-rebuild switch --flake .`  |
| Update          | `nix flake update`                     |
| Rollback        | `sudo nixos-rebuild switch --rollback` |
| Garbage collect | `sudo nix-collect-garbage -d`          |

## Adding to This Configuration

- **New host?** See [Host Management](docs/02-host-management.md)
- **New user?** See [User Management](docs/03-user-management.md)
- **New package?** See [Package Management](docs/04-package-management.md)
- **New module?** See [Module Creation](docs/05-module-creation.md)

## Directory Structure

```
.dotfiles/
├── flake.nix           # Main flake configuration
├── flake.lock          # Flake lock file
├── hosts/              # Host-specific configurations
│   └── my-nixos/       # Configuration for "my-nixos" host
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/            # Reusable modules
│   ├── wm/            # Window managers
│   │   └── hyprland/  # Hyprland configuration
│   │       ├── default.nix  # System-level config
│   │       └── home.nix     # User-level config
│   ├── gui/           # GUI applications
│   │   ├── browsers/  # Web browsers
│   │   └── 1password/ # Password manager
│   └── tui/           # Terminal UI applications
│       ├── nvim/      # Neovim configuration
│       ├── kitty/     # Kitty terminal
│       ├── cli-tools/ # Command-line utilities
│       ├── git/       # Git configuration
│       └── starship/  # Shell prompt
└── home/              # User-specific configurations
    └── tai/           # Configuration for user "tai"
        └── home.nix   # Home-manager configuration
```

## Quick Start

### Building and Switching

To build and switch to the configuration:

```bash
sudo nixos-rebuild switch --flake .#my-nixos
```

Or let it auto-detect your hostname:

```bash
sudo nixos-rebuild switch --flake .
```

### Adding a New Host

See the [Multiple Hosts Guide](docs/multiple-hosts-guide.md) for detailed instructions on adding new machines.

### Adding New Modules

1. Create a new directory under the appropriate category in `modules/`
2. Add a `default.nix` file with your module configuration
3. For home-manager modules, you may also add a `home.nix` file
4. Import the module in either host configuration or user home configuration

## Module Categories

- **wm/**: Window managers and desktop environments
- **gui/**: Graphical applications
- **tui/**: Terminal-based applications and tools

## Key Features

- Modular design for easy maintenance and reusability
- Support for multiple hosts
- Separation of system and user configurations
- Organized by application type (GUI/TUI/WM)

