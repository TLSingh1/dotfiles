{ config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.programs.marble;
in
{
  options.programs.marble = {
    enable = mkEnableOption "Marble shell";
    
    package = mkOption {
      type = types.package;
      default = inputs.marble.packages.${pkgs.system}.default;
      description = "The Marble shell package to use";
    };
  };

  config = mkIf cfg.enable {
    # Add Marble packages - both astal and default are required
    home.packages = [
      inputs.marble.packages.${pkgs.system}.astal
      inputs.marble.packages.${pkgs.system}.default
    ];

    # Create systemd service to autostart
    systemd.user.services.marble = {
      Unit = {
        Description = "Marble Shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/marble";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
} 