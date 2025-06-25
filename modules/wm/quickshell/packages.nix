{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.programs.quickshell;
  
  # Wrapper script for quickshell with our configuration
  quickshellWrapped = pkgs.writeShellScriptBin "quickshell" ''
    # Set up environment
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QML_IMPORT_PATH="${cfg.package}/lib/qt-6/qml:$QML_IMPORT_PATH"
    export QT_PLUGIN_PATH="${cfg.package}/lib/qt-6/plugins:$QT_PLUGIN_PATH"
    
    # Configuration directory
    CONFIG_DIR="$HOME/.config/quickshell"
    
    # Handle reload command
    if [[ "$1" == "--reload" ]]; then
      echo "Reloading Quickshell..."
      ${pkgs.procps}/bin/pkill -USR2 quickshell || true
      exit 0
    fi
    
    # Launch quickshell
    exec ${cfg.package}/bin/quickshell "$@"
  '';
  
  # Development launcher with hot reload
  quickshellDev = pkgs.writeShellScriptBin "quickshell-dev" ''
    # Set up environment
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QML_IMPORT_PATH="${cfg.package}/lib/qt-6/qml:$QML_IMPORT_PATH"
    export QT_PLUGIN_PATH="${cfg.package}/lib/qt-6/plugins:$QT_PLUGIN_PATH"
    export QML_DISABLE_DISK_CACHE=1
    export QSG_INFO=1
    
    # Enable hot reload
    export QUICKSHELL_HOT_RELOAD=1
    
    CONFIG_DIR="$HOME/.config/quickshell/cyberpunk"
    
    echo "Starting Quickshell in development mode..."
    echo "Hot reload enabled - save files to reload"
    echo "Press Ctrl+C to exit"
    
    # Watch for changes and reload
    ${pkgs.watchexec}/bin/watchexec \
      --watch "$CONFIG_DIR" \
      --exts qml,js,json \
      --on-busy-update restart \
      -- ${cfg.package}/bin/quickshell -c cyberpunk "$@"
  '';
  
  # Theme extraction script
  extractTheme = pkgs.writeScriptBin "quickshell-extract-theme" ''
    #!${pkgs.python3}/bin/python3
    import sys
    import json
    from PIL import Image
    from material_color_utilities_python import *
    
    def extract_colors(image_path):
        img = Image.open(image_path)
        img = img.resize((128, 128))  # Resize for faster processing
        
        # Extract colors
        colors = themeFromImage(img)
        
        # Create cyberpunk enhanced theme
        theme = {
            "primary": f"#{colors['primary']:06x}",
            "secondary": f"#{colors['secondary']:06x}",
            "tertiary": f"#{colors['tertiary']:06x}",
            "surface": f"#{colors['surface']:06x}",
            "background": f"#{colors['background']:06x}",
            "onPrimary": f"#{colors['onPrimary']:06x}",
            "onSecondary": f"#{colors['onSecondary']:06x}",
            "onTertiary": f"#{colors['onTertiary']:06x}",
            "onSurface": f"#{colors['onSurface']:06x}",
            "onBackground": f"#{colors['onBackground']:06x}",
        }
        
        # Add cyberpunk enhancements
        # TODO: Implement neon color generation
        
        print(json.dumps(theme, indent=2))
    
    if __name__ == "__main__":
        if len(sys.argv) < 2:
            print("Usage: quickshell-extract-theme <image_path>")
            sys.exit(1)
        
        extract_colors(sys.argv[1])
  '';
in
{
  options.programs.quickshell = {
    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      description = "The final quickshell package with wrapper";
    };
  };
  
  config = mkIf cfg.enable {
    programs.quickshell.finalPackage = pkgs.symlinkJoin {
      name = "quickshell-wrapped";
      paths = [ quickshellWrapped cfg.package ];
      
      postBuild = ''
        # Add development tools
        ln -s ${quickshellDev}/bin/quickshell-dev $out/bin/
        ln -s ${extractTheme}/bin/quickshell-extract-theme $out/bin/
      '';
    };
  };
}