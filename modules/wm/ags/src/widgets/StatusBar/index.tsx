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

  // Workspace widget - fixed 1-10 workspaces
  const Workspaces = () => {
    const workspaceNumbers = Array.from({ length: 10 }, (_, i) => i + 1);
    
    return (
      <box className="workspaces" vertical>
        {workspaceNumbers.map((id) => (
          <button
            className={bind(hypr, "focusedWorkspace").as((fw) =>
              fw?.id === id ? "workspace active" : "workspace"
            )}
            onClicked={() => hypr.dispatch("workspace", id.toString())}
          >
            {id}
          </button>
        ))}
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
      <box
        className="bar-container"
        vertical
        orientation={Gtk.Orientation.VERTICAL}
      >
        {/* Top section: Logo + Workspaces */}
        <box className="top-section" vertical>
          <label className="logo" label="󱄅" />
          <Workspaces />
        </box>

        {/* Spacer to push clock to bottom */}
        <box vexpand />

        {/* Bottom section: Clock */}
        <box className="bottom-section" vertical>
          <label className="time" label={bind(time).as(formatTime)} />
          <label className="date" label={bind(time).as(formatDate)} />
        </box>
      </box>
    </window>
  );
}
