import { exec } from "astal/process"
import { GLib } from "astal"
import osdService from "../../services/osd-service"

// Track the last workspace to detect changes
let lastWorkspaceId = -1

function checkWorkspace() {
    try {
        const activeWorkspaceJson = exec("hyprctl -j activeworkspace")
        const activeWorkspace = JSON.parse(activeWorkspaceJson)
        
        if (activeWorkspace.id !== lastWorkspaceId && lastWorkspaceId !== -1) {
            console.log("Workspace changed from", lastWorkspaceId, "to", activeWorkspace.id)
            osdService.showWorkspaceOSD(activeWorkspace.id)
        }
        
        lastWorkspaceId = activeWorkspace.id
    } catch (error) {
        console.error("Failed to check workspace:", error)
    }
    
    return true // Keep the timer running
}

// Initialize with current workspace
checkWorkspace()

// Poll every 100ms for workspace changes (same approach as Workspaces widget but faster)
const updateTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, checkWorkspace)

console.log("Hyprland workspace monitoring initialized (polling mode)")

// Cleanup on exit
if (globalThis.process) {
    process.on('exit', () => {
        if (updateTimer) {
            GLib.source_remove(updateTimer)
        }
    })
}

export {}