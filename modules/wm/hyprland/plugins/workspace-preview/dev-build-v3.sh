#!/usr/bin/env bash

# Development build script for v3 - builds the plugin with capture support

echo "Development build for workspace-preview plugin v3..."

# Enter nix shell with dependencies
nix develop -c bash << 'EOF'
echo "Compiling plugin with capture support..."

# Compile the v3 version
clang++ -std=c++23 -shared -fPIC \
  $(pkg-config --cflags pixman-1 libdrm hyprland wayland-server jsoncpp libpng) \
  $(pkg-config --libs jsoncpp libpng) \
  -o workspace-preview-v3.so \
  src/main-v3.cpp

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Plugin location: $(pwd)/workspace-preview-v3.so"
    echo ""
    echo "To test in current session:"
    echo "  hyprctl plugin load $(pwd)/workspace-preview-v3.so"
    echo ""
    echo "To test IPC after loading:"
    echo "  ./test-client.js"
else
    echo "Build failed!"
fi
EOF