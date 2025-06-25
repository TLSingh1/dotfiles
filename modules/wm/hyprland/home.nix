{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  # Import the binds configuration with the current hostname
  binds = import ./binds.nix {
    hostname = osConfig.networking.hostName or "default";
  };

  # Import animations configuration
  animations = import ./animations.nix;
in {
  # Hyprland-related packages
  home.packages = with pkgs; [
    wofi # application launcher
    grimblast # screenshot tool
    waybar # status bar
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
        # Samsung Odyssey G5 (top)
        "eDP-1, 1920x1200@144, 0x0, 1.0"
        "DP-1, 2560x1440@164, 1920x0, 1.0"
        # Laptop display (bottom)
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
        gaps_in = 8;
        gaps_out = 18;
        border_size = 3;
        # Blue holographic theme (original)
        # "col.active_border" = "rgba(ff00ffee) rgba(00ffffff) rgba(ff00aaee) rgba(7700ffee) rgba(00eeffee) 45deg";
        # "col.inactive_border" = "rgba(ff00ff44)";

        # Orange holographic theme (commented)
        # "col.active_border" = "rgba(ff4500ff) rgba(ffee00ff) rgba(ff1493ff) rgba(ff6b00ff) rgba(ffd700ff) 45deg";
        # "col.inactive_border" = "rgba(ff450033)";

        # Material You 3 cyan/teal theme with enhanced variance
        "col.active_border" = "rgba(5eead4ff) rgba(d8709aff) rgba(2dd4bfff) rgba(c084fcff) rgba(38bdf8ff) rgba(34d399ff) rgba(f4b8ccff) rgba(7dd3c0ff) 270deg";
        "col.inactive_border" = "rgba(00000000)";
        layout = "dwindle";
        resize_on_border = true;
        extend_border_grab_area = 15;
        hover_icon_on_border = false;
      };

      decoration = {
        rounding = 20;
        # rounding_power = 0.1;
        blur = {
          enabled = true;
          xray = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
        shadow = {
          enabled = false;
          range = 25; # Increased for active window emphasis
          render_power = 3; # Balanced shadow strength
          color = "rgba(7dd3c055)"; # Teal shadow with lower opacity
          # offset = "0 5"; # Slight downward offset for depth
          scale = 1.0;
        };
        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # col.shadow = "rgba(1a1a1aee)";
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

      cursor = {
        inactive_timeout = 5;
      };

      windowrulev2 = [
        # Quickshell cyberpunk rules
        "noanim,class:^(quickshell)$"
        
        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"

        # Qalculate-gtk
        "float,class:(qalculate-gtk)"
        "workspace special:calculator,class:(qalculate-gtk)"

        # Kitty
        "float,noblur,class:(kitty-bg)"
        # "noblur,float,noinitialfocus,pin,fullscreen,class:(kitty-bg)"
        # "float,title:(fly_is_kitty)"
        # "size 600 400,title:(fly_is_kitty)"
        # "workspace special:terminal, title:(fly_is_kitty)"

        # Discord
        "float,class:(discord)"
        "size 1200 700,class:(discord)"
        "move 26.5% 25%,class:(discord)"
        "workspace special:discord, class:(discord)"

        # Telegram
        "float,class:(org.telegram.desktop)"
        "size 800 400,class:(org.telegram.desktop)"
        "center,class:(org.telegram.desktop)"
        "workspace special:telegram, class:(org.telegram.desktop)"

        # Zen browser
        "opacity 0.85 0.85,class:(zen)"

        # Vesktop
        "float,class:(vesktop)"
        "size 1500 900,class:(vesktop)"
        "center,class:(vesktop)"
        "workspace special:vesktop, class:(vesktop)"

        # Slack
        "float,class:(Slack)"
        "size 1500 900,class:(Slack)"
        "center,class:(Slack)"
        "workspace special:slack, class:(Slack)"
      ];

      workspace = [
        # Laptop display workspaces
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
        "4, monitor:eDP-1"
        "5, monitor:eDP-1"
        # Samsung Odyssey G5 workspaces
        "6, monitor:DP-1"
        "7, monitor:DP-1"
        "8, monitor:DP-1"
        "9, monitor:DP-1"
        "10, monitor:DP-1"
      ];

      # Autostart applications
      exec-once = [
        # "cd ${config.home.homeDirectory}/.dotfiles/modules/wm/ags/config && ags run --gtk4 ./app.ts" # Start AGS bar
        "swww-daemon" # Wallpaper daemon for dynamic theming
      ];
      
      # Source dynamic theme file if it exists
      source = [
        "~/.config/hypr/theme.conf"
      ];
    };
  };
}
