# Hyprland keybindings configuration with dots-hyprland integration
{hostname ? "default"}: let
  # Import the special app script
  special_app = ../../../scripts/special_app.sh;

  # Common bindings based on dots-hyprland
  commonBinds = {
    # CRITICAL: Submap configuration - must be first!
    "Super, Super_L" = "exec, qs ipc call overview toggleReleaseInterrupt 2>/dev/null || pkill fuzzel || fuzzel";

    # Overview and launcher toggles
    "Super, 47" = "exec, qs ipc call overview toggle 2>/dev/null";
    "Super, V" = "exec, qs ipc call overview toggle 2>/dev/null || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy";
    "Super, Period" = "exec, qs ipc call overview toggle 2>/dev/null || pkill fuzzel || ~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy";

    # Sidebar toggles
    "Super, A" = "exec, qs ipc call sidebarLeftToggle 2>/dev/null";
    "Super, N" = "exec, qs ipc call sidebarRight toggle 2>/dev/null";

    # Widget toggles
    "Super, Slash" = "exec, qs ipc call cheatsheetToggle 2>/dev/null";
    "Super, K" = "exec, qs ipc call oskToggle 2>/dev/null";
    "Super, M" = "exec, qs ipc call mediaControlsToggle 2>/dev/null";
    "Ctrl+Alt, Delete" = "exec, qs ipc call sessionToggle 2>/dev/null || pkill wlogout || wlogout -p layer-shell";

    # Terminal (your existing)
    "ALT, Return" = "exec, kitty";
    "Super, Return" = "exec, kitty";

    # Browser (your existing)
    "SUPER, L" = "exec, zen";

    # Screenshot and utilities from dots-hyprland
    "Super+Shift, S" = "exec, qs -p ~/.config/quickshell/screenshot.qml 2>/dev/null || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent";
    "Super+Shift, T" = "exec, grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\""; # OCR
    "Super+Shift, C" = "exec, hyprpicker -a"; # Color picker
    ", Print" = "exec, grim - | wl-copy"; # Fullscreen screenshot
    "Ctrl, Print" = "exec, mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png";

    # Recording
    "Super+Alt, R" = "exec, ~/.config/hypr/hyprland/scripts/record.sh";
    "Ctrl+Alt, R" = "exec, ~/.config/hypr/hyprland/scripts/record.sh --fullscreen";
    "Super+Shift+Alt, R" = "exec, ~/.config/hypr/hyprland/scripts/record.sh --fullscreen-sound";

    # Window management (keeping your existing + dots-hyprland)
    "ALT, BackSpace" = "killactive,";
    "Super, Q" = "killactive,";
    "Alt, F4" = "killactive,";
    "Super+Shift+Alt, Q" = "exec, hyprctl kill";

    # Floating and fullscreen
    "ALT, F" = "togglefloating,";
    "Super+Alt, Space" = "togglefloating,";
    "Super, D" = "fullscreen, 1"; # Maximize
    "Super, F" = "fullscreen, 0"; # Fullscreen
    "Super+Alt, F" = "fullscreenstate, 0 3"; # Fullscreen spoof
    "Super, P" = "pin"; # Pin window

    # Focus movement (dots-hyprland style)
    "ALT, h" = "movefocus, l";
    "ALT, l" = "movefocus, r";
    "ALT, k" = "movefocus, u";
    "ALT, j" = "movefocus, d";

    # Window movement
    "Super+Shift, Left" = "movewindow, l";
    "Super+Shift, Right" = "movewindow, r";
    "Super+Shift, Up" = "movewindow, u";
    "Super+Shift, Down" = "movewindow, d";

    # Your special workspace functionality
    "ALT, Q" = "exec, ${special_app} kitty";
    "ALT, W" = "exec, ${special_app} zen";
    "ALT, E" = "exec, ${special_app} vesktop";

    # Special workspaces
    "ALT, m" = "movetoworkspacesilent, special";
    "ALT, s" = "togglespecialworkspace,";

    # Wallpaper and restart
    "Ctrl+Super, T" = "exec, ~/.config/quickshell/scripts/colors/switchwall.sh";
    "Ctrl+Super, R" = "exec, killall ags agsv1 gjs ydotool qs quickshell; qs &";

    # Audio controls (mute)
    "Super+Shift, M" = "exec, wpctl set-mute @DEFAULT_SINK@ toggle";
    "Super+Alt, M" = "exec, wpctl set-mute @DEFAULT_SOURCE@ toggle";

    # Monitor controls
    "Super+Shift, bracketleft" = "exec, hyprctl dispatch movecurrentworkspacetomonitor -1";
    "Super+Shift, bracketright" = "exec, hyprctl dispatch movecurrentworkspacetomonitor +1";
    "Super+Alt, bracketleft" = "exec, hyprctl dispatch focusmonitor -1";
    "Super+Alt, bracketright" = "exec, hyprctl dispatch focusmonitor +1";
  };

  # Hidden bindings for global submap system (critical!)
  hiddenBinds = {
    "Ctrl, Super_L" = "pass, ^(quickshell)$";
    "Super, mouse:272" = "pass, ^(quickshell)$";
    "Super, mouse:273" = "pass, ^(quickshell)$";
    "Super, mouse:274" = "pass, ^(quickshell)$";
    "Super, mouse:275" = "pass, ^(quickshell)$";
    "Super, mouse:276" = "pass, ^(quickshell)$";
    "Super, mouse_up" = "pass, ^(quickshell)$";
    "Super, mouse_down" = "pass, ^(quickshell)$";
  };

  # Workspace switching binds
  workspaceBinds = builtins.listToAttrs (
    builtins.concatLists (
      builtins.genList (
        i: let
          ws = toString (i + 1);
        in [
          {
            name = "ALT, ${toString (i + 1)}";
            value = "workspace, ${ws}";
          }
          {
            name = "Super, ${toString (i + 1)}";
            value = "workspace, ${ws}";
          }
          {
            name = "SUPER+Shift, ${toString (i + 1)}";
            value = "movetoworkspace, ${ws}";
          }
        ]
      )
      9
    )
    ++ [
      {
        name = "ALT, 0";
        value = "workspace, 10";
      }
      {
        name = "Super, 0";
        value = "workspace, 10";
      }
      {
        name = "SUPER+Shift, 0";
        value = "movetoworkspace, 10";
      }
    ]
  );

  # Mouse bindings (bindm)
  mouseBinds = {
    "Super, mouse:272" = "movewindow";
    "Super, mouse:273" = "resizewindow";
    "ALT, mouse:272" = "movewindow";
    "ALT, mouse:273" = "resizewindow";
  };

  # Repeating bindings (binde)
  repeatingBinds = {
    # Window split ratio
    # "Super, Semicolon" = "splitratio, -0.1";
    # "Super, Apostrophe" = "splitratio, +0.1";

    # Volume controls
    ", XF86AudioRaiseVolume" = "exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+";
    ", XF86AudioLowerVolume" = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";

    # Brightness controls
    ", XF86MonBrightnessUp" = "exec, qs ipc call brightness increment 2>/dev/null || brightnessctl s 5%+";
    ", XF86MonBrightnessDown" = "exec, qs ipc call brightness decrement 2>/dev/null || brightnessctl s 5%-";

    # Window resizing
    "ALT SHIFT, H" = "resizeactive, -40 0";
    "ALT SHIFT, L" = "resizeactive, 40 0";
    "ALT SHIFT, J" = "resizeactive, 0 40";
    "ALT SHIFT, K" = "resizeactive, 0 -40";
  };

  # Locked bindings (bindl) - work even when locked
  lockedBinds = {
    ", XF86AudioMute" = "exec, wpctl set-mute @DEFAULT_SINK@ toggle";
    "Alt, XF86AudioMute" = "exec, wpctl set-mute @DEFAULT_SOURCE@ toggle";
    ", XF86AudioMicMute" = "exec, wpctl set-mute @DEFAULT_SOURCE@ toggle";
  };

  # Host-specific bindings
  hostSpecificBinds = {
    "my-nixos" = {
      # Laptop-specific workspace navigation
      "ALT, comma" = "workspace, -1";
      "ALT, period" = "workspace, +1";
    };

    "nixos-desktop" = {
      # Desktop-specific bindings
    };
  };
in {
  # Regular bindings
  bind = commonBinds // workspaceBinds // hiddenBinds // (hostSpecificBinds.${hostname} or {});

  # Mouse bindings
  bindm = mouseBinds;

  # Repeating bindings
  binde = repeatingBinds;

  # Locked bindings
  bindl = lockedBinds;
}

