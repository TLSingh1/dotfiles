import { App, Astal } from "astal/gtk4"

App.start({
    main() {
        console.log("Test app starting...")
        
        const window = <window
            visible={true}
            cssClasses={["test-window"]}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
            layer={Astal.Layer.TOP}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            application={App}>
            <box
                cssClasses={["test-box"]}
                css="background-color: red;"
                widthRequest={100}
                heightRequest={100}>
                <label label="TEST" />
            </box>
        </window>
        
        console.log("Window created:", window)
    },
})