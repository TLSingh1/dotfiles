#!/usr/bin/env fish

# Shim to make caelestia scripts work with quickshell
# This translates astal commands to quickshell IPC

if test "$argv[1]" = "-l"
    # Check if quickshell is running with caelestia config
    if qs list --all | grep -q caelestia
        echo "caelestia"
    end
else if test "$argv[1]" = "-i" -a "$argv[2]" = "caelestia"
    # Translate astal IPC to quickshell IPC
    set -l cmd $argv[3]
    set -l args $argv[4..]
    
    switch $cmd
        case "drawers"
            qs -c caelestia ipc call drawers $args
        case "mpris"
            qs -c caelestia ipc call mpris $args
        case "notifs"
            qs -c caelestia ipc call notifs $args
        case "wallpaper"
            qs -c caelestia ipc call wallpaper $args
        case '*'
            # Try passing through
            qs -c caelestia ipc call $cmd $args
    end
else
    echo "astal shim: Unknown command" >&2
    exit 1
end