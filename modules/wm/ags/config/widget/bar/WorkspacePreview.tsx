import { Variable, bind } from "astal"
import { Gtk, astalify, type ConstructProps } from "astal/gtk4"
import { execAsync } from "astal/process"
import GdkPixbuf from "gi://GdkPixbuf"
import GLib from "gi://GLib"

// Socket path for IPC communication
const SOCKET_PATH = "/tmp/hyprland-workspace-preview.sock"

// Cache for workspace previews
const previewCache = new Map<number, GdkPixbuf.Pixbuf>()

// Request preview from plugin
async function requestPreview(workspaceId: number): Promise<GdkPixbuf.Pixbuf | null> {
    // Check cache first
    if (previewCache.has(workspaceId)) {
        return previewCache.get(workspaceId)!
    }
    
    try {
        // Use socat to communicate with the plugin
        const request = JSON.stringify({
            type: "preview_request",
            workspace_id: workspaceId
        })
        
        const response = await execAsync([
            "sh", "-c",
            `echo '${request}' | socat - UNIX-CONNECT:${SOCKET_PATH}`
        ])
        
        const data = JSON.parse(response)
        
        if (data.status === "success" && data.data) {
            // Decode base64 to bytes
            const bytes = GLib.base64_decode(data.data)
            
            // Create pixbuf from PNG data
            const loader = GdkPixbuf.PixbufLoader.new()
            loader.write(bytes)
            loader.close()
            
            const pixbuf = loader.get_pixbuf()
            if (pixbuf) {
                previewCache.set(workspaceId, pixbuf)
                return pixbuf
            }
        }
    } catch (e) {
        console.error("Failed to get workspace preview:", e)
    }
    
    return null
}

// Picture widget for displaying the preview
const Picture = astalify<
    Gtk.Picture,
    ConstructProps<Gtk.Picture, Gtk.Picture.ConstructorProps>
>(Gtk.Picture)

interface WorkspacePreviewProps {
    workspaceId: number
    visible: Variable<boolean>
}

export default function WorkspacePreview({ workspaceId, visible }: WorkspacePreviewProps) {
    const pixbuf = Variable<GdkPixbuf.Pixbuf | null>(null)
    const loading = Variable(false)
    
    // Load preview when becoming visible
    visible.subscribe(async (isVisible) => {
        if (isVisible && !pixbuf.get() && !loading.get()) {
            loading.set(true)
            const preview = await requestPreview(workspaceId)
            pixbuf.set(preview)
            loading.set(false)
        }
    })
    
    return <revealer
        revealChild={visible}
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
        transitionDuration={200}
        cssClasses={["workspace-preview-revealer"]}>
        
        <box cssClasses={["workspace-preview"]}>
            {/* Preview image or loading indicator */}
            {bind(pixbuf).as(pb => pb ? (
                <Picture
                    pixbuf={pb}
                    contentFit={Gtk.ContentFit.CONTAIN}
                    cssClasses={["preview-image"]} />
            ) : (
                <box cssClasses={["preview-loading"]}>
                    <label label={bind(loading).as(l => l ? "Loading..." : `Workspace ${workspaceId}`)} />
                </box>
            ))}
        </box>
    </revealer>
}

// Clear cache periodically to get fresh previews
import GLib from "gi://GLib"
GLib.timeout_add_seconds(GLib.PRIORITY_LOW, 30, () => {
    previewCache.clear()
    return true // Continue timeout
})