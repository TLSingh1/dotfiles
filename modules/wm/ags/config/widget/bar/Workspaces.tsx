import { Variable, bind, GLib } from "astal"
import { Gtk } from "astal/gtk4"
import { exec, execAsync } from "astal/process"

export default function Workspaces() {
    // Track active workspace and visible workspaces
    const activeWorkspace = Variable(1)
    const visibleWorkspaces = Variable(new Set<number>([1]))
    
    // Update workspace info
    const updateWorkspaces = () => {
        try {
            // Get active workspace
            const activeOutput = exec("hyprctl -j activeworkspace")
            const activeData = JSON.parse(activeOutput)
            activeWorkspace.set(activeData.id)
            
            // Get all workspaces
            const workspacesOutput = exec("hyprctl -j workspaces")
            const workspacesData = JSON.parse(workspacesOutput)
            
            // Build set of workspace IDs that should be shown
            const visible = new Set<number>()
            
            // Add all workspaces that exist (have windows)
            workspacesData.forEach((ws: any) => {
                if (ws.id > 0) {  // Only positive workspace IDs
                    visible.add(ws.id)
                }
            })
            
            // Always include workspace 1 and active workspace
            visible.add(1)
            if (activeData.id > 0) {
                visible.add(activeData.id)
            }
            
            visibleWorkspaces.set(visible)
        } catch (e) {
            console.error("Failed to update workspaces:", e)
        }
    }
    
    // Initial update
    updateWorkspaces()
    
    // Poll for updates every 100ms
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
        updateWorkspaces()
        return true
    })
    
    // Pre-create buttons for workspaces 1-10 (static buttons, dynamic visibility)
    const maxWorkspaces = 10
    const workspaceButtons = Array.from({ length: maxWorkspaces }, (_, i) => i + 1).map(id => (
        <button
            cssClasses={bind(activeWorkspace).as(active => 
                active === id ? ["workspace-button", "active"] : ["workspace-button"]
            )}
            visible={bind(visibleWorkspaces).as(visible => visible.has(id))}
            onClicked={() => execAsync(`hyprctl dispatch workspace ${id}`)}>
            
            <box cssClasses={["energy-container"]}>
                <box cssClasses={["orb"]} />
            </box>
        </button>
    ))
    
    return <box 
        cssClasses={["workspaces"]}
        vertical>
        {workspaceButtons}
    </box>
}
