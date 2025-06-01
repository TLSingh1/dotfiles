{ config, pkgs, lib, inputs, ... }:

{
  # Enable home-manager ghostty configuration with official flake package
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default; # Use official flake package
    
    # Example configuration - customize as needed
    settings = {
      # Theme and appearance
      font-family = "JetBrains Mono";
      font-size = 12;
      
      command = "fish";
      
      # Window settings
      window-decoration = false;
      window-padding-x = 10;
      window-padding-y = 10;
      
      # Terminal behavior
      confirm-close-surface = false;
      shell-integration-features = "cursor,sudo,title";
      
      # Performance
      copy-on-select = false;
    };
  };
} 