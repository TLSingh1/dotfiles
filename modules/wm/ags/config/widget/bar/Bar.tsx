import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import Workspaces from "./Workspaces"
import { Variable, bind } from "astal"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor
    
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
                    <Workspaces />
                </box>

                {/* Center spacer */}
                <box vexpand />

                {/* Bottom section */}
                <box vertical valign={Gtk.Align.END}>
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