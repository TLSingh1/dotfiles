pragma Singleton
import QtQuick
import QtQuick.Controls

// Global theme manager singleton
QtObject {
    id: theme
    
    // Material You base colors (will be dynamic later)
    property color primary: "#5eead4"
    property color secondary: "#38bdf8"
    property color tertiary: "#d8709a"
    property color background: "#0a0a0a"
    property color surface: "#1a1a1a"
    property color onPrimary: "#000000"
    property color onSecondary: "#000000"
    property color onBackground: "#ffffff"
    property color onSurface: "#ffffff"
    
    // Cyberpunk enhanced colors
    property color neonPrimary: Qt.lighter(primary, 1.8)
    property color neonSecondary: Qt.lighter(secondary, 1.8)
    property color neonTertiary: Qt.lighter(tertiary, 1.8)
    property color glowColor: Qt.rgba(primary.r, primary.g, primary.b, 0.4)
    
    // Visual properties
    property real glassOpacity: 0.15
    property real blurRadius: 32
    property int cornerRadius: 16
    property int animationDuration: 300
    property string animationEasing: "Bezier"
    
    // Theme mode
    property bool darkMode: true
    
    // Initialize theme
    function initialize() {
        console.log("🎨 Theme system initializing...")
        
        // TODO: Set up wallpaper monitoring
        // TODO: Load saved theme
        
        console.log("✅ Theme ready")
    }
    
    // Update theme from wallpaper
    function updateFromWallpaper(imagePath) {
        console.log("🎨 Extracting theme from:", imagePath)
        
        // TODO: Call Python script to extract colors
        // TODO: Apply cyberpunk filter
        // TODO: Animate transition
    }
    
    // Manual theme override
    function setTheme(colors) {
        // TODO: Implement manual theme setting
    }
    
    // Get color with opacity
    function withOpacity(color, opacity) {
        return Qt.rgba(color.r, color.g, color.b, opacity)
    }
    
    // Generate holographic gradient
    function holographicGradient() {
        return Gradient {
            GradientStop { position: 0.0; color: withOpacity(primary, 0.1) }
            GradientStop { position: 0.33; color: withOpacity(secondary, 0.1) }
            GradientStop { position: 0.66; color: withOpacity(tertiary, 0.1) }
            GradientStop { position: 1.0; color: withOpacity(primary, 0.1) }
        }
    }
}