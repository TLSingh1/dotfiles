import { Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable, bind } from "astal"
import Battery from "gi://AstalBattery"

export default function BatteryDial() {
    const battery = Battery.get_default()
    
    // Create a variable that updates with battery percentage
    const batteryPercent = Variable(battery ? battery.percentage : 0)
    const isCharging = Variable(battery ? battery.charging : false)
    
    // Update battery percentage when it changes
    if (battery) {
        battery.connect("notify::percentage", () => {
            batteryPercent.set(battery.percentage)
        })
        
        battery.connect("notify::charging", () => {
            isCharging.set(battery.charging)
        })
    }
    
    // Determine CSS classes based on battery state
    const cssClasses = Variable.derive(
        [batteryPercent, isCharging],
        (percent, charging) => {
            const classes = ["battery-dial", "stat-item"]
            if (charging) {
                classes.push("charging")
            } else if (percent <= 20) {
                classes.push("low")
            } else if (percent >= 100) {
                classes.push("full")
            }
            return classes
        }
    )
    
    // Create label text
    const labelText = Variable.derive(
        [batteryPercent, isCharging],
        (percent, charging) => {
            const icon = charging ? "⚡" : "🔋"
            return `${icon} ${Math.round(percent)}%`
        }
    )
    
    return <box
        cssClasses={bind(cssClasses)}
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}>
        <label
            label={bind(labelText)}
            cssClasses={["battery-label"]}
        />
    </box>
}