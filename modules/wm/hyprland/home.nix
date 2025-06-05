{ config, pkgs, inputs, lib, osConfig, ... }:

let
  # Import the binds configuration with the current hostname
  binds = import ./binds.nix {
    hostname = osConfig.networking.hostName or "default";
  };
  
  # Import animations configuration
  animations = import ./animations.nix;
in
{
  # Hyprland-related packages
  home.packages = with pkgs; [
    wofi # application launcher
    grimblast # screenshot tool
    waybar # status bar
    dunst # notification daemon
    wl-clipboard # clipboard utilities
    swww # wallpaper daemon
    kdePackages.dolphin # file manager
  ];

  # Hyprland home configuration
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    xwayland.enable = true;
    # xwayland.forceZeroScaling = true;
        
    # Import environment variables for systemd services
    systemd.variables = ["--all"];

    settings = {
      # Monitor configuration
      monitor = [
        "eDP-1, 1920x1200@144, 0x0, 1.0"
      ];

      # Variables
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun";
      
      # Import bindings from binds.nix
      bind = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.bind;
      bindm = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.bindm;
      binde = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.binde;

      # Basic appearance
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
      };

      animations = animations;

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      xwayland = {
        force_zero_scaling = true;
      };
      
      # Autostart applications
      exec-once = [
        # "cd ${config.home.homeDirectory}/.dotfiles/modules/wm/ags/config && ags run --gtk4 ./app.ts"  # Start AGS bar
        "swww-daemon"  # Wallpaper daemon
      ];
    };
  };
} 
