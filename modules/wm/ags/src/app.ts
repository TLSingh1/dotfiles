import { App } from "astal/gtk3";
import Clock from "./widgets/Clock";
import StatusBar from "./widgets/StatusBar";
import style from "./style.css";

App.start({
  css: style,
  main() {
    // Initialize widgets
    Clock();
    StatusBar();
  },
}); 
