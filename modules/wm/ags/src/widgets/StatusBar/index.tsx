import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function StatusBar() {
  // Placeholder workspaces for now
  const workspaces = [1, 2, 3, 4, 5];
  
  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      application={App}
    >
      <box className="bar-container" vertical>
        {/* Workspaces */}
        <box className="workspaces" vertical>
          {workspaces.map(ws => (
            <button 
              className={`workspace ws-${ws}`}
              onClick={() => console.log(`Workspace ${ws} clicked`)}
            >
              <label label={ws.toString()} />
            </button>
          ))}
        </box>
        
        {/* Spacer */}
        <box vexpand />
        
        {/* System tray placeholder */}
        <box className="system-tray" vertical>
          <label className="tray-icon" label="🔊" />
          <label className="tray-icon" label="🔋" />
          <label className="tray-icon" label="📶" />
        </box>
      </box>
    </window>
  );
}
