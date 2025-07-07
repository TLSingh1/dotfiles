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
}