{ config, pkgs, inputs, lib, ... }:

let
  # Package for caelestia-scripts
  caelestia-scripts = pkgs.stdenv.mkDerivation rec {
    pname = "caelestia-scripts";
    version = "unstable-2024-01-07";

    src = pkgs.fetchFromGitHub {
      owner = "caelestia-dots";
      repo = "scripts";
      rev = "main";
      sha256 = "196z5hgd8d3vpa4bkxizgxnc3fj4aakais3i6a30ankanya4df5j";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];

    buildInputs = with pkgs; [
      fish
    ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/caelestia-scripts
      
      # Copy all the scripts to share directory
      cp -r * $out/share/caelestia-scripts/
      
      # Create wrapper for main script that sets up proper environment
      makeWrapper ${pkgs.fish}/bin/fish $out/bin/caelestia \
        --add-flags "$out/share/caelestia-scripts/main.fish" \
        --prefix PATH : ${lib.makeBinPath (with pkgs; [
          imagemagick
          wl-clipboard
          fuzzel
          socat
          foot
          jq
          python3
          grim
          wayfreeze
          wl-screenrec
          git
          coreutils
          findutils
          gnugrep
          xdg-user-dirs
        ])}
    '';

    meta = with lib; {
      description = "Caelestia dotfiles scripts";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  # Fetch the caelestia shell configuration
  caelestia-shell-src = pkgs.fetchFromGitHub {
    owner = "caelestia-dots";
    repo = "shell";
    rev = "main";
    sha256 = "1m8xpk8r8zamj9hgji5rlpisywxmmnni4877nbvf5imxl2hsmah8";
  };

  # Wrap quickshell with Qt dependencies
  quickshell-wrapped = pkgs.runCommand "quickshell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs $out/bin/qs \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}"
  '';

  # Create a wrapper script that starts quickshell with caelestia config
  caelestia-run-script = pkgs.writeScript "caelestia-shell-run.fish" ''
    #!${pkgs.fish}/bin/fish
    
    set -l dbus 'quickshell.dbus.properties.warning = false;quickshell.dbus.dbusmenu.warning = false'  # System tray dbus property errors
    set -l notifs 'quickshell.service.notifications.warning = false'  # Notification server warnings on reload
    set -l sni 'quickshell.service.sni.host.warning = false'  # StatusNotifierItem warnings on reload
    set -l process 'QProcess: Destroyed while process'  # Long running processes on reload
    
    ${quickshell-wrapped}/bin/qs -p (dirname (status filename)) --log-rules "$dbus;$notifs;$sni" | ${pkgs.gnugrep}/bin/grep -vE -e $process
  '';

in
{
  home.packages = with pkgs; [
    quickshell-wrapped
    caelestia-scripts
    
    # Qt dependencies for caelestia shell
    qt6.qt5compat
    qt6.qtdeclarative
    
    # Runtime dependencies for caelestia
    # hyprland is already installed elsewhere
    hyprpaper
    imagemagick
    wl-clipboard
    fuzzel
    socat
    foot
    jq
    python3
    python3Packages.materialyoucolor
    grim
    wayfreeze
    wl-screenrec
    inputs.astal.packages.${pkgs.system}.default
    
    # Additional dependencies from shell install script
    lm_sensors
    curl
    material-symbols
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex
    fd
    python3Packages.pyaudio
    python3Packages.numpy
    cava
    networkmanager
    bluez
    ddcutil
    brightnessctl
  ];

  # Set up the caelestia directory structure
  xdg.dataFile = {
    # Scripts directory (even though we're using the packaged version)
    "caelestia/scripts" = {
      source = "${caelestia-scripts}/share/caelestia-scripts";
      recursive = true;
    };
    
    # Shell directory WITHOUT run.fish (we'll add our own)
    "caelestia/shell" = {
      source = pkgs.runCommand "caelestia-shell-filtered" {} ''
        mkdir -p $out
        cp -r ${caelestia-shell-src}/* $out/
        rm -f $out/run.fish
      '';
      recursive = true;
    };
    
    # Create our own run.fish script with proper shebang
    "caelestia/shell/run.fish" = {
      source = caelestia-run-script;
      executable = true;
    };
  };

  # Quickshell configuration in the standard location
  xdg.configFile = {
    "quickshell/caelestia" = {
      source = caelestia-shell-src;
      recursive = true;
    };
    
    # Install fish completions (fixed version)
    "fish/completions/caelestia.fish" = {
      source = ./caelestia-completions.fish;
    };
    
    # Default caelestia config
    "caelestia/scripts.json" = {
      source = "${caelestia-scripts}/share/caelestia-scripts/data/config.json";
    };
  };

  # Environment variables
  home.sessionVariables = {
    C_DATA = "${config.xdg.dataHome}/caelestia";
    C_STATE = "${config.xdg.stateHome}/caelestia";
    C_CACHE = "${config.xdg.cacheHome}/caelestia";
    C_CONFIG = "${config.xdg.configHome}/caelestia";
  };

  # Create directory structure
  home.activation.caelestiaSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.xdg.dataHome}/caelestia
    mkdir -p ${config.xdg.stateHome}/caelestia/scheme
    mkdir -p ${config.xdg.cacheHome}/caelestia
    mkdir -p ${config.xdg.configHome}/caelestia
  '';

  # Systemd service for caelestia shell
  systemd.user.services.caelestia-shell = {
    Unit = {
      Description = "A very segsy desktop shell";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${config.xdg.dataHome}/caelestia/shell/run.fish";
      Restart = "on-failure";
      Slice = "app-graphical.slice";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Shell aliases
  home.shellAliases = {
    caelestia-shell = "qs -c caelestia";
  };
}