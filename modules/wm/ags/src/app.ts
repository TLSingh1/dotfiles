import { App } from "astal/gtk3";
import StatusBar from "./widgets/StatusBar";
import style from "./styles/main.scss";

App.start({
    css: style,
    main() {
    // Initialize widgets
    StatusBar();
    },
}); 