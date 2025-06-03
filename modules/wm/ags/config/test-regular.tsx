import { App, Astal, Gtk } from "astal/gtk4"

const testStyle = `
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
        
        // Create a regular window, not a layer-shell window
        const window = new Gtk.Window({
            visible: true,
            defaultWidth: 300,
            defaultHeight: 300,
            application: App,
        })
        
        const box = <box cssClasses={["test-box"]}>
            <label cssClasses={["test-label"]} label="REGULAR WINDOW" />
        </box>
        
        window.set_child(box)
        
        console.log("Regular window created")
    },
})