import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import Launcher from "./Launcher"
import SystemIndicators from "./SystemIndicators"
import Clock from "./Clock"
import PowerButton from "./PowerButton"

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
                <Launcher />
                <Workspaces />
            </box>

            {/* Center spacer */}
            <box vexpand />

            {/* Bottom section */}
            <box vertical valign={Gtk.Align.END}>
                <SystemIndicators />
                <separator />
                <Clock />
                <PowerButton />
            </box>
        </box>
    </window>
}