import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";
import { LauncherService } from "../../services/launcher";

export default function Launcher() {
  const launcher = LauncherService.get();

  return (
    <window
      name="launcher"
      className="Launcher"
      visible={bind(launcher.isOpen)}
      keymode={Astal.Keymode.ON_DEMAND}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM}
      application={App}
    >
      <box className="launcher-container">
        {/* Search bar */}
        <entry
          className="search"
          placeholderText="Search applications..."
          text={bind(launcher.searchQuery)}
          onChanged={(self) => launcher.searchQuery.set(self.text)}
        />

        {/* Results will go here */}
        <scrollable className="results" vexpand>
          <box orientation={1}>{/* App grid will be populated here */}</box>
        </scrollable>
      </box>
    </window>
  );
}
