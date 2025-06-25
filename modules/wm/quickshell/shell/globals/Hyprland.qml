pragma Singleton
import QtQuick

// Hyprland IPC integration
QtObject {
    property int activeWorkspace: 1
    property var workspaces: [1, 2, 3]
    property string activeWindow: ""
    property string activeClass: ""
}