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
  # Script files
  home.file = {
    ".config/hypr/hyprland/scripts/start_geoclue_agent.sh" = {
      source = ./scripts/start_geoclue_agent.sh;
      executable = true;
    };
    ".config/hypr/hyprland/scripts/fuzzel-emoji.sh" = {
      source = ./scripts/fuzzel-emoji.sh;
      executable = true;
    };
    ".config/hypr/hyprland/scripts/record.sh" = {
      source = ./scripts/record.sh;
      executable = true;
    };
  };
  
  # Hyprland-related packages
  home.packages = with pkgs; [
    # Launchers
    fuzzel # Primary launcher/picker
    wofi # Backup launcher
    
    # Screenshot & recording
    hyprshot # Advanced screenshot tool
    grimblast # Backup screenshot tool
    grim # Basic screenshot
    slurp # Region selector
    tesseract # OCR
    wf-recorder # Screen recording
    
    # Clipboard & color
    cliphist # Clipboard history
    wl-clipboard # Clipboard utilities
    hyprpicker # Color picker
    
    # Wallpaper & display
    swww # Wallpaper daemon
    gammastep # Color temperature
    geoclue2 # Location for gammastep
    brightnessctl # Brightness control
    
    # Lock & idle
    hypridle # Idle daemon
    hyprlock # Lock screen
    
    # Session
    wlogout # Power menu
    
    # File manager
    kdePackages.dolphin
    
    # Authentication
    polkit-kde-agent
    
    # Fonts and cursors
    bibata-cursors # Cursor theme
    noto-fonts-emoji # Emoji font
    
    # Utilities
    libnotify # For notify-send
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

      # CRITICAL: Global submap for dots-hyprland compatibility
      exec = "hyprctl dispatch submap global";
      submap = "global";
      
      # Import bindings from binds.nix
      bind = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.bind;
      bindm = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.bindm;
      binde = lib.mapAttrsToList (key: value: "${key}, ${value}") binds.binde;
      bindl = lib.mapAttrsToList (key: value: "${key}, ${value}") (binds.bindl or {});

      # General appearance from dots-hyprland
      general = {
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;
        border_size = 1;
        "col.active_border" = "rgba(0DB7D4FF)";
        "col.inactive_border" = "rgba(31313600)";
        resize_on_border = true;
        no_focus_fallback = true;
        allow_tearing = true; # This just allows the immediate window rule to work
        
        snap = {
          enabled = true;
        };
        
        layout = "dwindle";
      };

      decoration = {
        rounding = 18;
        
        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 14;
          passes = 3;
          brightness = 1;
          noise = 0.01;
          contrast = 1;
          popups = true;
          popups_ignorealpha = 0.6;
        };
        
        shadow = {
          enabled = true;
          ignore_window = true;
          range = 30;
          offset = [0, 2];
          render_power = 4;
          color = "rgba(00000010)";
        };
        
        # Dim inactive windows
        dim_inactive = true;
        dim_strength = 0.025;
        dim_special = 0.07;
      };

      animations = animations;

      dwindle = {
        preserve_split = true;
        smart_split = false;
        smart_resizing = false;
      };

      input = {
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.5;
        };
        
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 700;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_fingers = true;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = 1;
        vrr = 1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = false;
        swallow_regex = "(foot|kitty|allacritty|Alacritty)";
        new_window_takes_over_fullscreen = 2;
        allow_session_lock_restore = true;
        initial_workspace_tracking = false;
        focus_on_activate = true;
      };
      
      binds = {
        scroll_event_delay = 0;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        inactive_timeout = 5;
        hide_on_key_press = true;
        hide_on_touch = true;
        default_monitor = "";
      };

      windowrulev2 = [
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

      # Autostart applications from dots-hyprland
      exec-once = [
        # Wallpaper daemon and initial wallpaper
        "swww-daemon --format xrgb --no-cache"
        "sleep 0.5; mkdir -p ~/.config/wallpapers && [ -f ~/.config/wallpapers/default.jpg ] && swww img ~/.config/wallpapers/default.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1"
        
        # Color temperature
        "~/.config/hypr/hyprland/scripts/start_geoclue_agent.sh & gammastep"
        
        # Core components
        "gnome-keyring-daemon --start --components=secrets"
        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        "hypridle"
        "dbus-update-activation-environment --all"
        "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        
        # Clipboard history
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        
        # Set cursor theme
        "hyprctl setcursor Bibata-Modern-Classic 24"
        
        # Start AGS if enabled
        # "cd ${config.home.homeDirectory}/.dotfiles/modules/wm/ags/config && ags run --gtk4 ./app.ts"
        
        # Quickshell will be started here later
        # "qs &"
      ];
    };
  };
}
