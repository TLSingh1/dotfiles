# Hyprland keybindings configuration
{ hostname ? "default" }:

let
  # Import the special app script
  special_app = ../../../scripts/special_app.sh;
  special_workspace = appName: workspaceName: let
    checkCommand = "hyprctl clients | grep '${appName}'";
  in "${checkCommand} && hyprctl dispatch togglespecialworkspace ${workspaceName} || ${appName}";
  
  # Helper function to create bindings
  mkBind = mod: key: action: "${mod}, ${key}, ${action}";
  
  # Common bindings shared across all hosts
  commonBinds = {
    # Terminal
    "ALT, 36" = "exec, kitty";  # 36 = Return key
    
    # Browser
    "SUPER, L" = "exec, zen";  # Launch Zen browser
    
    # Special workspace toggles
    "ALT, Q" = "exec, ${special_app} kitty";
    "ALT, W" = "exec, ${special_app} zen";
    "ALT, E" = "exec, ${special_app} vesktop";
    "ALT, R" = "exec, ${special_workspace "slack" "slack"}";
    
    # Window management
    "ALT, 22" = "killactive,";  # 22 = Backspace
    "ALT, F" = "togglefloating,";
    "ALT, P" = "pseudo,";  # dwindle
    
    # Focus movement (vim-style)
    "ALT, h" = "movefocus, l";
    "ALT, l" = "movefocus, r";
    "ALT, j" = "movefocus, d";
    "ALT, k" = "movefocus, u";
    
    # Window resizing
    "ALT SHIFT, H" = "resizeactive, -40 0";
    "ALT SHIFT, L" = "resizeactive, 40 0";
    "ALT SHIFT, J" = "resizeactive, 0 40";
    "ALT SHIFT, K" = "resizeactive, 0 -40";
    
    # Special workspaces
    "ALT, m" = "movetoworkspacesilent, special";
    "ALT, s" = "togglespecialworkspace,";
    
    # Window movement
    "ALT CTRL, h" = "movewindoworgroup, l";
    "ALT CTRL, l" = "movewindoworgroup, r";
    "ALT CTRL, j" = "movewindoworgroup, d";
    "ALT CTRL, k" = "movewindoworgroup, u";
    
    # Grouping
    "ALT, G" = "togglegroup,";
    "ALT, tab" = "changegroupactive,";
    
    # Mouse workspace navigation
    "ALT, mouse_down" = "workspace, e+1";
    "ALT, mouse_up" = "workspace, e-1";
  };
  
  # Workspace switching binds
  workspaceBinds = builtins.listToAttrs (
    builtins.concatLists (
      builtins.genList (i:
        let ws = toString (i + 1);
        in [
          { name = "ALT, ${toString (i + 1)}"; value = "workspace, ${ws}"; }
          { name = "SUPER, ${toString (i + 1)}"; value = "movetoworkspace, ${ws}"; }
        ]
      ) 9
    ) ++ [
      { name = "ALT, 0"; value = "workspace, 10"; }
      { name = "SUPER, 0"; value = "movetoworkspace, 10"; }
    ]
  );
  
  # Mouse bindings (bindm)
  mouseBinds = {
    "ALT, mouse:272" = "movewindow";
    "ALT, mouse:273" = "resizewindow";
  };
  
  # Repeated bindings (binde)
  repeatingBinds = {
    "ALT CTRL, h" = "exec, hyprctl --batch 'dispatch movewindow l; dispatch moveactive -10 0'";
    "ALT CTRL, l" = "exec, hyprctl --batch 'dispatch movewindow r; dispatch moveactive 10 0'";
    "ALT CTRL, k" = "exec, hyprctl --batch 'dispatch movewindow u; dispatch moveactive 0 -10'";
    "ALT CTRL, j" = "exec, hyprctl --batch 'dispatch movewindow d; dispatch moveactive 0 10'";
  };
  
  # Host-specific bindings
  hostSpecificBinds = {
    "my-nixos" = {
      # Laptop-specific bindings
      "SUPER, 47" = "exec, wofi --show drun";  # 47 = semicolon
    };
    
    "nixos-desktop" = {
      # Desktop-specific bindings could go here
      "SUPER, 47" = "exec, rofi -show drun";  # Different launcher for desktop
    };
  };
  
  # Host-specific repeating bindings (binde)
  hostSpecificRepeatingBinds = {
    "my-nixos" = {
      # Workspace increment/decrement for laptop
      # "ALT, 59" = "workspace, +1";  # 59 = comma key
      # "ALT, 60" = "workspace, -1";  # 60 = period key
      "SUPER, j" = "workspace, +1";  # 59 = comma key
      "SUPER, k" = "workspace, -1";  # 60 = period key
    };
  };
in
{
  # Regular bindings
  bind = commonBinds // workspaceBinds // (hostSpecificBinds.${hostname} or {});
  
  # Mouse bindings
  bindm = mouseBinds;
  
  # Repeating bindings
  binde = repeatingBinds // (hostSpecificRepeatingBinds.${hostname} or {});
} 
