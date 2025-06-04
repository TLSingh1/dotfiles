#include <hyprland/src/plugins/PluginAPI.hpp>

inline HANDLE PHANDLE = nullptr;

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
            CHyprColor{0.2, 1.0, 0.2, 1.0}, 2000);
    } catch (const std::bad_any_cast& e) {
        // Handle cast error
    }
}

// Called before rendering
void onPreRender(void* owner, SCallbackInfo& info, std::any data) {
    try {
        auto monitor = std::any_cast<PHLMONITOR>(data);
        if (!monitor)
            return;
        
        // Later we'll capture workspace renders here
        static int frameCount = 0;
        if (++frameCount % 60 == 0) { // Log every 60 frames
            HyprlandAPI::addNotification(PHANDLE, 
                "[workspace-preview] Rendered 60 frames",
                CHyprColor{0.2, 0.2, 1.0, 1.0}, 1000);
        }
    } catch (const std::bad_any_cast& e) {
        // Handle cast error
    }
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;
    
    // Check version compatibility (temporarily disabled for testing)
    const std::string HASH = __hyprland_api_get_hash();
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, 
            "[workspace-preview] Warning: Version mismatch, but loading anyway for testing",
            CHyprColor{1.0, 0.8, 0.2, 1.0}, 5000);
        // Don't throw - continue loading
    }
    
    HyprlandAPI::addNotification(PHANDLE, 
        "[workspace-preview] Initialized successfully!",
        CHyprColor{0.2, 1.0, 0.2, 1.0}, 3000);
    
    // Register callbacks
    static auto P1 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "workspace", onWorkspaceChange);
    static auto P2 = HyprlandAPI::registerCallbackDynamic(PHANDLE, "preRender", onPreRender);
    
    // Add config values
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:enabled", Hyprlang::INT{1});
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:workspace-preview:scale", Hyprlang::FLOAT{0.2f});
    
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
        CHyprColor{1.0, 0.5, 0.2, 1.0}, 2000);
}