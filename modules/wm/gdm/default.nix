{ config, pkgs, lib, ... }:

{
  # GDM theme customization
  services.displayManager.gdm = {
    # Enable Wayland support
    wayland = true;
    
    # GDM settings are already configured in main configuration
    # Additional settings can be added here if needed
  };
  
  # Custom GDM theme using gnome-shell extensions
  environment.systemPackages = with pkgs; [
    gnome-shell-extensions
    (pkgs.writeScriptBin "gdm-theme-tool" ''
      #!${pkgs.bash}/bin/bash
      # Helper script to extract and modify GDM theme
      
      if [ "$1" = "extract" ]; then
        mkdir -p ~/.gdm-theme
        cd ~/.gdm-theme
        ${pkgs.glib}/bin/gresource extract /usr/share/gnome-shell/gnome-shell-theme.gresource
        echo "GDM theme extracted to ~/.gdm-theme"
        
      elif [ "$1" = "compile" ]; then
        cd ~/.gdm-theme
        ${pkgs.glib}/bin/glib-compile-resources gnome-shell-theme.gresource.xml
        echo "Theme compiled. Use 'sudo gdm-theme-tool install' to apply"
        
      elif [ "$1" = "install" ] && [ "$EUID" -eq 0 ]; then
        cp ~/.gdm-theme/gnome-shell-theme.gresource /usr/share/gnome-shell/
        echo "Theme installed. Restart GDM to apply changes"
        
      else
        echo "Usage:"
        echo "  gdm-theme-tool extract  - Extract current theme"
        echo "  gdm-theme-tool compile  - Compile modified theme"
        echo "  sudo gdm-theme-tool install - Install compiled theme"
      fi
    '')
  ];
  
  # GDM background image (create a derivation for custom background)
  # You can customize this path to your preferred wallpaper
  environment.etc."gdm/background.jpg".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "07ly21bhs6cgfl7pv4xlqzdqm44h22frwfhdqyd4gkn2jla1waab";
  };
  
  # Custom CSS for GDM (applied via gnome-shell theme)
  environment.etc."gdm/custom.css".text = ''
    /* Login screen customization */
    #lockDialogGroup {
      background: #1e1e2e;
      background-image: url('file:///etc/gdm/background.jpg');
      background-size: cover;
      background-position: center;
    }
    
    /* User list */
    .login-dialog-user-list {
      background-color: rgba(30, 30, 46, 0.8);
      border-radius: 12px;
      padding: 12px;
    }
    
    /* Selected user */
    .login-dialog-user-list-item:focus,
    .login-dialog-user-list-item:hover {
      background-color: rgba(137, 180, 250, 0.2);
      border-radius: 8px;
    }
    
    /* Password entry */
    .login-dialog-prompt-entry {
      background-color: rgba(49, 50, 68, 0.9);
      border: 2px solid rgba(137, 180, 250, 0.5);
      color: #cdd6f4;
      border-radius: 8px;
      padding: 8px 12px;
    }
    
    /* Buttons */
    .login-dialog .button {
      background-color: rgba(137, 180, 250, 0.9);
      color: #1e1e2e;
      border-radius: 8px;
      padding: 8px 16px;
      font-weight: bold;
    }
    
    .login-dialog .button:hover {
      background-color: rgba(180, 190, 254, 1);
    }
    
    /* Clock */
    .unlock-dialog-clock {
      color: #cdd6f4;
      font-size: 64px;
      font-weight: 300;
      text-shadow: 0px 2px 4px rgba(0, 0, 0, 0.4);
    }
    
    .unlock-dialog-clock-date {
      color: #bac2de;
      font-size: 18px;
      font-weight: 400;
    }
  '';
}