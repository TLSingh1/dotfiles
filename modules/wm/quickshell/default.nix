{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Quickshell package and basic configuration
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell from flake input
    
    # Qt dependencies
    qt5.qtgraphicaleffects # For Qt5Compat.GraphicalEffects
    
    # Dependencies that quickshell widgets might need
    translate-shell # For translator widget
    ydotool # For keyboard/mouse simulation
    jq # JSON processing
    socat # Socket communication
    
    # Python for various scripts
    (python3.withPackages (ps: with ps; [
      requests
      pillow
    ]))
  ];
  
  # Copy the quickshell configuration
  home.file.".config/quickshell" = {
    source = ./config;
    recursive = true;
  };
  
  # Create required directories and files
  home.file.".local/state/quickshell/user/generated/colors.json" = {
    text = ''
      {
        "primaryContainer": "#1a1a1a",
        "onPrimaryContainer": "#ffffff",
        "primary": "#0DB7D4",
        "onPrimary": "#000000",
        "secondary": "#7dd3c0",
        "onSecondary": "#000000",
        "surface": "#1a1a1a",
        "onSurface": "#ffffff",
        "surfaceVariant": "#2a2a2a",
        "onSurfaceVariant": "#cccccc",
        "outline": "#444444",
        "outlineVariant": "#333333",
        "background": "#000000",
        "onBackground": "#ffffff",
        "error": "#ff6b6b",
        "onError": "#000000"
      }
    '';
  };
  
  home.file.".config/illogical-impulse/config.json" = {
    text = ''
      {
        "bar": {
          "enable": true,
          "showBackground": true
        },
        "dock": {
          "enable": false
        },
        "overview": {
          "enable": true
        }
      }
    '';
  };
  
  home.file.".local/state/quickshell/user/first_run.txt" = {
    text = "false";
  };
}