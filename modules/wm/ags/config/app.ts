import { App } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./widget/bar/Bar"
import { WorkspacePreview } from "./widget/bar/WorkspacePreview"

App.start({
    css: style,
    main() {
        console.log("AGS starting...")
        const monitors = App.get_monitors()
        console.log(`Found ${monitors.length} monitors`)
        
        // Create bar only on primary monitor for testing
        const bar = Bar(monitors[0])
        console.log("Bar created:", bar)
        
        // Create workspace preview window
        const preview = WorkspacePreview()
        console.log("Preview window created:", preview)
    },
})
