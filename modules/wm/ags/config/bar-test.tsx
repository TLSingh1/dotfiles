import { App, Astal, Gtk, Gdk } from "astal/gtk4"

const barStyle = `
.Bar {
    background-color: transparent;
}

.vertical-bar {
    background-color: #6750A4;
    min-width: 56px;
    padding: 8px;
    margin: 8px;
    border-radius: 16px;
}

.launcher {
    background-color: #EADDFF;
    color: #21005D;
    min-width: 40px;
    min-height: 40px;
    border-radius: 12px;
    margin-bottom: 8px;
    font-size: 20px;
}

.power-button {
    background-color: #BA1A1A;
    color: white;
    min-width: 40px;
    min-height: 40px;
    border-radius: 20px;
    margin-top: 8px;
    font-size: 20px;
}
`

function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
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

App.start({
    css: barStyle,
    main() {
        console.log("Bar test starting...")
        const monitors = App.get_monitors()
        console.log(`Found ${monitors.length} monitors`)
        
        Bar(monitors[0])
        console.log("Bar created")
    },
})