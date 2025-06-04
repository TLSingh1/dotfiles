import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
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
                    <label label="◈" />
                </button>
                <Workspaces />
            </box>

            {/* Center spacer */}
            <box vexpand />

            {/* Bottom section */}
            <box vertical valign={Gtk.Align.END}>
                <button cssClasses={["power-button"]}>
                    <label label="◉" />
                </button>
            </box>
        </box>
    </window>
}
