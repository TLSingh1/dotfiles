import QtQuick
import Quickshell
import "globals"

// Main entry point for Cyberpunk Shell
ShellRoot {
    // Test bar for Phase 0
    PanelWindow {
        id: testBar
        
        anchors {
            top: true
            left: true
            right: true
        }
        
        height: 32
        margins.top: 0
        
        color: "transparent"
        
        exclusionMode: ExclusionMode.Normal
        
        // Glass morphism background
        Rectangle {
            anchors.fill: parent
            color: Theme.background
            opacity: Theme.glassOpacity
            
            // Neon border test
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Theme.neonPrimary
                border.width: 1
            }
            
            // Simple test content
            Text {
                anchors.centerIn: parent
                text: "🚀 Cyberpunk Shell - Phase 0 Complete!"
                color: Theme.neonPrimary
                font.family: "JetBrains Mono"
                font.pixelSize: 14
                
                // Glow animation
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.7; to: 1.0; duration: 1000 }
                    NumberAnimation { from: 1.0; to: 0.7; duration: 1000 }
                }
            }
        }
    }
}