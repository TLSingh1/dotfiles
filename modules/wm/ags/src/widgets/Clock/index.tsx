import { Variable, bind } from "astal";
import { App, Astal, Gtk } from "astal/gtk3";

export default function Clock() {
  // Update time every second
  const time = Variable(new Date()).poll(1000, () => new Date());

  const formatTime = (date: Date) => {
    const hours = date.getHours().toString().padStart(2, "0");
    const minutes = date.getMinutes().toString().padStart(2, "0");
    const seconds = date.getSeconds().toString().padStart(2, "0");
    return `${hours}:${minutes}:${seconds}`;
  };

  const formatDate = (date: Date) => {
    const days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    const dayName = days[date.getDay()];
    const day = date.getDate();
    const month = months[date.getMonth()];
    const year = date.getFullYear();

    return `${dayName}, ${month} ${day}, ${year}`;
  };

  return (
    <window
      name="clock"
      className="Clock"
      anchor={Astal.WindowAnchor.TOP}
      exclusivity={Astal.Exclusivity.NORMAL}
      layer={Astal.Layer.BACKGROUND}
      application={App}
    >
      <box className="clock-container" vertical>
        <label className="time" label={bind(time).as(formatTime)} />
        <label className="date" label={bind(time).as(formatDate)} />
      </box>
    </window>
  );
}
