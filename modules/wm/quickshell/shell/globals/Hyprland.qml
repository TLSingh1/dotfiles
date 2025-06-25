pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Hyprland IPC integration
QtObject {
    id: hyprland
    
    property var activeWorkspace: 1
    property var workspaces: []
    property string activeWindow: ""
    property string activeClass: ""
    
    // IPC socket
    property var socket: null
    
    // Connect to Hyprland
    function connect() {
        console.log("🔌 Connecting to Hyprland...")
        
        // TODO: Set up socket connection
        // TODO: Subscribe to events
        
        // For now, just get initial state
        updateWorkspaces()
        
        console.log("✅ Hyprland connected")
    }
    
    // Update workspace info
    function updateWorkspaces() {
        // TODO: Query Hyprland for workspace info
        // For testing, create dummy data
        workspaces = [
            { id: 1, windows: 2, active: true },
            { id: 2, windows: 0, active: false },
            { id: 3, windows: 1, active: false }
        ]
    }
    
    // Switch workspace
    function switchWorkspace(id) {
        console.log("Switching to workspace", id)
        Process.execute(`hyprctl dispatch workspace ${id}`)
    }
    
    // Execute Hyprland command
    function dispatch(command) {
        Process.execute(`hyprctl dispatch ${command}`)
    }
    
    // Query Hyprland
    function query(command) {
        return Process.execute(`hyprctl ${command} -j`)
    }
}