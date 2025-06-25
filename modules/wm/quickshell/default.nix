{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.programs.quickshell;
in
{
  imports = [
    ./packages.nix
  ];

  options.programs.quickshell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Quickshell cyberpunk desktop shell";
    };
    
    package = mkOption {
      type = types.package;
      default = inputs.quickshell.packages.${pkgs.system}.default;
      description = "The quickshell package to use";
    };
    
    config = mkOption {
      type = types.path;
      default = ./shell;
      description = "Path to the quickshell configuration";
    };
  };

  config = mkIf cfg.enable {
    # Quickshell and dependencies
    home.packages = with pkgs; [
      cfg.finalPackage
      
      # Qt dependencies
      qt6.qtdeclarative
      qt6.qt5compat
      qt6.qtwayland
      kdePackages.qt6ct
      
      # System integration
      socat
      jq
      ripgrep
      fd
      
      # Theming dependencies
      imagemagick
      python3
      python3Packages.pillow
      python3Packages.materialyoucolor
      
      # Wayland/Display
      wl-clipboard
      grim
      slurp
      swww
      
      # System info
      lm_sensors
      procps
      coreutils
      
      # Audio
      pamixer
      playerctl
      
      # Network/Bluetooth
      networkmanager
      bluez
      
      # Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      material-symbols
    ];

    # XDG configuration
    xdg.configFile = {
      "quickshell/cyberpunk" = {
        source = cfg.config;
        recursive = true;
      };
    };

    # Environment variables
    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    # Systemd service
    systemd.user.services.quickshell-cyberpunk = {
      Unit = {
        Description = "Quickshell Cyberpunk Desktop Shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${cfg.finalPackage}/bin/quickshell -c cyberpunk";
        Restart = "on-failure";
        RestartSec = 1;
        
        # Environment
        Environment = [
          "PATH=${lib.makeBinPath (with pkgs; [ 
            coreutils 
            procps 
            gawk 
            jq 
            socat 
            ripgrep 
            fd
            pamixer
            playerctl
            networkmanager
            bluez
            grim
            slurp
            imagemagick
            python3
          ])}"
        ];
      };
      
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Shell aliases for development
    home.shellAliases = {
      qs-restart = "systemctl --user restart quickshell-cyberpunk";
      qs-logs = "journalctl --user -u quickshell-cyberpunk -f";
      qs-reload = "${cfg.finalPackage}/bin/quickshell -c cyberpunk --reload";
      qs-dev = "cd ${config.xdg.configHome}/quickshell/cyberpunk && nix develop -c $EDITOR";
    };
  };
}