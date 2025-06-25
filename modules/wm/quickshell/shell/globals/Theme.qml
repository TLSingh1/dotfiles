pragma Singleton
import QtQuick

// Global theme manager singleton
QtObject {
    // Material You base colors
    property color primary: "#5eead4"
    property color secondary: "#38bdf8"
    property color tertiary: "#d8709a"
    property color background: "#0a0a0a"
    property color surface: "#1a1a1a"
    
    // Cyberpunk enhanced colors
    property color neonPrimary: "#00ffcc"
    property color neonSecondary: "#00aaff"
    property color glowColor: "#5eead466"
    
    // Visual properties
    property real glassOpacity: 0.15
    property int cornerRadius: 16
    property int animationDuration: 300
}