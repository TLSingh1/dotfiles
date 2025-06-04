import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"

// Temporary mock implementation until Hyprland library is available
export default function Workspaces() {
    // For now, create a simple workspace indicator with 10 workspaces
    const activeWorkspace = Variable(1)
    
    // Create workspace buttons for workspaces 1-10
    const workspaceButtons = Array.from({ length: 10 }, (_, i) => i + 1).map(id => {
        return <button
            cssClasses={["workspace-button"]}
            setup={self => {
                // Bind active state
                self.hook(activeWorkspace, () => {
                    self.toggleClassName("active", activeWorkspace.get() === id)
                })
                
                // Mock occupied state - workspaces 1-3 are occupied by default
                self.toggleClassName("occupied", id <= 3)
            }}
            onClicked={() => {
                console.log(`Switching to workspace ${id}`)
                activeWorkspace.set(id)
                // Once Hyprland is available, use: hypr.dispatch("workspace", `${id}`)
            }}
            onScrollUp={() => {
                const current = activeWorkspace.get()
                if (current < 10) activeWorkspace.set(current + 1)
            }}
            onScrollDown={() => {
                const current = activeWorkspace.get()
                if (current > 1) activeWorkspace.set(current - 1)
            }}>
            
            {/* Energy beam container */}
            <box cssClasses={["energy-container"]}>
                {/* Orb indicator */}
                <box cssClasses={["orb"]} />
                
                {/* Flowing energy beam */}
                <box cssClasses={["energy-beam"]} />
                
                {/* Workspace number */}
                <label cssClasses={["workspace-label"]} label={`${id}`} />
            </box>
        </button>
    })
    
    return <box cssClasses={["workspaces"]} vertical>
        {workspaceButtons}
    </box>
}

// Full Hyprland implementation (for when the library is available):
/*
import Hyprland from "gi://AstalHyprland"

export default function Workspaces() {
    const hypr = Hyprland.get_default()
    
    // Track active workspace
    const activeId = Variable(hypr.get_focused_workspace().get_id())
    
    // Update active workspace on change
    hypr.connect("notify::focused-workspace", () => {
        activeId.set(hypr.get_focused_workspace().get_id())
    })
    
    // Create workspace buttons for workspaces 1-10
    const workspaceButtons = Array.from({ length: 10 }, (_, i) => i + 1).map(id => {
        const ws = hypr.get_workspace(id)
        const exists = Variable(ws !== null)
        
        // Update workspace existence
        const updateExists = () => {
            const workspace = hypr.get_workspace(id)
            exists.set(workspace !== null)
        }
        
        hypr.connect("workspace-added", updateExists)
        hypr.connect("workspace-removed", updateExists)
        
        return <button
            cssClasses={["workspace-button"]}
            setup={self => {
                // Bind active state
                self.hook(activeId, () => {
                    self.toggleClassName("active", activeId.get() === id)
                })
                
                // Bind occupied state
                self.hook(exists, () => {
                    self.toggleClassName("occupied", exists.get())
                })
            }}
            onClicked={() => hypr.dispatch("workspace", `${id}`)}
            onScrollUp={() => hypr.dispatch("workspace", "+1")}
            onScrollDown={() => hypr.dispatch("workspace", "-1")}>
            
            <box cssClasses={["energy-container"]}>
                <box cssClasses={["orb"]} />
                <box cssClasses={["energy-beam"]} />
                <label cssClasses={["workspace-label"]} label={`${id}`} />
            </box>
        </button>
    })
    
    return <box cssClasses={["workspaces"]} vertical>
        {workspaceButtons}
    </box>
}
*/