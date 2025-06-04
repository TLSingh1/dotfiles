#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/render/OpenGL.hpp>
#include <hyprland/src/desktop/Workspace.hpp>
#include <hyprland/src/helpers/Monitor.hpp>

#include <thread>
#include <memory>
#include <atomic>
#include <mutex>
#include <cstring>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <fcntl.h>
#include <json/json.h>
#include <vector>
#include <map>
#include <png.h>
#include <GL/gl.h>
#include <chrono>

inline HANDLE PHANDLE = nullptr;

// IPC Socket path
const std::string SOCKET_PATH = "/tmp/hyprland-workspace-preview.sock";

// Global IPC thread
std::unique_ptr<std::thread> g_ipcThread;
std::atomic<bool> g_running{false};
int g_serverFd = -1;

// Preview cache
struct PreviewData {
    int width;
    int height;
    std::vector<uint8_t> data;
    uint64_t timestamp;
};

std::mutex g_previewMutex;
std::map<int, PreviewData> g_previewCache;

// Hook for render function
inline CFunctionHook* g_pRenderWorkspaceHook = nullptr;
typedef void (*origRenderWorkspace)(void*, void*, void*, timespec*, const void*);

// Capture state
struct CaptureRequest {
    int workspaceId;
    bool pending;
};
std::mutex g_captureMutex;
CaptureRequest g_captureRequest{-1, false};

