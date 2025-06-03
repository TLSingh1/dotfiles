import { App } from "astal/gtk4"
import style from "./style.scss"
import Bar from "./widget/Bar"

App.start({
    css: style,
    main() {
        // Create bar only on primary monitor for testing
        Bar(App.get_monitors()[0])
    },
})
