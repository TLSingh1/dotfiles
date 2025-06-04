import { Variable, bind } from "astal"
import { Gtk } from "astal/gtk4"
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