{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.modules.wm.ags;
in
{
  options.modules.wm.ags = {
    enable = mkEnableOption "AGS - Aylur's GTK Shell" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Import AGS home-manager module
    imports = [ inputs.ags.homeManagerModules.default ];

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
      ];
    };

    # Ensure config directory is linked
    xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/.dotfiles/modules/wm/ags/config";

    # Environment variables for AGS
    home.sessionVariables = {
      AGS_SKIP_V1_DEPRECATION_WARNING = "1";
    };
  };
}