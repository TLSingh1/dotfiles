#!/usr/bin/env bash

# Simple test script to run the clock widget in development

cd "$(dirname "$0")"

echo "Testing AGS Clock Widget..."
echo "Make sure you're in the development shell (nix develop)"
echo ""

# Check if we're in the src directory
if [ -d "src" ]; then
    cd src
    echo "Running clock widget..."
    ags run app.ts
else
    echo "Error: src directory not found!"
    echo "Make sure to run this from the modules/wm/ags directory"
    exit 1
fi 