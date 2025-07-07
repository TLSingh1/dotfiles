{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Quickshell package and basic configuration
  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell from flake input
    
    # Dependencies that quickshell widgets might need
    translate-shell # For translator widget
    ydotool # For keyboard/mouse simulation
    jq # JSON processing
    socat # Socket communication
    
    # Python for various scripts
    (python3.withPackages (ps: with ps; [
      requests
      pillow
    ]))
  ];
  
  # Create a minimal test configuration
  home.file.".config/quickshell/shell.qml" = {
    text = ''
      import Quickshell
      import QtQuick
      import QtQuick.Controls
      
      ShellRoot {
          // Minimal test shell - just a simple window to verify it works
          PanelWindow {
              anchors {
                  top: true
                  left: true
                  right: true
              }
              
              height: 30
              color: "transparent"
              
              Rectangle {
                  anchors.fill: parent
                  color: "#1a1a1a"
                  opacity: 0.9
                  
                  Text {
                      anchors.centerIn: parent
                      text: "Quickshell is working!"
                      color: "white"
                      font.pixelSize: 14
                  }
              }
          }
      }
    '';
  };
}