import { Variable, bind } from "astal"
import { Gtk, Gdk } from "astal/gtk4"

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
    
    return <eventbox
        onScroll={(self, event) => {
            // Handle scroll events
            const direction = event.get_scroll_direction()
            const current = activeWorkspace.get()
            
            if (direction === Gdk.ScrollDirection.UP && current > 1) {
                activeWorkspace.set(current - 1)
            } else if (direction === Gdk.ScrollDirection.DOWN && current < 10) {
                activeWorkspace.set(current + 1)
            } else if (direction === Gdk.ScrollDirection.SMOOTH) {
                // Handle smooth scrolling (trackpad)
                const [, dy] = event.get_scroll_deltas()
                if (dy < 0 && current > 1) {
                    activeWorkspace.set(current - 1)
                } else if (dy > 0 && current < 10) {
                    activeWorkspace.set(current + 1)
                }
            }
        }}>
        <box cssClasses={["workspaces"]} vertical>
            {workspaceButtons}
        </box>
    </eventbox>
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
            onClicked={() => hypr.dispatch("workspace", `${id}`)}>
            
            <box cssClasses={["energy-container"]}>
                <box cssClasses={["orb"]} />
                <box cssClasses={["energy-beam"]} />
                <label cssClasses={["workspace-label"]} label={`${id}`} />
            </box>
        </button>
    })
    
    return <eventbox
        onScroll={(self, event) => {
            const direction = event.get_scroll_direction()
            
            if (direction === Gdk.ScrollDirection.UP) {
                hypr.dispatch("workspace", "-1")
            } else if (direction === Gdk.ScrollDirection.DOWN) {
                hypr.dispatch("workspace", "+1")
            } else if (direction === Gdk.ScrollDirection.SMOOTH) {
                const [, dy] = event.get_scroll_deltas()
                if (dy < 0) {
                    hypr.dispatch("workspace", "-1")
                } else if (dy > 0) {
                    hypr.dispatch("workspace", "+1")
                }
            }
        }}>
        <box cssClasses={["workspaces"]} vertical>
            {workspaceButtons}
        </box>
    </eventbox>
}
*/