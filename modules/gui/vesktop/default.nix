{ config, pkgs, lib, ... }:

{
  programs.vesktop = {
    enable = true;
    
    settings = {
      appBadge = false;
      arRPC = true;
      customTitleBar = false;
      hardwareAcceleration = true;
      discordBranch = "stable";
      minimizeToTray = true;
      tray = true;
    };

    vencord = {
      themes = {
        "translucence" = ./themes/translucence.css;
      };
      
      settings = {
        enabledThemes = [
          "translucence.css"
        ];
      };
    };
  };
}