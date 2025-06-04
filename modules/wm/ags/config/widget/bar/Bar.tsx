import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import { Variable } from "astal"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
    const date = Variable("").poll(1000, () => {
        const now = new Date()
        return now.toLocaleDateString("en", { month: "short", day: "numeric" })
    })
    
    const time = Variable("").poll(1000, () => {
        const now = new Date()
        return now.toLocaleTimeString("en", { hour: "2-digit", minute: "2-digit", hour12: false })
    })
    
    console.log("Creating bar for monitor:", gdkmonitor.get_model())

    return <window
        visible={true}
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | BOTTOM | LEFT}
        layer={Astal.Layer.TOP}
        application={App}>
        <box
            cssClasses={["vertical-bar"]}
            vertical
            valign={Gtk.Align.FILL}>
            
            {/* Top section */}
            <box vertical valign={Gtk.Align.START}>
                <button cssClasses={["launcher"]}>
                    <icon 
                        icon="/home/tai/.dotfiles/modules/wm/ags/config/assets/nixos-flake.png"
                        pixelSize={20}
                    />
                </button>
                <Workspaces />
            </box>

            {/* Center spacer */}
            <box vexpand />

            {/* Bottom section */}
            <box vertical valign={Gtk.Align.END}>
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
    </window>
}
