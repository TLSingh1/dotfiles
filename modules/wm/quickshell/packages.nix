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
  
  # Theme extraction script with cyberpunk enhancements
  extractTheme = let
    pythonWithPackages = pkgs.python3.withPackages (ps: with ps; [
      pillow
      materialyoucolor
    ]);
  in pkgs.writeScriptBin "quickshell-extract-theme" ''
    #!${pythonWithPackages}/bin/python3
    import sys
    import json
    import colorsys
    from PIL import Image
    from materialyoucolor.quantize import QuantizeCelebi
    from materialyoucolor.score.score import Score
    from materialyoucolor.hct import Hct
    from materialyoucolor.dynamiccolor.material_dynamic_colors import MaterialDynamicColors
    from materialyoucolor.scheme.scheme_tonal_spot import SchemeTonalSpot
    
    def rgb_to_hex(r, g, b):
        return f"#{r:02x}{g:02x}{b:02x}"
    
    def hex_to_rgb(hex_color):
        hex_color = hex_color.lstrip('#')
        return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
    
    def enhance_for_cyberpunk(color_hex):
        """Enhance a color for cyberpunk aesthetic"""
        r, g, b = hex_to_rgb(color_hex)
        
        # Convert to HSV
        h, s, v = colorsys.rgb_to_hsv(r/255.0, g/255.0, b/255.0)
        
        # Enhance saturation and value for neon effect
        s = min(1.0, s * 1.5)  # Increase saturation significantly
        v = min(1.0, v * 1.3)  # Increase brightness
        
        # Convert back to RGB
        r, g, b = colorsys.hsv_to_rgb(h, s, v)
        return rgb_to_hex(int(r * 255), int(g * 255), int(b * 255))
    
    def extract_colors(image_path):
        try:
            img = Image.open(image_path).convert('RGB')
            img = img.resize((128, 128))  # Resize for faster processing
            
            # Convert to pixel array
            pixels = []
            for y in range(img.height):
                for x in range(img.width):
                    r, g, b = img.getpixel((x, y))
                    pixels.append((r << 16) | (g << 8) | b)
            
            # Quantize colors
            result = QuantizeCelebi(pixels, 128)
            ranked = Score.score(result)
            
            if ranked and len(ranked) > 0:
                # Get top colors
                source_color = Hct.from_int(ranked[0])
                
                # Generate Material You scheme (dark mode)
                scheme = SchemeTonalSpot(source_color, True, 0.0)
                
                # Extract base colors
                primary_int = scheme.primary
                secondary_int = scheme.secondary
                tertiary_int = scheme.tertiary
                
                # Convert to hex
                primary = rgb_to_hex((primary_int >> 16) & 0xFF, (primary_int >> 8) & 0xFF, primary_int & 0xFF)
                secondary = rgb_to_hex((secondary_int >> 16) & 0xFF, (secondary_int >> 8) & 0xFF, secondary_int & 0xFF)
                tertiary = rgb_to_hex((tertiary_int >> 16) & 0xFF, (tertiary_int >> 8) & 0xFF, tertiary_int & 0xFF)
                
                # Create theme
                theme = {
                    "primary": primary,
                    "secondary": secondary,
                    "tertiary": tertiary,
                    "background": "#0a0a0a",
                    "surface": "#1a1a1a",
                    "neonPrimary": enhance_for_cyberpunk(primary),
                    "neonSecondary": enhance_for_cyberpunk(secondary),
                    "neonTertiary": enhance_for_cyberpunk(tertiary),
                    "glowColor": primary + "66"
                }
                
                print(json.dumps(theme, indent=2))
            else:
                raise Exception("No colors found in image")
                
        except Exception as e:
            # Print error to stderr for debugging
            print(f"Error extracting colors: {e}", file=sys.stderr)
            # Fallback theme - output to stdout
            print(json.dumps({
                "primary": "#5eead4",
                "secondary": "#38bdf8",
                "tertiary": "#d8709a",
                "background": "#0a0a0a",
                "surface": "#1a1a1a",
                "neonPrimary": "#00ffcc",
                "neonSecondary": "#00aaff",
                "neonTertiary": "#ff00ff",
                "glowColor": "#5eead466"
            }, indent=2))
    
    if __name__ == "__main__":
        if len(sys.argv) < 2:
            print("Usage: quickshell-extract-theme <image_path>", file=sys.stderr)
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