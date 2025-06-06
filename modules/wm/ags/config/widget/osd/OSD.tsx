import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable, bind, timeout } from "astal"
import { exec, execAsync } from "astal/process"
import Wp from "gi://AstalWp"
import { Mpris } from "gi://AstalMpris"

export interface OSDProps {
  type: "volume" | "brightness" | "microphone" | "keyboard" | "workspace" | "media"
  icon: string
  value?: number
  label?: string
  muted?: boolean
}

const osdVisible = Variable(false)
const osdProps = Variable<OSDProps>({ type: "volume", icon: "audio-volume-high-symbolic" })
let hideTimeout: any = null

export function showOSD(props: OSDProps) {
  console.log("ShowOSD called with:", props)
  osdProps.set(props)
  osdVisible.set(true)

  // Clear existing timeout
  if (hideTimeout) {
    hideTimeout.cancel()
  }

  // Hide after 2 seconds
  hideTimeout = timeout(2000, () => {
    osdVisible.set(false)
  })
}

export default function OSD() {
  const { CENTER, BOTTOM } = Astal.WindowAnchor

  const getIcon = () => {
    const props = osdProps.get()
    if (props.type === "volume" && props.muted) {
      return "audio-volume-muted-symbolic"
    }
    if (props.type === "microphone" && props.muted) {
      return "microphone-disabled-symbolic"
    }
    return props.icon
  }

  const getProgressBar = () => {
    const props = osdProps.get()
    if (props.value !== undefined && props.value >= 0) {
      return (
        <box cssClasses={["osd-progress-container"]}>
          <box cssClasses={["osd-progress-bar"]}>
            <box
              cssClasses={["osd-progress-fill", `osd-${props.type}-fill`]}
              halign={Gtk.Align.START}
              widthRequest={bind(osdProps).as(p => Math.round((p.value || 0) * 3))}
            />
          </box>
          <label
            cssClasses={["osd-value"]}
            label={bind(osdProps).as(p => `${Math.round(p.value || 0)}%`)}
          />
        </box>
      )
    }
    return null
  }

  const getLabel = () => {
    const props = osdProps.get()
    if (props.label) {
      return (
        <label
          cssClasses={["osd-label"]}
          label={bind(osdProps).as(p => p.label || "")}
        />
      )
    }
    return null
  }

  return (
    <window
      visible={bind(osdVisible)}
      cssClasses={["osd-window"]}
      anchor={BOTTOM}
      layer={Astal.Layer.OVERLAY}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.NONE}
      application={App}>
      <revealer
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        transitionDuration={200}
        revealChild={bind(osdVisible)}>
        <box cssClasses={bind(osdProps).as(props => {
          const classes = ["osd-container"]

          // Add special classes based on state
          if (props.type === "volume" && props.muted) {
            classes.push("osd-muted")
          } else if (props.type === "microphone" && props.muted) {
            classes.push("osd-muted")
          } else if (props.type === "keyboard") {
            classes.push("osd-keyboard")
            if (props.label && props.label.includes("ON")) {
              classes.push("osd-caps-on")
            }
          } else if (props.type === "media") {
            classes.push("osd-media")
          } else if (props.type === "workspace") {
            classes.push("osd-workspace")
          }

          return classes
        })} vertical>
          <box cssClasses={["osd-icon-container"]}>
            <image
              cssClasses={["osd-icon"]}
              icon-name={bind(osdProps).as(_ => getIcon())}
              pixel-size={64}
            />
          </box>
          {bind(osdProps).as(props => {
            if (props.value !== undefined && props.value >= 0) {
              return (
                <box cssClasses={["osd-progress-container"]}>
                  <box cssClasses={["osd-progress-bar"]}>
                    <box
                      cssClasses={["osd-progress-fill", `osd-${props.type}-fill`]}
                      halign={Gtk.Align.START}
                      widthRequest={Math.round((props.value || 0) * 3)}
                    />
                  </box>
                  <label
                    cssClasses={["osd-value"]}
                    label={`${Math.round(props.value || 0)}%`}
                  />
                </box>
              )
            } else if (props.label) {
              return (
                <label
                  cssClasses={["osd-label"]}
                  label={props.label}
                />
              )
            }
            return null
          })}
        </box>
      </revealer>
    </window>
  )
}
