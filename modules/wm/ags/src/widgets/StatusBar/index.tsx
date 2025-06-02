import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function StatusBar() {

  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.LEFT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
    >
      <box className="statusbar-container" orientation={1}>


      </box>
    </window>
  );
}
