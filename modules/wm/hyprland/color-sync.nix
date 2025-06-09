{ config, pkgs, lib, ... }:

let
  # Script to sync colors from caelestia to hyprland
  hyprland-color-sync = pkgs.writeShellScriptBin "hyprland-color-sync" ''
    #!/usr/bin/env bash
    
    # Color scheme file
    SCHEME_FILE="$HOME/.local/state/caelestia/scheme/current.txt"
    
    # Watch for changes and apply colors
    apply_colors() {
      if [ ! -f "$SCHEME_FILE" ]; then
        echo "Color scheme file not found: $SCHEME_FILE"
        return 1
      fi
      
      # Read colors from the scheme file
      declare -A colors
      while IFS=' ' read -r name value; do
        colors[$name]="$value"
      done < "$SCHEME_FILE"
      
      # Extract specific colors for borders
      primary="''${colors[blue]:-83a598}"
      secondary="''${colors[green]:-b8bb26}"
      tertiary="''${colors[yellow]:-fabd2f}"
      accent="''${colors[pink]:-d24cce}"
      inactive="''${colors[overlay0]:-7c6f64}"
      
      # Apply active border gradient
      ${pkgs.hyprland}/bin/hyprctl keyword general:col.active_border \
        "rgba(''${primary}ff) rgba(''${secondary}ff) rgba(''${tertiary}ff) rgba(''${accent}ff) 45deg"
      
      # Apply inactive border
      ${pkgs.hyprland}/bin/hyprctl keyword general:col.inactive_border \
        "rgba(''${inactive}99)"
      
      # Apply shadow color (using primary with transparency)
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:shadow:color \
        "rgba(''${primary}66)"
      
      echo "Applied color scheme to Hyprland"
      
      # Also update Neovim colors if the command exists
      if command -v update-nvim-colors >/dev/null 2>&1; then
        echo "Updating Neovim colors..."
        update-nvim-colors
      fi
    }
    
    # Initial application
    apply_colors
    
    # Watch for changes
    echo "Watching for color scheme changes..."
    ${pkgs.inotify-tools}/bin/inotifywait -m -e modify "$SCHEME_FILE" |
    while read -r directory event file; do
      echo "Color scheme changed, applying to Hyprland..."
      sleep 0.1  # Small delay to ensure file is fully written
      apply_colors
    done
  '';
in
{
  # Install the sync script
  home.packages = [ hyprland-color-sync ];
  
  # Create a systemd service to run the sync
  systemd.user.services.hyprland-color-sync = {
    Unit = {
      Description = "Sync Caelestia colors to Hyprland";
      After = [ "graphical-session.target" "caelestia-shell.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${hyprland-color-sync}/bin/hyprland-color-sync";
      Restart = "on-failure";
      RestartSec = 5;
    };
    
    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
  
  # Also update the static Hyprland config to use neutral colors initially
  # These will be overridden by the sync service
  wayland.windowManager.hyprland.settings = {
    general = {
      "col.active_border" = lib.mkForce "rgba(83a598ff) rgba(b8bb26ff) rgba(fabd2fff) rgba(d24cceff) 45deg";
      "col.inactive_border" = lib.mkForce "rgba(7c6f6499)";
    };
    
    decoration = {
      shadow = {
        color = lib.mkForce "rgba(83a59866)";
      };
    };
  };
}