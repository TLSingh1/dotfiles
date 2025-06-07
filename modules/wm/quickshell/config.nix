{ config, pkgs, inputs, lib, ... }:

{
  # Configuration files
  xdg.configFile = {
    # Main caelestia shell configuration - this entire directory IS the shell
    "quickshell/caelestia" = {
      source = ./.;
      recursive = true;
      # Exclude Nix files and other non-shell files
      filter = path: type:
        let
          baseName = baseNameOf path;
          isNixFile = lib.hasSuffix ".nix" baseName;
          isDocFile = baseName == "README.md" || baseName == "TESTING_GUIDE.md";
          isBackup = lib.hasSuffix ".old" baseName;
        in
        !(isNixFile || isDocFile || isBackup);
    };
    
    # Fish completions (our fixed version)
    "fish/completions/caelestia.fish" = {
      source = ./caelestia-completions.fish;
    };
    
    # Your custom scripts.json for toggle workspaces
    "caelestia/scripts.json" = {
      source = ./scripts.json;
    };
  };

  # Data files
  xdg.dataFile = {
    # Scripts directory (from the packaged scripts)
    "caelestia/scripts" = {
      source = "${config.programs.quickshell.caelestia-scripts}/share/caelestia-scripts";
      recursive = true;
    };
  };

  # Environment variables
  home.sessionVariables = {
    C_DATA = "${config.xdg.dataHome}/caelestia";
    C_STATE = "${config.xdg.stateHome}/caelestia";
    C_CACHE = "${config.xdg.cacheHome}/caelestia";
    C_CONFIG = "${config.xdg.configHome}/caelestia";
  };

  # Directory setup and permissions
  home.activation.caelestiaSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create required directories
    mkdir -p ${config.xdg.dataHome}/caelestia
    mkdir -p ${config.xdg.stateHome}/caelestia/scheme
    mkdir -p ${config.xdg.cacheHome}/caelestia/thumbnails
    mkdir -p ${config.xdg.configHome}/caelestia
    
    # Ensure state files are writable (fix permission issues)
    if [ -d ${config.xdg.stateHome}/caelestia/scheme ]; then
      find ${config.xdg.stateHome}/caelestia/scheme -name "*.txt" -exec chmod u+w {} \; 2>/dev/null || true
    fi
  '';
}