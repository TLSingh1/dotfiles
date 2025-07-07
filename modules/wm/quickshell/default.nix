{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;
  
  # Wrapper for quickshell with proper Qt environment
  quickshellWrapped = pkgs.runCommand "quickshell-wrapped" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${quickshellPackage}/bin/qs $out/bin/qs \
      --prefix QT_PLUGIN_PATH : "${pkgs.kdePackages.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.kdePackages.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix QML_IMPORT_PATH : "${pkgs.kdePackages.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}"
  '';
in {
  # Quickshell package and basic configuration
  home.packages = with pkgs; [
    quickshellWrapped # Wrapped quickshell with Qt environment
    
    # Qt dependencies  
    kdePackages.qt5compat # Qt5Compat module for Qt6
    kdePackages.qtshadertools # Required for Qt6.4+ graphical effects
    
    # Dependencies that quickshell widgets might need
    translate-shell # For translator widget
    ydotool # For keyboard/mouse simulation
    jq # JSON processing
    socat # Socket communication
    ddcutil # Display brightness control
    
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