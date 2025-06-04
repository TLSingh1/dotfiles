{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.modules.wm.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  options.modules.wm.ags = {
    enable = mkEnableOption "AGS - Aylur's GTK Shell" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {

    # Required packages for AGS and our widgets
    home.packages = with pkgs; [
      # Core dependencies
      gtk3
      gtk4
      gtksourceview
      webkitgtk
      accountsservice
      
      # Styling and theming
      sassc              # SCSS compiler
      dart-sass          # Alternative SCSS compiler
      
      # Our widget dependencies
      matugen            # Material You color generator
      swww               # Wallpaper daemon
      hyprpicker         # Color picker
      wl-clipboard       # Clipboard utilities
      grim               # Screenshot utility
      slurp              # Screen area selector
      
      # System info
      btop               # For system monitoring widgets
      pamixer            # Audio control
      brightnessctl      # Brightness control
      networkmanager     # Network management
      
      # Optional but useful
      jq                 # JSON processing
      socat              # Socket communication
      ripgrep            # Fast searching
      fd                 # Fast file finding
    ];

    # Configure AGS
    programs.ags = {
      enable = true;
      configDir = ./config;
      
      # Extra packages AGS might need
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        inputs.ags.packages.${pkgs.system}.astal4
        inputs.ags.packages.${pkgs.system}.io
        inputs.ags.packages.${pkgs.system}.hyprland
        inputs.ags.packages.${pkgs.system}.mpris
        inputs.ags.packages.${pkgs.system}.battery
        inputs.ags.packages.${pkgs.system}.wireplumber
        inputs.ags.packages.${pkgs.system}.network
        inputs.ags.packages.${pkgs.system}.tray
      ];
    };

    # Environment variables for AGS
    home.sessionVariables = {
      AGS_SKIP_V1_DEPRECATION_WARNING = "1";
    };
  };
}