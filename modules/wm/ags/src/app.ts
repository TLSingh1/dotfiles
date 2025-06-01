import { App } from "astal/gtk3";
import Clock from "./widgets/Clock";
import style from "./styles/main.scss";

App.start({
  css: style,
  instanceName: "my-desktop",

  main() {
    // For now, just instantiate the clock widget
    Clock();
  },

  requestHandler(request: string, res: (response: any) => void) {
    // Handle CLI requests
    console.log("Received request:", request);
    res("Request received");
  },
});
