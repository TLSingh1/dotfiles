import { Variable, bind, GLib } from "astal"
import { Gtk } from "astal/gtk4"
import { execAsync, exec } from "astal/process"

interface Workspace {
    id: number
    windows: number
    monitor: string
}

interface WorkspacesProps {
    monitorName: string
}

export default function Workspaces({ monitorName }: WorkspacesProps) {
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
            // console.log("Active workspace changed to:", activeData.id)
            activeWorkspace.set(activeData.id)
            
            // Update workspace list
            const workspacesData = JSON.parse(workspacesOutput)
            const newWorkspaces = new Map<number, Workspace>()
            
            workspacesData.forEach((ws: any) => {
                if (ws.id > 0 && ws.monitor === monitorName) {
                    newWorkspaces.set(ws.id, { id: ws.id, windows: ws.windows, monitor: ws.monitor })
                }
            })
            
            // Always include workspace 1 on laptop monitor
            if (!newWorkspaces.has(1) && monitorName === "eDP-1") {
                newWorkspaces.set(1, { id: 1, windows: 0, monitor: "eDP-1" })
            }
            
            // Always include workspace 6 on external monitor
            if (!newWorkspaces.has(6) && monitorName === "DP-1") {
                newWorkspaces.set(6, { id: 6, windows: 0, monitor: "DP-1" })
            }
            
            // Include current active workspace if it belongs to this monitor
            // Get workspace info for active workspace
            const activeWsData = workspacesData.find((ws: any) => ws.id === activeData.id)
            if (activeData.id > 0 && activeWsData && activeWsData.monitor === monitorName && !newWorkspaces.has(activeData.id)) {
                newWorkspaces.set(activeData.id, { id: activeData.id, windows: 0, monitor: monitorName })
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
    
    // Define workspace ranges for each monitor
    const workspaceRange = monitorName === "eDP-1" 
        ? { start: 1, end: 5 }  // Laptop: workspaces 1-5
        : { start: 6, end: 12 } // External: workspaces 6-12
    
    const workspaceButtons = Array.from(
        { length: workspaceRange.end - workspaceRange.start + 1 }, 
        (_, i) => {
        const id = workspaceRange.start + i
        return <box
            key={id}
            cssClasses={bind(activeWorkspace).as(active => 
                active === id ? ["workspace-container", "active"] : ["workspace-container"]
            )}
            visible={bind(workspaces).as(wsMap => {
                // Always show the first workspace of each monitor
                const isFirstWorkspace = (monitorName === "eDP-1" && id === 1) || 
                                       (monitorName === "DP-1" && id === 6)
                return wsMap.has(id) || isFirstWorkspace
            })}>
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
