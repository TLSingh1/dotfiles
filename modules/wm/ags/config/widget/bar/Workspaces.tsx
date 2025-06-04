import { Variable, bind, GLib } from "astal"
import { Gtk } from "astal/gtk4"
import { exec, execAsync } from "astal/process"

export default function Workspaces() {
    // Track active workspace and which workspaces should be visible
    const activeWorkspace = Variable(1)
    const visibleWorkspaces = Variable(new Set([1]))
    
    // Poll Hyprland for workspace info
    const updateWorkspaces = () => {
        try {
            // Get active workspace
            const activeOutput = exec("hyprctl -j activeworkspace")
            const activeData = JSON.parse(activeOutput)
            activeWorkspace.set(activeData.id)
            
            // Get all workspaces
            const workspacesOutput = exec("hyprctl -j workspaces")
            const workspacesData = JSON.parse(workspacesOutput)
            
            // Build set of workspaces that exist (have windows or are active)
            const visible = new Set<number>()
            workspacesData.forEach((ws: any) => {
                if (ws.id > 0) {
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
    
    // Poll for updates
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 100, () => {
        updateWorkspaces()
        return true
    })
    
    // Function to switch to a workspace
    const switchToWorkspace = (id: number) => {
        console.log(`Switching to workspace ${id}`)
        execAsync(`hyprctl dispatch workspace ${id}`)
            .then(() => console.log(`Switched to workspace ${id}`))
            .catch((err) => console.error(`Failed to switch to workspace ${id}:`, err))
    }
    
    // Function to create workspace button
    const createWorkspaceButton = (id: number) => {
        const isActive = bind(activeWorkspace).as(active => active === id)
        
        return <button
            cssClasses={bind(isActive).as(active => 
                active ? ["workspace-button", "active"] : ["workspace-button"]
            )}
            onClicked={() => {
                console.log(`Button clicked for workspace ${id}`)
                switchToWorkspace(id)
            }}
            canFocus={true}
            sensitive={true}>
            
            {/* Energy beam container */}
            <box cssClasses={["energy-container"]} sensitive={false}>
                {/* Orb indicator */}
                <box cssClasses={["orb"]} />
                
                {/* Flowing energy beam */}
                {/* <box cssClasses={["energy-beam"]} /> */}
                
                {/* Workspace number */}
                {/* <label cssClasses={["workspace-label"]} label={`${id}`} /> */}
            </box>
        </button>
    }
    
    // Create workspace buttons dynamically based on visible workspaces
    const workspaceButtons = bind(visibleWorkspaces).as(visible => {
        const sortedIds = Array.from(visible).sort((a, b) => a - b)
        return sortedIds.map(id => createWorkspaceButton(id))
    })
    
    return <box 
        cssClasses={["workspaces"]}
        vertical
        setup={(self) => {
            // Add scroll event controller
            const scrollController = new Gtk.EventControllerScroll()
            scrollController.set_flags(Gtk.EventControllerScrollFlags.VERTICAL)
            
            scrollController.connect("scroll", (_, dx, dy) => {
                if (dy < 0) {
                    // Scroll down - next workspace
                    execAsync("hyprctl dispatch workspace +1").catch(console.error)
                } else if (dy > 0) {
                    // Scroll up - previous workspace
                    execAsync("hyprctl dispatch workspace -1").catch(console.error)
                }
                return true
            })
            
            self.add_controller(scrollController)
        }}>
        {workspaceButtons}
    </box>
}

// Full Hyprland implementation (for when the library is available):
/*
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
    const hypr = Hyprland.get_default()
    
    // Track active workspace and occupied workspaces
    const activeId = Variable(hypr.get_focused_workspace().get_id())
    const occupiedWorkspaces = Variable(new Set<number>())
    
    // Initialize occupied workspaces
    const updateOccupied = () => {
        const occupied = new Set<number>()
        hypr.get_workspaces().forEach(ws => {
            occupied.add(ws.get_id())
        })
        occupiedWorkspaces.set(occupied)
    }
    
    // Update active workspace on change
    hypr.connect("notify::focused-workspace", () => {
        activeId.set(hypr.get_focused_workspace().get_id())
    })
    
    // Update occupied workspaces
    hypr.connect("workspace-added", updateOccupied)
    hypr.connect("workspace-removed", updateOccupied)
    hypr.connect("client-added", updateOccupied)
    hypr.connect("client-removed", updateOccupied)
    
    updateOccupied() // Initial update
    
    // Combine active and occupied to determine visible workspaces
    const visibleWorkspaces = bind(activeId, occupiedWorkspaces).as((active, occupied) => {
        const visible = new Set(occupied)
        visible.add(active) // Always show active workspace
        visible.add(1) // Always show workspace 1
        return visible
    })
    
    const maxWorkspaces = 10
    const workspaceButtons = Array.from({ length: maxWorkspaces }, (_, i) => i + 1).map(id => {
        const isActive = bind(activeId).as(active => active === id)
        const isVisible = bind(visibleWorkspaces).as(visible => visible.has(id))
        
        return <button
            cssClasses={["workspace-button"]}
            visible={isVisible}
            setup={(self) => {
                isActive.subscribe((active) => {
                    self.toggleClassName("active", active)
                })
            }}
            onClicked={() => hypr.dispatch("workspace", `${id}`)}>
            
            <box cssClasses={["energy-container"]}>
                <box cssClasses={["orb"]} />
                <box cssClasses={["energy-beam"]} />
                <label cssClasses={["workspace-label"]} label={`${id}`} />
            </box>
        </button>
    })
    
    return <box 
        cssClasses={["workspaces"]}
        vertical
        setup={(self) => {
            const scrollController = new Gtk.EventControllerScroll()
            scrollController.set_flags(Gtk.EventControllerScrollFlags.VERTICAL)
            
            scrollController.connect("scroll", (_, dx, dy) => {
                if (dy < 0) {
                    hypr.dispatch("workspace", "+1")
                } else if (dy > 0) {
                    hypr.dispatch("workspace", "-1")
                }
                return true
            })
            
            self.add_controller(scrollController)
        }}>
        {workspaceButtons}
    </box>
}
*/
