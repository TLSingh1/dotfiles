{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [ 
    inputs.marble.packages.${pkgs.system}.default
    # Add icon themes to fix missing icons
    papirus-icon-theme
    adwaita-icon-theme
    pantheon.elementary-icon-theme
    # Additional icon themes that might have the missing icons
    numix-icon-theme
  ];

  # Disable dunst when marble is enabled (marble has its own notification system)
  services.dunst.enable = lib.mkForce false;

  # Configure GTK icon theme
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Set icon theme search path
  home.sessionVariables = {
    ICONPATH = "${pkgs.papirus-icon-theme}/share/icons:${pkgs.numix-icon-theme}/share/icons:${pkgs.pantheon.elementary-icon-theme}/share/icons";
  };

  systemd.user.services.marble = {
    Unit = {
      Description = "Marble Shell";
      After = [ "graphical-session.target" ];
      # Ensure dunst is stopped before marble starts
      Conflicts = [ "dunst.service" ];
    };
    Service = {
      ExecStart = "${inputs.marble.packages.${pkgs.system}.default}/bin/marble";
      Restart = "on-failure";
      # Set icon theme and Hyprland environment
      Environment = [
        "GTK_THEME=Adwaita"
        "ICON_THEME=Papirus-Dark"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "GTK_ICON_THEME=Papirus-Dark:elementary:Adwaita"
      ];
      # Pass Hyprland environment if available
      PassEnvironment = [
        "HYPRLAND_INSTANCE_SIGNATURE"
        "HYPRLAND_CMD"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}