// PNG encoding helper
std::vector<uint8_t> encodePNG(const uint8_t* pixels, int width, int height) {
    std::vector<uint8_t> pngData;
    
    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
    if (!png) return pngData;
    
    png_infop info = png_create_info_struct(png);
    if (!info) {
        png_destroy_write_struct(&png, nullptr);
        return pngData;
    }
    
    // Custom write function for vector
    png_set_write_fn(png, &pngData, 
        [](png_structp png, png_bytep data, png_size_t length) {
            auto* vec = static_cast<std::vector<uint8_t>*>(png_get_io_ptr(png));
            vec->insert(vec->end(), data, data + length);
        }, nullptr);
    
    // Set image properties
    png_set_IHDR(png, info, width, height, 8, PNG_COLOR_TYPE_RGBA,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
    
    // Write header
    png_write_info(png, info);
    
    // Write rows
    for (int y = 0; y < height; y++) {
        png_write_row(png, const_cast<png_bytep>(pixels + y * width * 4));
    }
    
    png_write_end(png, nullptr);
    png_destroy_write_struct(&png, &info);
    
    return pngData;
}

// Base64 encoding
std::string base64Encode(const std::vector<uint8_t>& data) {
    static const char* chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    std::string result;
    result.reserve((data.size() + 2) / 3 * 4);
    
    for (size_t i = 0; i < data.size(); i += 3) {
        uint32_t buf = 0;
        for (size_t j = 0; j < 3; ++j) {
            buf <<= 8;
            if (i + j < data.size()) buf |= data[i + j];
        }
        
        for (int j = 3; j >= 0; --j) {
            if (i + (3 - j) <= data.size()) {
                result.push_back(chars[(buf >> (j * 6)) & 0x3F]);
            } else {
                result.push_back('=');
            }
        }
    }
    
    return result;
}

// Capture workspace framebuffer
void captureWorkspaceFramebuffer(CWorkspace* pWorkspace, CMonitor* pMonitor) {
    if (!pWorkspace || !pMonitor) return;
    
    // Get OpenGL instance
    auto* pOpenGL = (CHyprOpenGLImpl*)g_pHyprOpenGL;
    if (!pOpenGL) return;
    
    // Get framebuffer dimensions
    const auto& monitorSize = pMonitor->vecPixelSize;
    const int FB_WIDTH = monitorSize.x;
    const int FB_HEIGHT = monitorSize.y;
    
    // Calculate preview dimensions
    const float scale = 0.2f;
    const int PREVIEW_WIDTH = FB_WIDTH * scale;
    const int PREVIEW_HEIGHT = FB_HEIGHT * scale;
    
    // Allocate buffer for full framebuffer
    std::vector<uint8_t> fbPixels(FB_WIDTH * FB_HEIGHT * 4);
    
    // Read pixels from current framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 1);
    glReadPixels(0, 0, FB_WIDTH, FB_HEIGHT, GL_RGBA, GL_UNSIGNED_BYTE, fbPixels.data());
    
    // Scale down to preview size
    std::vector<uint8_t> previewPixels(PREVIEW_WIDTH * PREVIEW_HEIGHT * 4);
    
    // Simple bilinear scaling
    for (int y = 0; y < PREVIEW_HEIGHT; y++) {
        for (int x = 0; x < PREVIEW_WIDTH; x++) {
            // Calculate source coordinates
            float srcX = x / scale;
            float srcY = y / scale;
            
            int x0 = (int)srcX;
            int y0 = (int)srcY;
            int x1 = std::min(x0 + 1, FB_WIDTH - 1);
            int y1 = std::min(y0 + 1, FB_HEIGHT - 1);
            
            float fx = srcX - x0;
            float fy = srcY - y0;
            
            // Bilinear interpolation for each channel
            for (int c = 0; c < 4; c++) {
                float p00 = fbPixels[(y0 * FB_WIDTH + x0) * 4 + c];
                float p10 = fbPixels[(y0 * FB_WIDTH + x1) * 4 + c];
                float p01 = fbPixels[(y1 * FB_WIDTH + x0) * 4 + c];
                float p11 = fbPixels[(y1 * FB_WIDTH + x1) * 4 + c];
                
                float p0 = p00 * (1 - fx) + p10 * fx;
                float p1 = p01 * (1 - fx) + p11 * fx;
                float p = p0 * (1 - fy) + p1 * fy;
                
                previewPixels[(y * PREVIEW_WIDTH + x) * 4 + c] = (uint8_t)p;
            }
        }
    }
    
    // Flip vertically (OpenGL reads upside down)
    std::vector<uint8_t> flippedPixels(PREVIEW_WIDTH * PREVIEW_HEIGHT * 4);
    for (int y = 0; y < PREVIEW_HEIGHT; y++) {
        memcpy(&flippedPixels[y * PREVIEW_WIDTH * 4],
               &previewPixels[(PREVIEW_HEIGHT - 1 - y) * PREVIEW_WIDTH * 4],
               PREVIEW_WIDTH * 4);
    }
    
    // Store in cache
    std::lock_guard<std::mutex> lock(g_previewMutex);
    g_previewCache[pWorkspace->m_iID] = {
        PREVIEW_WIDTH,
        PREVIEW_HEIGHT,
        std::move(flippedPixels),
        static_cast<uint64_t>(std::chrono::system_clock::now().time_since_epoch().count())
    };
}

// Request a workspace preview capture
void requestWorkspaceCapture(int workspaceId) {
    std::lock_guard<std::mutex> lock(g_captureMutex);
    g_captureRequest = {workspaceId, true};
}

// Hook for workspace rendering
void hkRenderWorkspace(void* thisptr, void* pMonitor, void* pWorkspace, timespec* time, const void* geometry) {
    // Call original
    (*(origRenderWorkspace)g_pRenderWorkspaceHook->m_original)(thisptr, pMonitor, pWorkspace, time, geometry);
    
    // Check if we have a capture request for this workspace
    CWorkspace* workspace = (CWorkspace*)pWorkspace;
    CMonitor* monitor = (CMonitor*)pMonitor;
    
    if (workspace && monitor) {
        std::lock_guard<std::mutex> lock(g_captureMutex);
        if (g_captureRequest.pending && g_captureRequest.workspaceId == workspace->m_iID) {
            // Capture the framebuffer
            captureWorkspaceFramebuffer(workspace, monitor);
            g_captureRequest.pending = false;
            
            HyprlandAPI::addNotification(PHANDLE, 
                "[workspace-preview] Captured workspace " + std::to_string(workspace->m_iID),
                CHyprColor{0.2, 1.0, 0.2, 1.0}, 1000);
        }
    }
}

// IPC server implementation
void runIPCServer() {
    unlink(SOCKET_PATH.c_str());
    
    g_serverFd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (g_serverFd < 0) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Failed to create socket",
            CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        return;
    }
    
    fcntl(g_serverFd, F_SETFL, O_NONBLOCK);
    
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, SOCKET_PATH.c_str(), sizeof(addr.sun_path) - 1);
    
    if (bind(g_serverFd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        close(g_serverFd);
        return;
    }
    
    if (listen(g_serverFd, 5) < 0) {
        close(g_serverFd);
        return;
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] IPC server started",
        CHyprColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    while (g_running) {
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(g_serverFd, &readfds);
        
        struct timeval timeout;
        timeout.tv_sec = 0;
        timeout.tv_usec = 100000;
        
        int result = select(g_serverFd + 1, &readfds, nullptr, nullptr, &timeout);
        if (result > 0 && FD_ISSET(g_serverFd, &readfds)) {
            int clientFd = accept(g_serverFd, nullptr, nullptr);
            if (clientFd >= 0) {
                char buffer[1024] = {0};
                int bytesRead = read(clientFd, buffer, sizeof(buffer) - 1);
                
                if (bytesRead > 0) {
                    Json::Value request;
                    Json::Reader reader;
                    
                    if (reader.parse(buffer, request)) {
                        std::string type = request.get("type", "").asString();
                        
                        if (type == "preview_request") {
                            int workspaceId = request.get("workspace_id", 1).asInt();
                            
                            // Try to get preview from cache
                            Json::Value response;
                            response["type"] = "preview_data";
                            response["workspace_id"] = workspaceId;
                            
                            {
                                std::lock_guard<std::mutex> lock(g_previewMutex);
                                auto it = g_previewCache.find(workspaceId);
                                if (it != g_previewCache.end()) {
                                    // Encode to PNG
                                    auto pngData = encodePNG(it->second.data.data(), 
                                                           it->second.width, 
                                                           it->second.height);
                                    
                                    response["status"] = "success";
                                    response["width"] = it->second.width;
                                    response["height"] = it->second.height;
                                    response["format"] = "png";
                                    response["data"] = base64Encode(pngData);
                                    response["timestamp"] = static_cast<Json::Int64>(it->second.timestamp);
                                } else {
                                    response["status"] = "not_available";
                                    response["message"] = "No preview available for this workspace";
                                    
                                    // Trigger a capture request
                                    requestWorkspaceCapture(workspaceId);
                                }
                            }
                            
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

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;
    
    const std::string HASH = __hyprland_api_get_hash();
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Warning: Version mismatch, but loading anyway",
            CHyprColor{1.0, 0.8, 0.2, 1.0}, 5000);
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] v3 with capture support!",
        CHyprColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    // Hook the render function
    const auto METHODS = HyprlandAPI::findFunctionsByName(PHANDLE, "renderWorkspace");
    if (!METHODS.empty()) {
        g_pRenderWorkspaceHook = HyprlandAPI::createFunctionHook(PHANDLE, METHODS[0].address, (void*)&hkRenderWorkspace);
        g_pRenderWorkspaceHook->hook();
        
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Render hook installed",
            CHyprColor{0.2, 1.0, 0.2, 1.0}, 2000);
    } else {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Failed to find renderWorkspace",
            CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
    }
    
    // Add config values
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:enabled", Hyprlang::INT{1});
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:scale", Hyprlang::FLOAT{0.2f});
    
    // Start IPC server
    g_running = true;
    g_ipcThread = std::make_unique<std::thread>(runIPCServer);
    
    return {
        "workspace-preview",
        "Workspace preview with capture support", 
        "AGS Integration", 
        "0.3.0"
    };
}

APICALL EXPORT void PLUGIN_EXIT() {
    g_running = false;
    if (g_ipcThread && g_ipcThread->joinable()) {
        g_ipcThread->join();
    }
    
    if (g_pRenderWorkspaceHook) {
        g_pRenderWorkspaceHook->unhook();
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Shutting down",
        CHyprColor{1.0, 0.5, 0.2, 1.0}, 2000);
}