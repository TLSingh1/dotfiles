import { App, Astal, Gtk, Gdk } from "astal/gtk4"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor

    return <window
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | BOTTOM | LEFT}
        application={App}>
        <box
            cssClasses={["vertical-bar"]}
            vertical
            valign={Gtk.Align.FILL}>
            
            {/* Top section */}
            <box vertical valign={Gtk.Align.START}>
                <button cssClasses={["launcher"]}>
                    <label label="☰" />
                </button>
            </box>

            {/* Center spacer */}
            <box vexpand />

            {/* Bottom section */}
            <box vertical valign={Gtk.Align.END}>
                <button cssClasses={["power-button"]}>
                    <label label="⏻" />
                </button>
            </box>
        </box>
    </window>
}
