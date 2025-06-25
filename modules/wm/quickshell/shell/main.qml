import QtQuick
import QtQuick.Controls
import Quickshell
import "globals" as Globals

// Main entry point for Cyberpunk Shell
ShellRoot {
    id: root
    
    // Import global singletons
    property var theme: Globals.Theme
    property var hyprland: Globals.Hyprland
    
    // Shell configuration
    property bool firstLaunch: true
    
    Component.onCompleted: {
        console.log("🚀 Cyberpunk Shell initializing...")
        
        // Initialize theme system
        Theme.initialize()
        
        // Set up Hyprland connection
        Hyprland.connect()
        
        // Start services
        startServices()
        
        console.log("✅ Cyberpunk Shell ready")
    }
    
    function startServices() {
        // TODO: Initialize various services
        // - Wallpaper monitor
        // - System monitor
        // - Notification daemon
        // - etc.
    }
    
    // Test bar for Phase 0
    PanelWindow {
        id: testBar
        
        anchors {
            top: true
            left: true
            right: true
        }
        
        height: 32
        
        color: "transparent"
        
        exclusionMode: ExclusionMode.Normal
        
        // Glass morphism background
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.3)
            
            // Blur will be handled by Hyprland window rules
            
            // Neon border test
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#00ff88"
                border.width: 1
                radius: 0
            }
            
            // Simple test content
            Text {
                anchors.centerIn: parent
                text: "🚀 Cyberpunk Shell - Phase 0"
                color: "#00ff88"
                font.family: "JetBrains Mono"
                font.pixelSize: 14
                
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.5; to: 1.0; duration: 1000 }
                    NumberAnimation { from: 1.0; to: 0.5; duration: 1000 }
                }
            }
        }
    }
}