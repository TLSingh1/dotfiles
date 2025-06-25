import QtQuick
import Quickshell
import Quickshell.Io
import "../globals"

// Monitors SWWW wallpaper changes and triggers theme updates
Item {
    id: wallpaperMonitor
    
    property string currentWallpaper: ""
    property bool monitoring: false
    visible: false
    
    // Timer to periodically check wallpaper
    Timer {
        id: checkTimer
        interval: 2000  // Check every 2 seconds
        running: monitoring
        repeat: true
        onTriggered: checkWallpaper()
    }
    
    // Process to query SWWW
    Process {
        id: swwwQuery
        command: ["swww", "query"]
        running: false
        
        stdout: SplitParser {
            onRead: data => {
                const output = data.trim()
                const match = output.match(/image: (.+)/)
                if (match && match[1] !== currentWallpaper) {
                    currentWallpaper = match[1]
                    console.log("🖼️ Wallpaper changed:", currentWallpaper)
                    updateTheme()
                }
            }
        }
    }
    
    // Process for theme extraction
    Process {
        id: themeExtractor
        running: false
        
        stdout: SplitParser {
            onRead: data => {
                try {
                    const colors = JSON.parse(data)
                    applyTheme(colors)
                } catch (e) {
                    console.error("Failed to parse theme:", e)
                }
            }
        }
    }
    
    // Process for Hyprland update
    Process {
        id: hyprlandUpdater
        running: false
        
        stdout: SplitParser {
            onRead: data => console.log("Hyprland:", data)
        }
    }
    
    function start() {
        console.log("📡 Starting wallpaper monitor...")
        console.log("Testing SWWW query...")
        monitoring = true
        checkWallpaper()
    }
    
    function stop() {
        monitoring = false
    }
    
    function checkWallpaper() {
        console.log("Checking wallpaper...")
        swwwQuery.running = true
    }
    
    function updateTheme() {
        if (!currentWallpaper) return
        
        console.log("🎨 Extracting theme from wallpaper...")
        
        // Update command and run
        themeExtractor.command = ["quickshell-extract-theme", currentWallpaper]
        themeExtractor.running = true
    }
    
    function applyTheme(colors) {
        console.log("🎨 Applying theme:", JSON.stringify(colors))
        
        // Update Quickshell theme
        Theme.primary = colors.primary || "#5eead4"
        Theme.secondary = colors.secondary || "#38bdf8"
        Theme.tertiary = colors.tertiary || "#d8709a"
        Theme.background = colors.background || "#0a0a0a"
        Theme.surface = colors.surface || "#1a1a1a"
        
        // Update neon colors
        Theme.neonPrimary = colors.neonPrimary || "#00ffcc"
        Theme.neonSecondary = colors.neonSecondary || "#00aaff"
        Theme.glowColor = colors.glowColor || "#5eead466"
        
        // Update Hyprland colors
        updateHyprland(colors)
    }
    
    function updateHyprland(colors) {
        console.log("🎨 Updating Hyprland theme...")
        
        // Apply colors directly using hyprctl keyword commands
        const commands = [
            `hyprctl keyword general:col.active_border "rgb(${colors.neonPrimary.slice(1)}) rgb(${colors.neonSecondary.slice(1)}) 45deg"`,
            `hyprctl keyword general:col.inactive_border "rgb(${colors.surface.slice(1)})"`,
            `hyprctl keyword decoration:col.shadow "rgba(${colors.primary.slice(1)}55)"`,
            `hyprctl keyword group:col.border_active "rgb(${colors.neonPrimary.slice(1)})"`,
            `hyprctl keyword group:col.border_inactive "rgb(${colors.surface.slice(1)})"`,
            `hyprctl keyword misc:background_color "rgb(${colors.background.slice(1)})"`
        ].join(" && ")
        
        // Apply all color changes
        hyprlandUpdater.command = ["bash", "-c", commands]
        hyprlandUpdater.running = true
    }
}