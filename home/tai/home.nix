{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  hostname = osConfig.networking.hostName or "unknown";
in {
  home.username = "tai";
  home.homeDirectory = "/home/tai";

  imports =
    [
      # Core modules - always loaded on all hosts
      ../../modules/tui/cli-tools
      ../../modules/tui/git
      ../../modules/tui/ssh
      ../../modules/tui/scripts
      ../../modules/tui/starship
      ../../modules/tui/fish
    ]
    ++ lib.optionals (hostname == "my-nixos") [
      # Personal laptop modules
      ../../modules/wm/hyprland/home.nix
      ../../modules/wm/ags
      ../../modules/wm/quickshell
      ../../modules/wm/dunst
      ../../modules/tui/nvim
      ../../modules/tui/kitty
      ../../modules/gui/apps
      ../../modules/gui/zen-browser
      ../../modules/gui/1password
      ../../modules/gui/claude-desktop
      ../../modules/gui/vesktop
      ../../modules/tui/ghostty
    ]
    ++ lib.optionals (hostname == "nixos-desktop") [
      # Desktop specific modules
      ../../modules/wm/hyprland/home.nix
      ../../modules/wm/dunst
      ../../modules/tui/nvim
      ../../modules/tui/kitty
      ../../modules/gui/apps
      ../../modules/gui/zen-browser
      ../../modules/gui/1password
      ../../modules/gui/claude-desktop
      ../../modules/gui/vesktop
      ../../modules/tui/ghostty
      # Could add desktop-specific modules here:
      # ../../modules/gui/steam
      # ../../modules/gui/obs
      # ../../modules/gui/discord
    ]
    ++ lib.optionals (hostname == "work-laptop") [
      # Work laptop modules (example)
      ../../modules/tui/nvim
      ../../modules/tui/kitty
      ../../modules/gui/apps
      ../../modules/gui/zen-browser
      ../../modules/gui/claude-desktop
      ../../modules/tui/ghostty
      # Work-specific modules:
      # ../../modules/gui/slack
      # ../../modules/gui/teams
      # ../../modules/dev/docker
      # ../../modules/dev/kubernetes
    ]
    ++ lib.optionals (hostname == "server") [
      # Server modules - minimal GUI
      ../../modules/tui/nvim
      # Server-specific modules:
      # ../../modules/tui/tmux
      # ../../modules/tui/monitoring
      # ../../modules/tui/server-utils
    ];

  home.shellAliases =
    {
      rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles";
    }
    // lib.optionalAttrs (hostname == "server") {
      # Server-specific aliases
      logs = "journalctl -f";
      restart-nginx = "sudo systemctl restart nginx";
    }
    // lib.optionalAttrs (hostname == "work-laptop") {
      # Work-specific aliases
      vpn = "sudo openvpn /etc/openvpn/work.conf";
      k = "kubectl";
    };

  # Host-specific environment variables
  home.sessionVariables =
    {
      EDITOR = "nvim";
    }
    // lib.optionalAttrs (hostname == "work-laptop") {
      DOCKER_HOST = "tcp://localhost:2375";
      KUBECONFIG = "$HOME/.kube/config";
    };

  home.stateVersion = "25.05";
}

