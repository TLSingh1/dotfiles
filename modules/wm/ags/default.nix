{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.programs.ags-desktop;
  
  # Build the AGS bundle locally
  agsBundle = inputs.ags.lib.bundle {
    inherit pkgs;
    src = ./src;
    name = "my-desktop";
    entry = "app.ts";
    
    # Additional Astal libraries
    extraPackages = with inputs.astal.packages.${pkgs.system}; [
      astal3
      io
      battery
      hyprland
      tray
    ];
  };
in
{
  options.programs.ags-desktop = {
    enable = mkEnableOption "AGS Desktop Environment";
    
    package = mkOption {
      type = types.package;
      default = agsBundle;
      description = "The AGS desktop package to use";
    };
  };

  config = mkIf cfg.enable {
    # Add AGS and runtime dependencies
    home.packages = with pkgs; [
      cfg.package
      inputs.ags.packages.${pkgs.system}.default
      # Additional runtime dependencies
      sassc
      gtk3
      gtk-layer-shell
    ];

    # Create systemd service to autostart
    systemd.user.services.ags-desktop = {
      Unit = {
        Description = "AGS Desktop Environment";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/my-desktop";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
} 