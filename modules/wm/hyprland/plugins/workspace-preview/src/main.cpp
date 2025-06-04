#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/render/Renderer.hpp>
#include <hyprland/src/managers/EventManager.hpp>

inline HANDLE PHANDLE = nullptr;

// Version check
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

// Called when workspace changes
void onWorkspaceChange(void* owner, SCallbackInfo& info, std::any data) {
    auto* workspace = std::any_cast<PHLWORKSPACE>(data);
    if (!workspace)
        return;
        
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Workspace changed to: " + std::to_string(workspace->m_iID),
        CColor{0.2, 1.0, 0.2, 1.0}, 2000);
}

// Called before rendering
void onPreRender(void* owner, SCallbackInfo& info, std::any data) {
    auto* monitor = std::any_cast<PHLMONITOR>(data);
    if (!monitor)
        return;
    
    // Later we'll capture workspace renders here
    static int frameCount = 0;
    if (++frameCount % 60 == 0) { // Log every 60 frames
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Rendered 60 frames on " + monitor->szName,
            CColor{0.2, 0.2, 1.0, 1.0}, 1000);
    }
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;
    
    // Check version compatibility
    const std::string HASH = __hyprland_api_get_hash();
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Version mismatch! Cannot load.",
            CColor{1.0, 0.2, 0.2, 1.0}, 5000);
        throw std::runtime_error("[workspace-preview] Version mismatch");
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Initialized successfully!",
        CColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    // Register callbacks
    static auto P1 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "workspace", onWorkspaceChange);
    static auto P2 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "preRender", onPreRender);
    
    // Add config values
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:enabled", SConfigValue{.intValue = 1});
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:scale", SConfigValue{.floatValue = 0.2f});
    
    return {
        "workspace-preview",
        "Provides workspace preview functionality for external applications", 
        "AGS Integration", 
        "0.1.0"
    };
}

APICALL EXPORT void PLUGIN_EXIT() {
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Shutting down",
        CColor{1.0, 0.5, 0.2, 1.0}, 2000);
}