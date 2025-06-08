{ config, pkgs, inputs, lib, ... }:

{
  # Configuration files
  xdg.configFile = {
    # Main caelestia shell configuration - this entire directory IS the shell
    "quickshell/caelestia" = {
      source = let
        # Create a filtered copy of the directory
        filteredSource = pkgs.runCommand "caelestia-shell-filtered" {} ''
          mkdir -p $out
          cd ${./.}
          
          # Copy everything except Nix files and documentation
          find . -type f \( \
            ! -name "*.nix" \
            ! -name "*.nix.old" \
            ! -name "README.md" \
            ! -name "TESTING_GUIDE.md" \
          \) -exec install -D {} $out/{} \;
          
          # Copy directories
          find . -type d ! -path "./.*" -exec mkdir -p $out/{} \;
        '';
      in filteredSource;
      recursive = true;
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