import { App } from "astal/gtk3";
import Clock from "./widgets/Clock";
import style from "./styles/main.scss";

App.start({
    css: style,
    main() {
    // Initialize widgets
    Clock();
    },
}); 