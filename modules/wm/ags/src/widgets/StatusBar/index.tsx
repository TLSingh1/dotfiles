import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function StatusBar() {
  // Placeholder workspace data - will be replaced with Hyprland IPC later
  const workspaceData = [
    { id: 1, hasWindows: true, active: true },
    { id: 2, hasWindows: true, active: false },
    { id: 3, hasWindows: false, active: false },
    { id: 4, hasWindows: true, active: false },
    { id: 5, hasWindows: false, active: false },
  ];
  
  const getWorkspaceClass = (ws: typeof workspaceData[0]) => {
    let classes = ['workspace', `ws-${ws.id}`];
    
    if (ws.active) {
      classes.push('active');
    } else if (ws.hasWindows) {
      classes.push('occupied');
    } else {
      classes.push('empty');
    }
    
    return classes.join(' ');
  };
  
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
          {workspaceData.map(ws => (
            <button 
              className={getWorkspaceClass(ws)}
              onClick={() => console.log(`Workspace ${ws.id} clicked`)}
            >
              <box className="indicator" />
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
