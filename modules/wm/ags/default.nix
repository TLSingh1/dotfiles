{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.programs.ags-desktop;
in
{
  options.programs.ags-desktop = {
    enable = mkEnableOption "AGS Desktop Environment";
    
    package = mkOption {
      type = types.package;
      default = inputs.self.packages.${pkgs.system}.my-desktop;
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