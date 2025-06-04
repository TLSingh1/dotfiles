import { Variable, bind } from "astal"
import { Astal } from "astal/gtk4"
import { exec } from "astal/process"

// Global variable to track which workspace is being hovered
export const hoveredWorkspace = Variable<number | null>(null)
export const hoveredButtonY = Variable<number>(0)

interface ClientInfo {
    title: string
    class: string
}

export function WorkspacePreview() {
    const currentWorkspace = Variable<number | null>(null)
    const workspaceClients = Variable<ClientInfo[]>([])
    
    // When hover changes, get workspace info
    hoveredWorkspace.subscribe(async (wsId) => {
        if (wsId === null) {
            // Hide preview after a small delay
            setTimeout(() => {
                if (hoveredWorkspace.get() === null) {
                    currentWorkspace.set(null)
                    workspaceClients.set([])
                }
            }, 200)
            return
        }
        
        currentWorkspace.set(wsId)
        
        try {
            // Get workspace clients
            const clientsOutput = exec("hyprctl -j clients")
            const clients = JSON.parse(clientsOutput)
            const wsClients = clients
                .filter((c: any) => c.workspace.id === wsId)
                .map((c: any) => ({
                    title: c.title || "Untitled",
                    class: c.class || "Unknown"
                }))
            
            workspaceClients.set(wsClients)
        } catch (e) {
            console.error(`Failed to get workspace info:`, e)
            workspaceClients.set([])
        }
    })
    
    const { TOP, LEFT } = Astal.WindowAnchor
    const MARGIN = 12
    const BAR_WIDTH = 48
    
    return <window
        className="WorkspacePreview"
        gdkmonitor={0}
        anchor={TOP | LEFT}
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        keymode={Astal.Keymode.NONE}
        visible={bind(currentWorkspace).as(ws => ws !== null)}
        marginLeft={BAR_WIDTH + MARGIN * 2}
        marginTop={bind(hoveredButtonY).as(y => y - 108 + MARGIN)}>
        
        <box cssClasses={["workspace-preview-window"]} vertical>
            <label 
                cssClasses={["preview-title"]}
                label={bind(currentWorkspace).as(ws => `Workspace ${ws}`)} />
            
            <box cssClasses={["preview-content"]} vertical>
                {bind(workspaceClients).as(clients => 
                    clients.length > 0 ? (
                        clients.map(client => (
                            <box cssClasses={["client-item"]}>
                                <label cssClasses={["client-class"]} label={client.class} />
                                <label cssClasses={["client-title"]} label={client.title} />
                            </box>
                        ))
                    ) : (
                        <label cssClasses={["empty-workspace"]} label="Empty workspace" />
                    )
                )}
            </box>
        </box>
    </window>
}