import QtQuick
import Quickshell
import "globals"
import "services"

// Main entry point for Cyberpunk Shell
ShellRoot {
    // Services
    WallpaperMonitor {
        id: wallpaperMonitor
        Component.onCompleted: start()
    }
    
    // Test bar for Phase 1 - Dynamic Theming
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
        
        exclusionMode: ExclusionMode.Auto
        exclusiveZone: 32  // Same as height to reserve space
        
        // Glass morphism background
        Rectangle {
            anchors.fill: parent
            color: Theme.background
            opacity: 0.8  // More opaque for better visibility
            
            // Animated color transitions
            Behavior on color {
                ColorAnimation { duration: Theme.animationDuration }
            }
            
            // Neon border with animated color
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Theme.neonPrimary
                border.width: 1
                
                Behavior on border.color {
                    ColorAnimation { duration: Theme.animationDuration }
                }
            }
            
            // Dynamic theme indicator
            Row {
                anchors.centerIn: parent
                spacing: 20
                
                // Status text
                Text {
                    text: "🎨 Dynamic Theme Active"
                    color: Theme.neonPrimary
                    font.family: "JetBrains Mono"
                    font.pixelSize: 14
                    
                    Behavior on color {
                        ColorAnimation { duration: Theme.animationDuration }
                    }
                }
                
                // Color preview circles
                Row {
                    spacing: 10
                    
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: Theme.primary
                        border.color: Theme.neonPrimary
                        border.width: 1
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.animationDuration }
                        }
                    }
                    
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: Theme.secondary
                        border.color: Theme.neonSecondary
                        border.width: 1
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.animationDuration }
                        }
                    }
                    
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: Theme.tertiary
                        border.color: Theme.neonTertiary
                        border.width: 1
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.animationDuration }
                        }
                    }
                }
            }
        }
    }
}