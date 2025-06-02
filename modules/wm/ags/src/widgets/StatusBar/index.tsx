import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";
import GLib from "gi://GLib";

export default function StatusBar() {
  // Time variables
  const time = Variable<string>("").poll(1000, () => 
    GLib.DateTime.new_now_local().format("%H:%M") || ""
  );
  
  const date = Variable<string>("").poll(60000, () =>
    GLib.DateTime.new_now_local().format("%b %d") || ""
  );

  // System stats (placeholder values for now)
  const cpuUsage = Variable(45);
  const memoryUsage = Variable(62);
  const diskUsage = Variable(38);

  return (
    <window
      name="statusbar"
      className="StatusBar"
      anchor={Astal.WindowAnchor.LEFT | Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
    >
      <box className="statusbar-container" orientation={1}>
        {/* Top Section - Logo/Launcher */}
        <button className="launcher-button">
          <label label="◉" />
        </button>

        {/* Workspaces */}
        <box className="workspaces" orientation={1}>
          {[1, 2, 3, 4, 5].map(i => (
            <button 
              className={`workspace ${i === 1 ? 'active' : ''}`}
            >
              <label label={i.toString()} />
            </button>
          ))}
        </box>

        <box className="section-separator" />

        {/* Middle Section - expand to fill space */}
        <box className="middle-section" vexpand={true} orientation={1}>
          {/* System Stats */}
          <box className="system-stats" orientation={1}>
            <box className="stat-item">
              <label className="stat-icon" label="⚡" />
              <box orientation={1}>
                <label className="stat-label" label="CPU" />
                <label className="stat-value" label={bind(cpuUsage).as(v => `${v}%`)} />
              </box>
            </box>
            
            <box className="stat-item">
              <label className="stat-icon" label="◧" />
              <box orientation={1}>
                <label className="stat-label" label="MEM" />
                <label className="stat-value" label={bind(memoryUsage).as(v => `${v}%`)} />
              </box>
            </box>
            
            <box className="stat-item">
              <label className="stat-icon" label="◉" />
              <box orientation={1}>
                <label className="stat-label" label="DISK" />
                <label className="stat-value" label={bind(diskUsage).as(v => `${v}%`)} />
              </box>
            </box>
          </box>

          {/* Quick Actions */}
          <box className="quick-actions" orientation={1}>
            <button className="action-button">
              <label label="🔊" />
            </button>
            <button className="action-button">
              <label label="🌐" />
            </button>
            <button className="action-button">
              <label label="🔋" />
            </button>
          </box>
        </box>

        <box className="section-separator" />

        {/* Bottom Section - Clock */}
        <box className="clock-section" orientation={1}>
          <label className="time" label={bind(time)} />
          <label className="date" label={bind(date)} />
        </box>

        {/* Power Button */}
        <button className="power-button">
          <label label="⏻" />
        </button>
      </box>
    </window>
  );
}
