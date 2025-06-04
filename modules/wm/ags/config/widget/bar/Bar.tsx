import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import { Variable, bind } from "astal"
import { execAsync } from "astal/process"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
    // Bar expansion state: 'collapsed' | 'expanded' | 'expanding' | 'collapsing'
    const barState = Variable<string>("collapsed")
    const barWidth = Variable(48)  // Base width when collapsed
    const expandedWidth = 320      // Width when expanded
    
    const date = Variable("").poll(1000, () => {
        const now = new Date()
        return now.toLocaleDateString("en", { month: "short", day: "numeric" })
    })
    
    const time = Variable("").poll(1000, () => {
        const now = new Date()
        return now.toLocaleTimeString("en", { hour: "2-digit", minute: "2-digit", hour12: false })
    })
    
    // Handle bar expansion/collapse
    const toggleBarExpansion = () => {
        const currentState = barState.get()
        console.log("Toggle clicked, current state:", currentState)
        
        // Prevent multiple animations
        if (currentState === "expanding" || currentState === "collapsing") {
            return
        }
        
        if (currentState === "collapsed") {
            barState.set("expanding")
            // Animate width expansion
            const steps = 20
            const increment = (expandedWidth - 48) / steps
            let currentStep = 0
            
            const expand = setInterval(() => {
                currentStep++
                const newWidth = 48 + (increment * currentStep)
                barWidth.set(newWidth)
                
                if (currentStep >= steps) {
                    clearInterval(expand)
                    barState.set("expanded")
                    console.log("Expansion complete, width:", barWidth.get())
                }
            }, 15)
        } else if (currentState === "expanded") {
            barState.set("collapsing")
            // Animate width collapse
            const steps = 20
            const decrement = (expandedWidth - 48) / steps
            let currentStep = 0
            
            const collapse = setInterval(() => {
                currentStep++
                const newWidth = expandedWidth - (decrement * currentStep)
                barWidth.set(newWidth)
                console.log("Collapsing, step:", currentStep, "width:", newWidth)
                
                if (currentStep >= steps) {
                    clearInterval(collapse)
                    barState.set("collapsed")
                    barWidth.set(48) // Ensure final width is exact
                    console.log("Collapse complete, final width:", barWidth.get())
                }
            }, 15)
        }
    }
    
    console.log("Creating bar for monitor:", gdkmonitor.get_model())

    return <window
        visible={true}
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | BOTTOM | LEFT}
        layer={Astal.Layer.TOP}
        application={App}
        widthRequest={bind(barWidth)}>
        <box
            cssClasses={bind(barState).as(state => 
                state.includes("expand") ? ["bar-container", "bar-container-expanding"] : ["bar-container"]
            )}
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
                        {/* <icon 
                            icon="/home/tai/.dotfiles/modules/wm/ags/config/assets/nixos-flake.png"
                            pixelSize={20}
                        /> */}
                        <label label="◈" />
                    </button>
                    <Workspaces />
                </box>

                {/* Center spacer */}
                <box vexpand />

                {/* Bottom section */}
                <box vertical valign={Gtk.Align.END}>
                    {/* System tray toggle button */}
                    <button 
                        cssClasses={["system-tray-toggle"]}
                        onClicked={toggleBarExpansion}>
                        <label label={bind(barState).as(state => state === "collapsed" ? "⋮" : "×")} />
                    </button>
                    
                    <box vertical cssClasses={["clock"]}>
                        <label 
                            cssClasses={["date"]}
                            label={date()}
                        />
                        <label 
                            cssClasses={["time"]}
                            label={time()}
                        />
                    </box>
                    <button cssClasses={["power-button"]}>
                        <label label="◉" />
                    </button>
                </box>
            </box>
            
            {/* Expanded content area */}
            <box
                cssClasses={["expanded-content"]}
                visible={bind(barState).as(state => state === "expanded" || state === "expanding")}
                hexpand
                valign={Gtk.Align.FILL}>
                <box vertical spacing={12}>
                    <label cssClasses={["expanded-title"]} label="System Controls" />
                    
                    {/* Quick Actions Grid */}
                    <box cssClasses={["quick-actions"]} spacing={8}>
                        <button 
                            cssClasses={["quick-action-btn"]}
                            onClicked={() => execAsync("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")}>
                            <label label="🔊" />
                        </button>
                        <button 
                            cssClasses={["quick-action-btn"]}
                            onClicked={() => execAsync("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")}>
                            <label label="🎤" />
                        </button>
                        <button 
                            cssClasses={["quick-action-btn"]}
                            onClicked={() => execAsync("nmcli radio wifi toggle")}>
                            <label label="📡" />
                        </button>
                        <button 
                            cssClasses={["quick-action-btn"]}
                            onClicked={() => execAsync("bluetoothctl power toggle")}>
                            <label label="📶" />
                        </button>
                    </box>
                    
                    {/* System Stats */}
                    <box vertical cssClasses={["system-stats"]} spacing={8}>
                        <box spacing={8}>
                            <label cssClasses={["stat-label"]} label="CPU:" />
                            <label cssClasses={["stat-value"]} label="--%" />
                        </box>
                        <box spacing={8}>
                            <label cssClasses={["stat-label"]} label="RAM:" />
                            <label cssClasses={["stat-value"]} label="--%" />
                        </box>
                    </box>
                    
                    {/* Application Shortcuts */}
                    <box vertical cssClasses={["app-shortcuts"]} spacing={4}>
                        <label cssClasses={["section-title"]} label="Applications" />
                        <box spacing={6}>
                            <button 
                                cssClasses={["app-btn"]}
                                onClicked={() => execAsync("kitty &")}>
                                <label label="⌨️" />
                            </button>
                            <button 
                                cssClasses={["app-btn"]}
                                onClicked={() => execAsync("firefox &")}>
                                <label label="🌐" />
                            </button>
                            <button 
                                cssClasses={["app-btn"]}
                                onClicked={() => execAsync("thunar &")}>
                                <label label="📁" />
                            </button>
                        </box>
                    </box>
                </box>
            </box>
        </box>
    </window>
}
