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
      python3
    ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/caelestia-scripts
      
      # Copy all the scripts to share directory
      cp -r * $out/share/caelestia-scripts/
      
      # Fix Python shebangs for NixOS
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python3|#!${pkgs.python3}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/bin/python|#!${pkgs.python3}/bin/python|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python3|#!${pkgs.python3}/bin/python3|' {} \;
      find $out/share/caelestia-scripts -name "*.py" -type f -exec sed -i '1s|^#!/usr/bin/env python|#!${pkgs.python3}/bin/python|' {} \;
      
      # Make Python scripts executable
      find $out/share/caelestia-scripts -name "*.py" -type f -exec chmod +x {} \;
      
      # Create wrapper for main script with all required tools in PATH
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
  };
}