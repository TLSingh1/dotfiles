#pragma once

#include <memory>
#include <vector>
#include <cstdint>
#include <optional>

struct WorkspacePreview {
    int workspaceId;
    int width;
    int height;
    uint64_t timestamp;
    std::vector<uint8_t> pixelData; // RGBA format
};

class PreviewRenderer {
public:
    PreviewRenderer();
    ~PreviewRenderer();

    // Request a preview for a specific workspace
    std::optional<WorkspacePreview> captureWorkspace(int workspaceId);
    
    // Get the last captured preview for a workspace
    std::optional<WorkspacePreview> getLastPreview(int workspaceId);

private:
    struct Impl;
    std::unique_ptr<Impl> pImpl;
};