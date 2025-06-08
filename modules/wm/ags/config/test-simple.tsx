import { App, Astal, Gtk } from "astal/gtk4"

const testStyle = `
.test-window {
    background-color: transparent;
}

.test-box {
    background-color: red;
    min-width: 200px;
    min-height: 200px;
    padding: 20px;
}

.test-label {
    color: white;
    font-size: 24px;
    font-weight: bold;
}
`

App.start({
    css: testStyle,
    main() {
        console.log("Test app starting...")
        
        const window = <window
            visible={true}
            cssClasses={["test-window"]}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
            layer={Astal.Layer.TOP}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            application={App}>
            <box cssClasses={["test-box"]}>
                <label cssClasses={["test-label"]} label="TEST BOX" />
            </box>
        </window>
        
        console.log("Window created successfully")
    },
})