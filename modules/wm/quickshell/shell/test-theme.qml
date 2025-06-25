import QtQuick
import Quickshell
import Quickshell.Io

// Simple test to verify Process and theme extraction work
ShellRoot {
    Component.onCompleted: {
        console.log("Testing theme extraction...")
        testProcess.running = true
    }
    
    Process {
        id: testProcess
        command: ["swww", "query"]
        
        stdout: SplitParser {
            onRead: data => {
                console.log("SWWW output:", data)
            }
        }
    }
    
    PanelWindow {
        anchors {
            bottom: true
            left: true
        }
        
        width: 200
        height: 50
        
        color: "black"
        
        Text {
            anchors.centerIn: parent
            text: "Test Window"
            color: "white"
        }
    }
}