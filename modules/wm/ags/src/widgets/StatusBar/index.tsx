import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function StatusBar() {
  // Placeholder for future status bar implementation

  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.BOTTOM
      }
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
    >
      <box className="statusbar-container" orientation={1}>
        {/* Workspace indicators will go here */}
        <box className="workspaces" />

        {/* Spacer */}
        <box vexpand />

        {/* System tray will go here */}
        <box className="system-tray" />
      </box>
    </window>
  );
}
