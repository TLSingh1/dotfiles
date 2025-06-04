import { Variable, bind, GLib } from "astal"
import { Gtk } from "astal/gtk4"
import { execAsync, exec } from "astal/process"

interface Workspace {
    id: number
    windows: number
}

export default function Workspaces() {
    const activeWorkspace = Variable(1)
    const workspaces = Variable<Map<number, Workspace>>(new Map())
    
    let updateTimer: number | null = null
    
    const updateAll = async () => {
        try {
            const [activeOutput, workspacesOutput] = await Promise.all([
                execAsync("hyprctl -j activeworkspace"),
                execAsync("hyprctl -j workspaces")
            ])
            
            // Update active workspace
            const activeData = JSON.parse(activeOutput)
            console.log("Active workspace changed to:", activeData.id)
            activeWorkspace.set(activeData.id)
            
            // Update workspace list
            const workspacesData = JSON.parse(workspacesOutput)
            const newWorkspaces = new Map<number, Workspace>()
            
            workspacesData.forEach((ws: any) => {
                if (ws.id > 0) {
                    newWorkspaces.set(ws.id, { id: ws.id, windows: ws.windows })
                }
            })
            
            // Always include workspace 1
            if (!newWorkspaces.has(1)) {
                newWorkspaces.set(1, { id: 1, windows: 0 })
            }
            
            // Include current active workspace
            if (activeData.id > 0 && !newWorkspaces.has(activeData.id)) {
                newWorkspaces.set(activeData.id, { id: activeData.id, windows: 0 })
            }
            
            workspaces.set(newWorkspaces)
        } catch (e) {
            console.error("Failed to update workspaces:", e)
        }
    }
    
    // Initial update
    updateAll()
    
    // Use GLib timer for better integration with the main loop
    updateTimer = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, () => {
        updateAll()
        return true // Continue the timer
    })
    
    const maxWorkspaces = 10
    const workspaceButtons = Array.from({ length: maxWorkspaces }, (_, i) => {
        const id = i + 1
        return <box
            key={id}
            cssClasses={bind(activeWorkspace).as(active => 
                active === id ? ["workspace-container", "active"] : ["workspace-container"]
            )}
            visible={bind(workspaces).as(wsMap => 
                wsMap.has(id) || id === 1 || id === activeWorkspace.get()
            )}>
            <button
                cssClasses={["workspace-orb"]}
                onClicked={() => {
                    // Optimistically update the UI
                    activeWorkspace.set(id)
                    execAsync(`hyprctl dispatch workspace ${id}`)
                        .catch(e => {
                            console.error("Failed to switch workspace:", e)
                            // Revert on error
                            updateAll()
                        })
                }} />
        </box>
    })
    
    return <box 
        cssClasses={["workspaces"]}
        vertical>
        {workspaceButtons}
    </box>
}