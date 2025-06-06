import { App } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./widget/bar/Bar"

App.start({
    css: style,
    main() {
        console.log("AGS starting...")
        const monitors = App.get_monitors()
        console.log(`Found ${monitors.length} monitors`)
        
        // Create a bar for each monitor
        monitors.forEach((monitor, index) => {
            console.log(`Creating bar for monitor ${index}:`, monitor.get_model())
            const bar = Bar(monitor)
            console.log(`Bar created for monitor ${index}:`, bar)
        })
    },
})
