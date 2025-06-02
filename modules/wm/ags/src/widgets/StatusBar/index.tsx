import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";

export default function StatusBar() {
  // Get Hyprland instance
  const hyprland = Hyprland.get_default();
  
  // Time variable for the bottom section
  const time = Variable(new Date()).poll(1000, () => new Date());

  const formatTime = (date: Date) => {
    const hours = date.getHours().toString().padStart(2, "0");
    const minutes = date.getMinutes().toString().padStart(2, "0");
    return `${hours}:${minutes}`;
  };

  const formatDate = (date: Date) => {
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    const day = date.getDate().toString().padStart(2, "0");
    return `${month}/${day}`;
  };

  // Create workspace buttons
  const workspaceButtons = () => {
    return Array.from({ length: 5 }, (_, i) => i + 1).map(id => (
      <button
        className={bind(hyprland, "focusedWorkspace").as(fw => 
          fw.id === id ? "workspace active" : "workspace"
        )}
        onClick={() => hyprland.dispatch("workspace", id.toString())}
      >
        {id}
      </button>
    ));
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
        {/* Top section - empty placeholder */}
        <box className="top-section" vexpand />
        
        {/* Center section - workspace switcher */}
        <box className="center-section" vertical>
          {workspaceButtons()}
        </box>
        
        {/* Bottom section - date and time */}
        <box className="bottom-section" vertical>
          <label className="time" label={bind(time).as(formatTime)} />
          <label className="date" label={bind(time).as(formatDate)} />
        </box>
      </box>
    </window>
  );
}
