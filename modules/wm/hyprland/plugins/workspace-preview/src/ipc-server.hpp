#pragma once

#include <string>
#include <functional>
#include <thread>
#include <atomic>

// Simple IPC server for AGS communication
class IPCServer {
public:
    IPCServer(const std::string& socketPath = "/tmp/hyprland-workspace-preview.sock");
    ~IPCServer();

    // Start the server
    bool start();
    void stop();

    // Set handler for preview requests
    using PreviewRequestHandler = std::function<std::string(int workspaceId)>;
    void setPreviewRequestHandler(PreviewRequestHandler handler);

private:
    void serverThread();

    std::string socketPath;
    int serverFd = -1;
    std::atomic<bool> running{false};
    std::thread serverThreadHandle;
    PreviewRequestHandler requestHandler;
};