{ config, pkgs, inputs, lib, ... }:

let
  # Caelestia scripts derivation with Python shebang fixes
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
      (python3.withPackages (ps: with ps; [
        materialyoucolor
        pillow
      ]))
    ];

    patchPhase = ''
      # Fix hardcoded paths to use XDG directories
      # For Fish files - use $HOME which Fish understands
      find . -name "*.fish" -type f | while read -r file; do
        # Replace specific patterns found in the scripts
        sed -i 's|$src/../data/schemes|$HOME/.local/share/caelestia/schemes|g' "$file"
        sed -i 's|(dirname (status filename))/data|$HOME/.local/share/caelestia|g' "$file"
        sed -i 's|$src/data|$HOME/.local/share/caelestia|g' "$file"
      done
      
      # For Python files
      find . -name "*.py" -type f | while read -r file; do
        sed -i 's|os.path.join(os.path.dirname(__file__), "..", "data")|os.path.expanduser("~/.local/share/caelestia")|g' "$file"
        sed -i 's|Path(__file__).parent.parent / "data"|Path.home() / ".local" / "share" / "caelestia"|g' "$file"
      done
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/caelestia-scripts
      
      # Copy all the scripts to share directory
      cp -r * $out/share/caelestia-scripts/
      
      # Fix Python shebangs for NixOS with the wrapped Python
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python3|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python3|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python|#!${pkgs.python3.withPackages (ps: with ps; [ materialyoucolor pillow ])}/bin/python|' {} \;
      
      # Make Python scripts executable
      find $out/share/caelestia-scripts -name "*.py" -type f -exec chmod +x {} \;
      
      # Create a setup script that ensures data directories exist
      cat > $out/bin/caelestia-setup <<EOF
      #!/bin/sh
      DATA_HOME="\$HOME/.local/share/caelestia"
      STATE_HOME="\$HOME/.local/state/caelestia"
      CACHE_HOME="\$HOME/.cache/caelestia"
      
      mkdir -p "\$DATA_HOME/schemes/dynamic"
      mkdir -p "\$STATE_HOME/wallpaper"
      mkdir -p "\$CACHE_HOME/schemes"
      
      # Copy data files if they don't exist
      if [ ! -d "\$DATA_HOME/schemes" ] && [ -d "$out/share/caelestia-scripts/data/schemes" ]; then
        cp -r "$out/share/caelestia-scripts/data/schemes" "\$DATA_HOME/"
      fi
      if [ ! -f "\$DATA_HOME/config.json" ] && [ -f "$out/share/caelestia-scripts/data/config.json" ]; then
        cp "$out/share/caelestia-scripts/data/config.json" "\$DATA_HOME/"
      fi
      if [ ! -f "\$DATA_HOME/emojis.txt" ] && [ -f "$out/share/caelestia-scripts/data/emojis.txt" ]; then
        cp "$out/share/caelestia-scripts/data/emojis.txt" "\$DATA_HOME/"
      fi
      EOF
      chmod +x $out/bin/caelestia-setup
      
      # Create wrapper for main script with all required tools in PATH
      makeWrapper ${pkgs.fish}/bin/fish $out/bin/caelestia \
        --add-flags "$out/share/caelestia-scripts/main.fish" \
        --run "$out/bin/caelestia-setup" \
        --prefix PATH : ${lib.makeBinPath (with pkgs; [
          imagemagick
          wl-clipboard
          fuzzel
          socat
          foot
          jq
          (python3.withPackages (ps: with ps; [ materialyoucolor pillow ]))
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

  # Wrap quickshell with Qt dependencies and required tools in PATH
  quickshell-wrapped = pkgs.runCommand "quickshell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs $out/bin/qs \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.fd pkgs.coreutils ]}
  '';

  # Script to update Neovim colors from Caelestia wallpaper
  update-nvim-colors = pkgs.writeShellScriptBin "update-nvim-colors" ''
    #!/usr/bin/env bash

    # Read colors from Caelestia scheme
    SCHEME_FILE="$HOME/.local/state/caelestia/scheme/current.txt"
    NVIM_CONFIG="$HOME/.dotfiles/modules/tui/nvim/lua/plugins/ui/catppuccin-colors.lua"

    if [ ! -f "$SCHEME_FILE" ]; then
        echo "Color scheme file not found: $SCHEME_FILE"
        exit 1
    fi

    # Read colors into associative array
    declare -A colors
    while IFS=' ' read -r name value; do
        colors[$name]="#$value"
    done < "$SCHEME_FILE"

    # Get primary colors for holographic generation
    primary="''${colors[blue]:-#83a598}"
    secondary="''${colors[mauve]:-#b16286}"
    accent="''${colors[yellow]:-#d79921}"

    # Generate holographic variations
    generate_holographic() {
        local base_color="$1"
        local lightness_adjust="$2"
        
        # Simple brightness adjustment
        local hex="''${base_color#\#}"
        local r=$((0x''${hex:0:2}))
        local g=$((0x''${hex:2:2}))
        local b=$((0x''${hex:4:2}))
        
        # Adjust brightness
        r=$(( r + lightness_adjust ))
        g=$(( g + lightness_adjust ))
        b=$(( b + lightness_adjust ))
        
        # Clamp values
        [ $r -lt 0 ] && r=0
        [ $r -gt 255 ] && r=255
        [ $g -lt 0 ] && g=0
        [ $g -gt 255 ] && g=255
        [ $b -lt 0 ] && b=0
        [ $b -gt 255 ] && b=255
        
        printf "#%02x%02x%02x" $r $g $b
    }

    # Generate dark backgrounds based on primary color
    base_bg=$(generate_holographic "$primary" -240)
    mantle_bg=$(generate_holographic "$primary" -235)
    crust_bg=$(generate_holographic "$primary" -230)

    # Generate surface colors with slight hue variations
    surface0=$(generate_holographic "$primary" -200)
    surface1=$(generate_holographic "$primary" -180)
    surface2=$(generate_holographic "$primary" -160)

    # Generate overlay colors
    overlay0=$(generate_holographic "$primary" -120)
    overlay1=$(generate_holographic "$primary" -80)
    overlay2=$(generate_holographic "$primary" -40)

    # Text colors - keep them light
    text=$(generate_holographic "$primary" 200)
    subtext1=$(generate_holographic "$primary" 180)
    subtext0=$(generate_holographic "$primary" 160)

    # Write the color configuration
    cat > "$NVIM_CONFIG" << EOF
    -- Auto-generated Catppuccin colors from Caelestia wallpaper
    -- Generated at: $(date)
    -- Wallpaper primary: $primary, secondary: $secondary, accent: $accent

    return {
        mocha = {
            -- Base colors - dark with primary tint
            base = "$base_bg",
            mantle = "$mantle_bg",
            crust = "$crust_bg",

            -- Surface colors - holographic gradient
            surface0 = "$surface0",
            surface1 = "$surface1",
            surface2 = "$surface2",

            -- Overlay colors
            overlay0 = "$overlay0",
            overlay1 = "$overlay1",
            overlay2 = "$overlay2",

            -- Text colors
            text = "$text",
            subtext1 = "$subtext1",
            subtext0 = "$subtext0",

            -- Accent colors from wallpaper
            rosewater = "''${colors[rosewater]:-#f5e0dc}",
            flamingo = "''${colors[flamingo]:-#f2cdcd}",
            pink = "''${colors[pink]:-#f5c2e7}",
            mauve = "''${colors[mauve]:-#cba6f7}",
            red = "''${colors[red]:-#f38ba8}",
            maroon = "''${colors[maroon]:-#eba0ac}",
            peach = "''${colors[peach]:-#fab387}",
            yellow = "''${colors[yellow]:-#f9e2af}",
            green = "''${colors[green]:-#a6e3a1}",
            teal = "''${colors[teal]:-#94e2d5}",
            sky = "''${colors[sky]:-#89dceb}",
            sapphire = "''${colors[sapphire]:-#74c7ec}",
            blue = "''${colors[blue]:-#89b4fa}",
            lavender = "''${colors[lavender]:-#b4befe}",
        }
    }
    EOF

    echo "Updated Neovim colors at $NVIM_CONFIG"
  '';

in
{
  options.programs.quickshell = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = quickshell-wrapped;
      description = "The wrapped quickshell package with Qt dependencies";
    };
    
    caelestia-scripts = lib.mkOption {
      type = lib.types.package;
      default = caelestia-scripts;
      description = "The caelestia scripts package";
    };
    
    update-nvim-colors = lib.mkOption {
      type = lib.types.package;
      default = update-nvim-colors;
      description = "Script to update Neovim colors from Caelestia wallpaper";
    };
  };
}