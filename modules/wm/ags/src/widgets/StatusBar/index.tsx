import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";

export default function StatusBar() {
  const hypr = Hyprland.get_default();
  
  // Time and date formatting
  const time = Variable(new Date()).poll(1000, () => new Date());

  const formatTime = (date: Date) => {
    const hours = date.getHours().toString().padStart(2, "0");
    const minutes = date.getMinutes().toString().padStart(2, "0");
    return `${hours}:${minutes}`;
  };

  const formatDate = (date: Date) => {
    const day = date.getDate().toString().padStart(2, "0");
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    return `${day}/${month}`;
  };

  // Workspace widget
  const Workspaces = () => {
    return (
      <box className="workspaces" vertical>
        {bind(hypr, "workspaces").as((wss) =>
          wss
            .sort((a, b) => a.id - b.id)
            .map((ws) => (
              <button
                className={bind(hypr, "focusedWorkspace").as((fw) =>
                  ws === fw ? "workspace active" : "workspace"
                )}
                onClicked={() => ws.focus()}
              >
                {ws.id}
              </button>
            ))
        )}
      </box>
    );
  };

  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      application={App}
    >
      <centerbox
        className="bar-container"
        vertical
        orientation={Gtk.Orientation.VERTICAL}
      >
        {/* Top section: Logo + Workspaces */}
        <box className="top-section" vertical>
          <label className="logo" label="󰣇" />
          <Workspaces />
        </box>

        {/* Center section: Empty for now */}
        <box />

        {/* Bottom section: Clock */}
        <box className="bottom-section" vertical>
          <label className="time" label={bind(time).as(formatTime)} />
          <label className="date" label={bind(time).as(formatDate)} />
        </box>
      </centerbox>
    </window>
  );
}
