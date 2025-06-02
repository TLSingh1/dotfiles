import { Variable, bind } from "astal";
import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { Tray } from "astal/tray";
import { Hyprland } from "astal/hyprland";

const tray = Tray.get_default();
const hyprland = Hyprland.get_default();

function SystemTray() {
  return (
    <box className="system-tray" orientation={1} valign={Gtk.Align.START}>
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <button
            className="tray-item"
            onPrimaryClick={(_, event) => item.activate(event.x, event.y)}
            onSecondaryClick={(_, event) => item.openMenu(event.x, event.y)}
            tooltip_markup={bind(item, "tooltip_markup")}
          >
            <icon gIcon={bind(item, "gicon")} />
          </button>
        ))
      )}
    </box>
  );
}

function WorkspaceSwitcher() {
  const activeWs = bind(hyprland, "focusedWorkspace");
  
  return (
    <box className="workspace-switcher" orientation={1} valign={Gtk.Align.CENTER}>
      {Array.from({ length: 10 }, (_, i) => i + 1).map((ws) => (
        <button
          className={activeWs.as((active) => 
            `workspace-btn ${active?.id === ws ? "active" : ""}`
          )}
          onClicked={() => hyprland.dispatch("workspace", ws.toString())}
        >
          <label label={ws.toString()} />
        </button>
      ))}
    </box>
  );
}

function SystemMetrics() {
  // Simple CPU and RAM usage - in a real implementation, you'd want to use system monitoring
  const cpu = Variable(0).poll(2000, ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1"]);
  const ram = Variable(0).poll(2000, ["bash", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}'"]);
  
  return (
    <box className="system-metrics" orientation={1} valign={Gtk.Align.END}>
      <box className="metric">
        <label className="metric-label" label="CPU" />
        <label className="metric-value" label={bind(cpu).as(v => `${Math.round(v)}%`)} />
      </box>
      <box className="metric">
        <label className="metric-label" label="RAM" />
        <label className="metric-value" label={bind(ram).as(v => `${Math.round(v)}%`)} />
      </box>
    </box>
  );
}

function DateTime() {
  const time = Variable(new Date()).poll(1000, () => new Date());
  
  const formatTime = (date: Date) => {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };
  
  const formatDate = (date: Date) => {
    return date.toLocaleDateString([], { month: 'short', day: 'numeric' });
  };
  
  return (
    <box className="datetime" orientation={1} valign={Gtk.Align.END}>
      <label className="time" label={bind(time).as(formatTime)} />
      <label className="date" label={bind(time).as(formatDate)} />
    </box>
  );
}

export default function StatusBar() {
  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      application={App}
    >
      <box className="statusbar-container" orientation={1} vexpand>
        <SystemTray />
        <box vexpand />
        <WorkspaceSwitcher />
        <box vexpand />
        <SystemMetrics />
        <DateTime />
      </box>
    </window>
  );
}
