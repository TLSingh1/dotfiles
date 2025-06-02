import { Variable, bind } from "astal";
import { App, Astal, Gtk, Gdk } from "astal/gtk3";

function WorkspaceSwitcher() {
  // For now, just show numbered workspace buttons without Hyprland integration
  const activeWorkspace = Variable(1);
  
  return (
    <box className="workspace-switcher" orientation={1} valign={Gtk.Align.CENTER}>
      {Array.from({ length: 10 }, (_, i) => i + 1).map((ws) => (
        <button
          className={bind(activeWorkspace).as((active) => 
            `workspace-btn ${active === ws ? "active" : ""}`
          )}
          onClicked={() => {
            activeWorkspace.set(ws);
            // TODO: Add Hyprland integration
          }}
        >
          <label label={ws.toString()} />
        </button>
      ))}
    </box>
  );
}

function SystemMetrics() {
  // Simple CPU and RAM usage
  const cpu = Variable(0).poll(2000, ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2}' | cut -d'%' -f1 || echo 0"]);
  const ram = Variable(0).poll(2000, ["bash", "-c", "free | grep Mem | awk '{print ($3/$2) * 100.0}' || echo 0"]);
  
  return (
    <box className="system-metrics" orientation={1} valign={Gtk.Align.END}>
      <box className="metric" orientation={1}>
        <label className="metric-label" label="CPU" />
        <label className="metric-value" label={bind(cpu).as(v => `${Math.round(Number(v) || 0)}%`)} />
      </box>
      <box className="metric" orientation={1}>
        <label className="metric-label" label="RAM" />
        <label className="metric-value" label={bind(ram).as(v => `${Math.round(Number(v) || 0)}%`)} />
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
        {/* System tray placeholder for now */}
        <box className="system-tray" orientation={1} valign={Gtk.Align.START}>
          <label label="☰" className="tray-placeholder" />
        </box>
        
        <box vexpand />
        <WorkspaceSwitcher />
        <box vexpand />
        <SystemMetrics />
        <DateTime />
      </box>
    </window>
  );
}
