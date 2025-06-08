{ config, pkgs, lib, ... }:

{
  # Enable dunst service through home-manager
  services.dunst = {
    enable = true;
    
    # Icon theme for notifications
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "32x32";
    };

    settings = {
      global = {
        # === Display ===
        monitor = 0;
        follow = "mouse";
        
        # === Geometry ===
        width = 400;
        height = 300;
        origin = "top-right";
        offset = "20x20";
        scale = 0;
        notification_limit = 5;
        
        # === Progress bar ===
        progress_bar = true;
        progress_bar_height = 12;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 6;
        
        # === Appearance ===
        transparency = 10;
        separator_height = 2;
        padding = 16;
        horizontal_padding = 16;
        text_icon_padding = 16;
        frame_width = 3;
        frame_color = "#ff9c64";
        gap_size = 8;
        separator_color = "frame";
        sort = "yes";
        
        # === Text ===
        font = "JetBrains Mono 11";
        line_height = 4;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "end";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        
        # === Icons ===
        enable_recursive_icon_lookup = true;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 64;
        icon_corner_radius = 8;
        
        # === History ===
        sticky_history = "yes";
        history_length = 20;
        
        # === Misc ===
        dmenu = "${pkgs.wofi}/bin/wofi --dmenu -p dunst";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 16;
        ignore_dbusclose = false;
        
        # === Mouse ===
        mouse_left_click = "close_current";
        mouse_middle_click = "context";
        mouse_right_click = "close_all";
      };

      # Holographic orange theme urgency levels
      urgency_low = {
        background = "#1a0f0a";
        foreground = "#ffd4b0";
        frame_color = "#ff9c6466";
        highlight = "#ff9c64";
        timeout = 5;
        
        # Subtle glow effect
        default_icon = "dialog-information";
      };

      urgency_normal = {
        background = "#1a0f0a";
        foreground = "#ffd4b0";
        frame_color = "#ff9c64";
        highlight = "#ffdc00";
        timeout = 10;
        
        # Medium glow
        default_icon = "dialog-information";
      };

      urgency_critical = {
        background = "#2a1510";
        foreground = "#ffdc00";
        frame_color = "#ff4500";
        highlight = "#ff1493";
        timeout = 0;
        
        # Intense glow
        default_icon = "dialog-warning";
      };

      # === Rules for specific applications ===
      
      # Volume/brightness notifications with progress bar
      volume = {
        appname = "volume";
        format = "<b>%s</b>";
        highlight = "#ffdc00";
        history_ignore = true;
        timeout = 2;
      };

      brightness = {
        appname = "brightness";
        format = "<b>%s</b>";
        highlight = "#ffdc00";
        history_ignore = true;
        timeout = 2;
      };

      # Music player notifications
      spotify = {
        appname = "Spotify";
        format = "<b>%s</b>\n%b";
        icon_position = "left";
        max_icon_size = 80;
        frame_color = "#ff9c64";
        background = "#1a0f0a";
        foreground = "#ffdc00";
        timeout = 5;
      };

      # System notifications
      networkmanager = {
        appname = "NetworkManager";
        format = "<b>%s</b>\n%b";
        frame_color = "#ff8c64";
        urgency = "normal";
      };

      # Git/Development notifications
      git = {
        appname = "git*";
        format = "<b>%s</b>\n<i>%b</i>";
        frame_color = "#ffdc00";
        background = "#2a1510";
      };

      # Calendar/Schedule
      calendar = {
        appname = "calendar";
        format = "<b>%s</b>\n%b";
        frame_color = "#ff64dc";
        background = "#1a0f0a";
        foreground = "#ffd4b0";
        timeout = 15;
      };

      # Download notifications
      download = {
        appname = "*download*";
        format = "<b>%s</b>\n%b";
        frame_color = "#ffa500";
        progress_bar_frame_color = "#ffa500";
      };

      # Screenshot notifications
      screenshot = {
        appname = "grimblast";
        format = "<b>Screenshot</b>\n%b";
        frame_color = "#ff64dc";
        background = "#2a1510";
        timeout = 3;
      };
    };
  };

  # Additional packages for enhanced functionality
  home.packages = with pkgs; [
    libnotify  # provides notify-send
    dunst      # ensures dunst binary is available
  ];

  # Create notification test scripts
  home.file.".local/bin/test-notifications" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      echo "Testing Dunst Orange Holographic Theme..."
      
      # Low urgency
      notify-send -u low "System Update" "5 packages can be upgraded"
      sleep 1
      
      # Normal urgency
      notify-send -u normal "New Message" "You have received a message from John Doe"
      sleep 1
      
      # Critical urgency
      notify-send -u critical "Battery Low" "10% remaining - Connect charger"
      sleep 1
      
      # With icon
      notify-send -i firefox "Firefox" "Download completed: document.pdf"
      sleep 1
      
      # Long text
      notify-send "Long Notification" "This is a very long notification message that should wrap properly and display multiple lines of text in the notification window. It demonstrates how dunst handles longer content."
      sleep 1
      
      # Progress bar simulation (volume)
      notify-send -h string:x-dunst-stack-tag:volume -h int:value:50 "Volume" "50%"
      sleep 0.5
      notify-send -h string:x-dunst-stack-tag:volume -h int:value:75 "Volume" "75%"
      sleep 0.5
      notify-send -h string:x-dunst-stack-tag:volume -h int:value:100 "Volume" "100%"
      
      echo "All tests completed!"
    '';
  };

  # Create advanced notification demos
  home.file.".local/bin/demo-notifications" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      # Music player simulation
      notify-send -i spotify \
        -a "Spotify" \
        "Now Playing" \
        "Holographic Dreams - Synthwave Artist\nAlbum: Neon Nights"
      
      sleep 2
      
      # Git commit notification
      notify-send -i git \
        -a "git" \
        "Commit Success" \
        "feat: Add orange holographic theme\n\n3 files changed, 127 insertions(+)"
      
      sleep 2
      
      # Calendar reminder
      notify-send -i calendar \
        -a "calendar" \
        -u critical \
        "Meeting in 15 minutes" \
        "Team Standup - Zoom Room 3\nClick to join meeting"
      
      sleep 2
      
      # Download progress
      for i in 25 50 75 100; do
        notify-send \
          -h string:x-dunst-stack-tag:download \
          -h int:value:$i \
          -a "download-manager" \
          "Downloading update.tar.gz" \
          "$i% - $(($i * 12)) MB / 1.2 GB"
        sleep 0.5
      done
      
      sleep 1
      
      # Screenshot
      notify-send -i camera \
        -a "grimblast" \
        "Screenshot captured" \
        "Saved to ~/Pictures/screenshot-2024.png"
    '';
  };
}