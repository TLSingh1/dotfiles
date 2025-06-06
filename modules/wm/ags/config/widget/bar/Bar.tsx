import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import { Variable, bind } from "astal"
import { exec, execAsync } from "astal/process"
import Network from "astal4/network"
import Bluetooth from "astal4/bluetooth"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
    // Get hyprland monitor name from GDK monitor
    const getMonitorName = () => {
        try {
            const monitorModel = gdkmonitor.get_model()
            const monitorsJson = exec("hyprctl -j monitors")
            const monitors = JSON.parse(monitorsJson)
            
            // Find the monitor that matches this GDK monitor
            // For laptop display, the model might be different, so we check for specific patterns
            const monitor = monitors.find((m: any) => {
                if (monitorModel === "StudioDisplay" && m.model === "StudioDisplay") {
                    return true
                }
                // For laptop display, check if it's eDP-1
                if (m.name === "eDP-1" && monitorModel !== "StudioDisplay") {
                    return true
                }
                return false
            })
            
            return monitor ? monitor.name : "eDP-1" // Default to laptop if not found
        } catch (e) {
            console.error("Failed to get monitor name:", e)
            return "eDP-1" // Default to laptop on error
        }
    }
    
    const monitorName = getMonitorName()
    console.log(`Monitor ${gdkmonitor.get_model()} mapped to Hyprland monitor: ${monitorName}`)
    
    const updateDateTime = () => {
        const now = new Date()
        const date = now.toLocaleDateString("en", { month: "short", day: "numeric" })
        const time = now.toLocaleTimeString("en", { hour: "2-digit", minute: "2-digit", hour12: false })
        return { date, time }
    }
    
    const datetime = Variable(updateDateTime())
    
    const updateClock = () => {
        datetime.set(updateDateTime())
        
        const now = new Date()
        const msUntilNextMinute = (60 - now.getSeconds()) * 1000 - now.getMilliseconds()
        
        setTimeout(() => {
            updateClock()
            setInterval(updateClock, 60000)
        }, msUntilNextMinute)
    }
    
    updateClock()
    
    // Initialize network and bluetooth
    const network = new Network()
    const bluetooth = new Bluetooth()
    
    // Screenshot function
    const takeScreenshot = () => {
        execAsync(["grimblast", "copy", "area"])
            .then(() => console.log("Screenshot taken"))
            .catch(err => console.error("Screenshot failed:", err))
    }
    
    console.log("Creating bar for monitor:", gdkmonitor.get_model())

    const barWindow = <window
        visible={true}
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | BOTTOM | LEFT}
        layer={Astal.Layer.TOP}
        application={App}
        widthRequest={48}>
        <box
            cssClasses={["bar-container"]}
            valign={Gtk.Align.FILL}
            halign={Gtk.Align.FILL}>
            
            {/* Main vertical bar (always visible) */}
            <box
                cssClasses={["vertical-bar"]}
                vertical
                valign={Gtk.Align.FILL}>
                
                {/* Top section */}
                <box vertical valign={Gtk.Align.START}>
                    <button cssClasses={["launcher"]}>
                        <label label="◈" />
                    </button>
                    <Workspaces monitorName={monitorName} />
                </box>

                {/* Center spacer */}
                <box vexpand />

                {/* Bottom section */}
                <box vertical valign={Gtk.Align.END}>
                    {/* System control buttons */}
                    <box vertical spacing={8}>
                        {/* Screenshot button */}
                        <button 
                            cssClasses={["system-button", "screenshot-button"]}
                            onClicked={takeScreenshot}
                            tooltip-text="Take screenshot (area)">
                            <label label="📷" />
                        </button>
                        
                        {/* WiFi button */}
                        <button 
                            cssClasses={["system-button", "wifi-button"]}
                            tooltip-text={bind(network, "wifi").as(w => 
                                w ? `WiFi: ${w.ssid || "Connected"}` : "WiFi: Disconnected"
                            )}>
                            <label label={bind(network, "wifi").as(w => 
                                w ? "📶" : "📵"
                            )} />
                        </button>
                        
                        {/* Bluetooth button */}
                        <button 
                            cssClasses={["system-button", "bluetooth-button"]}
                            tooltip-text={bind(bluetooth, "isPowered").as(p => 
                                p ? "Bluetooth: On" : "Bluetooth: Off"
                            )}>
                            <label label={bind(bluetooth, "isPowered").as(p => 
                                p ? "🔷" : "🔸"
                            )} />
                        </button>
                    </box>
                    
                    {/* Performance bars */}
                    <box 
                        cssClasses={["performance-bars"]}
                        vertical
                        spacing={1}>
                        <box cssClasses={["perf-bar", "battery-bar"]} halign={Gtk.Align.FILL}>
                            <box cssClasses={["bar-fill"]} widthRequest={28} />
                        </box>
                        <box cssClasses={["perf-bar", "cpu-bar"]} halign={Gtk.Align.FILL}>
                            <box cssClasses={["bar-fill"]} widthRequest={24} />
                        </box>
                        <box cssClasses={["perf-bar", "memory-bar"]} halign={Gtk.Align.FILL}>
                            <box cssClasses={["bar-fill"]} widthRequest={32} />
                        </box>
                        <box cssClasses={["perf-bar", "gpu-bar"]} halign={Gtk.Align.FILL}>
                            <box cssClasses={["bar-fill"]} widthRequest={20} />
                        </box>
                    </box>
                    
                    <box vertical cssClasses={["clock"]}>
                        <label 
                            cssClasses={["date"]}
                            label={bind(datetime).as(dt => dt.date)}
                        />
                        <label 
                            cssClasses={["time"]}
                            label={bind(datetime).as(dt => dt.time)}
                        />
                    </box>
                    <button cssClasses={["power-button"]}>
                        <label label="◉" />
                    </button>
                </box>
            </box>
        </box>
    </window>
    
    return barWindow
}