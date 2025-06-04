#include <hyprland/src/plugins/PluginAPI.hpp>
#include <thread>
#include <memory>
#include <atomic>
#include <cstring>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <fcntl.h>
#include <json/json.h>

inline HANDLE PHANDLE = nullptr;

// IPC Socket path
const std::string SOCKET_PATH = "/tmp/hyprland-workspace-preview.sock";

// Global IPC thread
std::unique_ptr<std::thread> g_ipcThread;
std::atomic<bool> g_running{false};
int g_serverFd = -1;

// Simple IPC server implementation
void runIPCServer() {
    // Remove old socket if exists
    unlink(SOCKET_PATH.c_str());
    
    // Create socket
    g_serverFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (g_serverFd < 0) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Failed to create socket",
            CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        return;
    }
    
    // Set non-blocking
    fcntl(g_serverFd, F_SETFL, O_NONBLOCK);
    
    // Bind socket
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH.c_str(), sizeof(addr.sun_path) - 1);
    
    if (bind(g_serverFd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Failed to bind socket",
            CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        close(g_serverFd);
        return;
    }
    
    // Listen
    if (listen(g_serverFd, 5) < 0) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Failed to listen on socket",
            CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        close(g_serverFd);
        return;
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] IPC server started on " + SOCKET_PATH,
        CHyprColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    // Server loop
    while (g_running) {
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(g_serverFd, &readfds);
        
        struct timeval timeout;
        timeout.tv_sec = 0;
        timeout.tv_usec = 100000; // 100ms
        
        int result = select(g_serverFd + 1, &readfds, nullptr, nullptr, &timeout);
        if (result > 0 && FD_ISSET(g_serverFd, &readfds)) {
            int clientFd = accept(g_serverFd, nullptr, nullptr);
            if (clientFd >= 0) {
                // Read request
                char buffer[1024] = {0};
                int bytesRead = read(clientFd, buffer, sizeof(buffer) - 1);
                
                if (bytesRead > 0) {
                    // Parse JSON request
                    Json::Value request;
                    Json::Reader reader;
                    
                    if (reader.parse(buffer, request)) {
                        std::string type = request.get("type", "").asString();
                        
                        if (type == "preview_request") {
                            int workspaceId = request.get("workspace_id", 1).asInt();
                            
                            // Create response
                            Json::Value response;
                            response["type"] = "preview_data";
                            response["workspace_id"] = workspaceId;
                            response["status"] = "not_implemented";
                            response["message"] = "Preview capture not yet implemented";
                            
                            Json::StreamWriterBuilder builder;
                            std::string responseStr = Json::writeString(builder, response);
                            
                            write(clientFd, responseStr.c_str(), responseStr.length());
                        }
                    }
                }
                
                close(clientFd);
            }
        }
    }
    
    close(g_serverFd);
    unlink(SOCKET_PATH.c_str());
}

// Version check
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

// Called when workspace changes
void onWorkspaceChange(void* owner, SCallbackInfo& info, std::any data) {
    try {
        auto workspace = std::any_cast<PHLWORKSPACE>(data);
        if (!workspace)
            return;
            
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Workspace changed",
            CHyprColor{0.2, 1.0, 0.2, 1.0}, 1000);
    } catch (const std::bad_any_cast& e) {
        // Handle cast error
    }
}

// Called during rendering
void onRender(void* owner, SCallbackInfo& info, std::any data) {
    // This is where we'll eventually capture workspace renders
    // For now, just count frames
    static int frameCount = 0;
    frameCount++;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;
    
    // Check version compatibility (temporarily disabled for testing)
    const std::string HASH = __hyprland_api_get_hash();
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Warning: Version mismatch, but loading anyway for testing",
            CHyprColor{1.0, 0.8, 0.2, 1.0}, 5000);
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Initialized successfully!",
        CHyprColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    // Register callbacks
    static auto P1 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "workspace", onWorkspaceChange);
    static auto P2 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "render", onRender);
    
    // Add config values
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:enabled", Hyprlang::INT{1});
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:scale", Hyprlang::FLOAT{0.2f});
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:socket_path", Hyprlang::STRING{SOCKET_PATH.c_str()});
    
    // Start IPC server
    g_running = true;
    g_ipcThread = std::make_unique<std::thread>(runIPCServer);
    
    return {
        "workspace-preview",
        "Provides workspace preview functionality for external applications", 
        "AGS Integration", 
        "0.2.0"
    };
}

APICALL EXPORT void PLUGIN_EXIT() {
    // Stop IPC server
    g_running = false;
    if (g_ipcThread && g_ipcThread->joinable()) {
        g_ipcThread->join();
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Shutting down",
        CHyprColor{1.0, 0.5, 0.2, 1.0}, 2000);
}