import { GLib } from "astal"

const SOCKET_PATH = "/tmp/hyprland-workspace-preview.sock"

interface PreviewRequest {
    type: "preview_request"
    workspace_id: number
}

interface PreviewResponse {
    type: "preview_data"
    workspace_id: number
    status: string
    message?: string
    width?: number
    height?: number
    data?: string // base64 encoded image data
}

export class WorkspacePreviewService {
    private socketPath = SOCKET_PATH

    async requestPreview(workspaceId: number): Promise<PreviewResponse | null> {
        return new Promise((resolve) => {
            try {
                // Create socket client
                const client = new GLib.SocketClient()
                const connection = client.connect_to_uri(
                    `unix:${this.socketPath}`,
                    null,
                    null
                )

                if (!connection) {
                    console.error("Failed to connect to workspace preview service")
                    resolve(null)
                    return
                }

                // Send request
                const request: PreviewRequest = {
                    type: "preview_request",
                    workspace_id: workspaceId
                }
                
                const outputStream = connection.get_output_stream()
                const requestData = JSON.stringify(request)
                outputStream.write_all(requestData, null)
                outputStream.flush(null)

                // Read response
                const inputStream = connection.get_input_stream()
                const buffer = new Uint8Array(4096)
                const [bytesRead] = inputStream.read(buffer, null)
                
                if (bytesRead > 0) {
                    const responseStr = new TextDecoder().decode(buffer.slice(0, bytesRead))
                    const response = JSON.parse(responseStr) as PreviewResponse
                    resolve(response)
                } else {
                    resolve(null)
                }

                connection.close(null)
            } catch (error) {
                console.error("Error requesting workspace preview:", error)
                resolve(null)
            }
        })
    }

    isAvailable(): boolean {
        return GLib.file_test(this.socketPath, GLib.FileTest.EXISTS)
    }
}

// Export singleton instance
export default new WorkspacePreviewService()