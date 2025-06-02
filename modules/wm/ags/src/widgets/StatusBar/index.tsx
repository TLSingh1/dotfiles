import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function StatusBar() {
  // Placeholder workspace data - will connect to Hyprland later
  const workspaces = [1, 2, 3, 4, 5];
  const activeWorkspace = Variable(1);

  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      application={App}
    >
      <box className="statusbar-container" orientation={1} valign={Gtk.Align.CENTER}>
        {/* Workspace indicators */}
        <box className="workspaces" orientation={1} spacing={8}>
          {workspaces.map(ws => (
            <button
              className={bind(activeWorkspace).as(active => 
                `workspace ${active === ws ? 'active' : ''}`
              )}
              onClick={() => activeWorkspace.set(ws)}
            >
              <label label={ws.toString()} />
            </button>
          ))}
        </box>

        {/* Separator */}
        <box className="separator" />

        {/* System tray placeholder */}
        <box className="system-tray" orientation={1} vexpand>
          <label label="Tray" />
        </box>
      </box>
    </window>
  );
}
