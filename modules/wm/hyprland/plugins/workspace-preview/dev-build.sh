#!/usr/bin/env bash

# Development build script - builds the plugin manually

echo "Development build for workspace-preview plugin..."

# Enter nix shell with dependencies
nix develop -c bash << 'EOF'
echo "Compiling plugin..."

# Compile the v2 version
clang++ -std=c++23 -shared -fPIC \
  $(pkg-config --cflags pixman-1 libdrm hyprland wayland-server jsoncpp) \
  $(pkg-config --libs jsoncpp) \
  -o workspace-preview-v2.so \
  src/main-v2.cpp

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Plugin location: $(pwd)/workspace-preview-v2.so"
    echo ""
    echo "To test in current session:"
    echo "  hyprctl plugin load $(pwd)/workspace-preview-v2.so"
    echo ""
    echo "To test IPC after loading:"
    echo "  ./test-client.js"
else
    echo "Build failed!"
fi
EOF