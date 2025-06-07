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
          hyprland
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
          astal
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

  # Create a wrapper script that starts quickshell with caelestia config
  caelestia-run-script = pkgs.writeTextFile {
    name = "caelestia-shell-run";
    executable = true;
    text = ''
      #!${pkgs.fish}/bin/fish
      
      # Source the utility functions
      set -q XDG_DATA_HOME && set C_DATA $XDG_DATA_HOME/caelestia || set C_DATA $HOME/.local/share/caelestia
      
      # Start quickshell with caelestia config
      exec ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs -c caelestia
    '';
  };

in
{
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default
    caelestia-scripts
    
    # Runtime dependencies for caelestia
    hyprland
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
    astal
    
    # Additional dependencies from shell install script
    lm_sensors
    curl
    material-symbols
    jetbrains-mono
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
    
    # Shell directory with run.fish
    "caelestia/shell" = {
      source = caelestia-shell-src;
      recursive = true;
    };
    
    # Create the run.fish script in the expected location
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
    
    # Install fish completions
    "fish/completions/caelestia.fish" = {
      source = "${caelestia-scripts}/share/caelestia-scripts/completions/caelestia.fish";
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