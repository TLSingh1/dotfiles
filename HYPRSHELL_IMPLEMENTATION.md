# HyprShell Implementation Guide for Claude AI

**Purpose**: This document is specifically written for Claude AI agents implementing HyprShell. It contains all technical details, implementation notes, and architectural decisions needed to build this desktop environment shell.

## Project Context

You are building HyprShell - a complete desktop environment shell that goes beyond traditional window management. This is an ambitious project that integrates:
- System control center (expandable from left sidebar)
- AI assistant (right sidebar with Claude and Gemini)
- Google Calendar integration
- Cryptocurrency tracking
- Performance monitoring
- Network management
- Audio control
- Custom shaders for visual effects

The user wants a cohesive, beautiful, and highly functional desktop experience with a holographic/glassmorphic aesthetic.

## Critical Implementation Notes

### Current State
- Basic bar with workspaces is implemented at `/home/tai/.dotfiles/modules/wm/ags/config/widget/bar/Bar.tsx`
- Performance monitoring stacked bars are implemented
- Using AGS (Aylur's GTK Shell) with GTK4
- Hyprland as the Wayland compositor
- NixOS as the operating system

### Key Technical Constraints
1. **GTK CSS Limitations**: GTK's CSS subset doesn't support:
   - `height`, `width` properties (use `min-height`, `min-width`)
   - `position`, `overflow` properties
   - Multi-line gradient declarations (must be single line)
   - CSS variables (use actual values)

2. **Wayland Constraints**:
   - Screen capture requires portal implementation
   - Some X11 features unavailable

3. **Security Requirements**:
   - ALL credentials must use system keyring (gnome-keyring)
   - Never store passwords in plain text
   - OAuth tokens must be refreshed securely

### Available Astal Libraries
AGS/Astal provides several helper libraries that simplify system integration:

1. **AstalNetwork** - NetworkManager wrapper (replaces nmcli commands)
2. **AstalBluetooth** - Bluetooth control (replaces bluetoothctl)
3. **AstalWirePlumber** - Audio control (replaces pactl/pw-cli)
4. **AstalBattery** - Battery monitoring via UPower
5. **AstalPowerProfiles** - Power profile management
6. **AstalNotifd** - Notification daemon
7. **AstalHyprland** - Hyprland IPC wrapper
8. **AstalApps** - Application queries
9. **AstalTray** - System tray functionality
10. **AstalMpris** - Media player control
11. **AstalAuth** - PAM authentication
12. **AstalCava** - Audio visualization

These libraries significantly reduce implementation complexity and provide reactive bindings.

## Using Astal Libraries - Examples

### Battery Monitoring with AstalBattery
```typescript
import Battery from "gi://AstalBattery"

const BatteryIndicator = () => {
  const battery = Battery.get_default()
  
  return (
    <box cssClasses={["battery-indicator"]}>
      <icon icon={bind(battery, "batteryIconName")} />
      <label label={bind(battery, "percentage").as(p => `${Math.round(p)}%`)} />
      <label 
        visible={bind(battery, "charging")}
        label="⚡" 
        cssClasses={["charging-indicator"]}
      />
      <label 
        label={bind(battery, "timeToEmpty").as(seconds => {
          if (!seconds || seconds === 0) return ""
          const hours = Math.floor(seconds / 3600)
          const minutes = Math.floor((seconds % 3600) / 60)
          return `${hours}h ${minutes}m`
        })}
        cssClasses={["battery-time"]}
      />
    </box>
  )
}
```

### Hyprland Integration with AstalHyprland
```typescript
import Hyprland from "gi://AstalHyprland"

const WorkspaceIndicator = () => {
  const hypr = Hyprland.get_default()
  
  return (
    <box cssClasses={["workspaces"]}>
      {bind(hypr, "workspaces").as(workspaces => 
        workspaces.map(ws => (
          <button
            cssClasses={[
              "workspace",
              bind(hypr, "focusedWorkspace").as(focused => 
                focused.id === ws.id ? "active" : ""
              )
            ]}
            onClick={() => hypr.dispatch("workspace", ws.id.toString())}>
            <label label={ws.id.toString()} />
          </button>
        ))
      )}
    </box>
  )
}

// Window title display
const WindowTitle = () => {
  const hypr = Hyprland.get_default()
  
  return (
    <label 
      label={bind(hypr, "focusedClient").as(client => 
        client ? client.title : "Desktop"
      )}
      cssClasses={["window-title"]}
    />
  )
}
```

### Notification Handling with AstalNotifd
```typescript
import Notifd from "gi://AstalNotifd"

const NotificationCenter = () => {
  const notifd = Notifd.get_default()
  
  return (
    <box vertical cssClasses={["notification-center"]}>
      <box cssClasses={["notification-header"]}>
        <label label="Notifications" />
        <button onClick={() => notifd.clear()}>
          <label label="Clear All" />
        </button>
      </box>
      
      <scrollable vexpand>
        <box vertical>
          {bind(notifd, "notifications").as(notifs => 
            notifs.map(notif => (
              <box cssClasses={["notification"]} key={notif.id}>
                {notif.image && <icon icon={notif.image} />}
                <box vertical hexpand>
                  <label label={notif.summary} cssClasses={["notif-title"]} />
                  <label label={notif.body} cssClasses={["notif-body"]} />
                </box>
                <button onClick={() => notif.dismiss()}>
                  <icon icon="window-close" />
                </button>
              </box>
            ))
          )}
        </box>
      </scrollable>
    </box>
  )
}
```

### Media Player Control with AstalMpris
```typescript
import Mpris from "gi://AstalMpris"

const MediaPlayer = () => {
  const mpris = Mpris.get_default()
  const player = bind(mpris, "players").as(players => players[0])
  
  if (!player) return null
  
  return (
    <box cssClasses={["media-player"]} vertical>
      <box>
        {bind(player, "coverArt").as(art => 
          art ? <icon icon={art} /> : null
        )}
        <box vertical hexpand>
          <label label={bind(player, "title")} />
          <label label={bind(player, "artist")} cssClasses={["media-artist"]} />
        </box>
      </box>
      
      <box cssClasses={["media-controls"]}>
        <button onClick={() => player.previous()}>
          <icon icon="media-skip-backward" />
        </button>
        <button onClick={() => player.playPause()}>
          <icon icon={bind(player, "playbackStatus").as(status => 
            status === "Playing" ? "media-playback-pause" : "media-playback-start"
          )} />
        </button>
        <button onClick={() => player.next()}>
          <icon icon="media-skip-forward" />
        </button>
      </box>
      
      <slider
        value={bind(player, "position")}
        max={bind(player, "length")}
        onDragged={(self) => player.position = self.value}
      />
    </box>
  )
}
```

## Architecture Overview

### File Structure
```
/home/tai/.dotfiles/
├── modules/wm/
│   ├── ags/
│   │   └── config/
│   │       ├── app.ts              # Main application entry
│   │       ├── style.scss          # Global styles (GTK CSS)
│   │       └── widget/
│   │           ├── bar/
│   │           │   ├── Bar.tsx     # Current implementation
│   │           │   ├── Workspaces.tsx
│   │           │   ├── ControlCenter/
│   │           │   │   ├── ControlCenter.tsx
│   │           │   │   ├── tabs/
│   │           │   │   │   ├── SystemTab.tsx
│   │           │   │   │   ├── NetworkTab.tsx
│   │           │   │   │   ├── CalendarTab.tsx
│   │           │   │   │   ├── PerformanceTab.tsx
│   │           │   │   │   ├── CryptoTab.tsx
│   │           │   │   │   └── AudioTab.tsx
│   │           │   │   ├── services/
│   │           │   │   │   ├── NetworkService.ts
│   │           │   │   │   ├── CalendarService.ts
│   │           │   │   │   ├── CryptoService.ts
│   │           │   │   │   └── SystemMonitor.ts
│   │           │   │   └── components/
│   │           │   │       ├── QuickToggles.tsx
│   │           │   │       ├── NotificationToast.tsx
│   │           │   │       └── CommandPalette.tsx
│   │           │   └── AISidebar/
│   │           │       ├── AISidebar.tsx
│   │           │       ├── ClaudeService.ts
│   │           │       └── GeminiService.ts
│   │           └── common/
│   │               ├── Modal.tsx
│   │               ├── Slider.tsx
│   │               └── Chart.tsx
│   └── hyprland/
│       └── shaders/
│           ├── holographic.glsl
│           └── blue-light-filter.glsl
└── HYPRSHELL_SPEC.md              # This file
```

### State Management Pattern
```typescript
// Use AGS's Variable for reactive state
import { Variable } from "astal"

// Global state for control center
const controlCenterState = {
  isExpanded: Variable(false),
  activeTab: Variable<string>("system"),
  tabStates: new Map<string, any>(),
  expandedWidth: 850,
  collapsedWidth: 48
}

// Animation state machine
type AnimationState = 'idle' | 'expanding' | 'collapsing'
const animationState = Variable<AnimationState>('idle')
```

## Core Component Implementations

### 1. Control Center Expansion Mechanism

The control center starts as a 48px sidebar and expands to 850px when the launcher button is clicked.

```typescript
// In Bar.tsx - Update the existing implementation
const toggleControlCenter = () => {
  const currentState = controlCenterState.isExpanded.get()
  
  if (animationState.get() !== 'idle') return // Prevent animation conflicts
  
  if (!currentState) {
    // Expanding
    animationState.set('expanding')
    
    // Create overlay window for backdrop
    const overlay = Widget.Window({
      name: 'control-center-overlay',
      layer: Astal.Layer.OVERLAY,
      exclusivity: Astal.Exclusivity.IGNORE,
      anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM | 
              Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT,
      visible: true,
      child: Widget.Box({
        css: 'background: rgba(0,0,0,0.5);', // Semi-transparent backdrop
        setup: (self) => {
          self.on('button-press-event', () => {
            toggleControlCenter() // Close on backdrop click
          })
        }
      })
    })
    
    // Animate width
    const startTime = Date.now()
    const animate = () => {
      const elapsed = Date.now() - startTime
      const progress = Math.min(elapsed / 300, 1)
      
      // Cubic bezier easing
      const eased = cubicBezier(0.4, 0.0, 0.2, 1, progress)
      const width = 48 + (850 - 48) * eased
      
      barWindow.widthRequest = width
      
      if (progress < 1) {
        GLib.idle_add(GLib.PRIORITY_DEFAULT, animate)
      } else {
        animationState.set('idle')
        controlCenterState.isExpanded.set(true)
      }
    }
    
    animate()
  } else {
    // Collapsing - reverse animation
    // Similar logic but in reverse
  }
}

// Add to launcher button
<button 
  cssClasses={["launcher"]}
  onClicked={toggleControlCenter}>
  <label label="◈" />
</button>
```

### 2. Tab System Implementation

Each tab is lazy-loaded to optimize memory usage.

```typescript
// ControlCenter.tsx
interface Tab {
  id: string
  label: string
  icon: string
  component: () => Widget.Box
  loaded: boolean
}

const tabs: Tab[] = [
  { id: 'system', label: 'System', icon: '⚙️', component: SystemTab, loaded: false },
  { id: 'network', label: 'Network', icon: '📡', component: NetworkTab, loaded: false },
  { id: 'calendar', label: 'Calendar', icon: '📅', component: CalendarTab, loaded: false },
  { id: 'performance', label: 'Performance', icon: '📊', component: PerformanceTab, loaded: false },
  { id: 'crypto', label: 'Crypto', icon: '🪙', component: CryptoTab, loaded: false },
  { id: 'audio', label: 'Audio', icon: '🎵', component: AudioTab, loaded: false }
]

const renderControlCenter = () => (
  <box cssClasses={["control-center"]} vertical>
    {/* Tab bar */}
    <box cssClasses={["tab-bar"]} homogeneous>
      {tabs.map(tab => (
        <button
          cssClasses={[
            "tab-button",
            controlCenterState.activeTab.bind().as(active => 
              active === tab.id ? "active" : ""
            )
          ]}
          onClicked={() => {
            controlCenterState.activeTab.set(tab.id)
            // Load tab if not already loaded
            if (!tab.loaded) {
              tab.loaded = true
              // Initialize tab-specific services
            }
          }}>
          <label label={`${tab.icon} ${tab.label}`} />
        </button>
      ))}
    </box>
    
    {/* Tab content */}
    <stack
      cssClasses={["tab-content"]}
      shown={controlCenterState.activeTab.bind()}>
      {tabs.map(tab => (
        <box name={tab.id}>
          {tab.loaded ? tab.component() : <label label="Loading..." />}
        </box>
      ))}
    </stack>
  </box>
)
```

### 3. Notification System & Center

All async operations must show status notifications. The notification center integrates with system notifications via AstalNotifd.

```typescript
// NotificationService.ts - Enhanced with system notification integration
import Notifd from "gi://AstalNotifd"

interface Notification {
  id: string
  type: 'info' | 'success' | 'error' | 'progress'
  title: string
  body?: string
  progress?: number
  timeout?: number
  actions?: Array<{ label: string; callback: () => void }>
  appName?: string
  appIcon?: string
  timestamp: Date
  urgency?: 'low' | 'normal' | 'critical'
}

class NotificationService {
  private notifications = Variable<Notification[]>([])
  private systemNotifications = Variable<Notification[]>([])
  private nextId = 1
  private notifd = Notifd.get_default()
  
  constructor() {
    // Capture system notifications
    this.notifd.connect("notified", (_, notif) => {
      const sysNotif: Notification = {
        id: `sys-${notif.id}`,
        type: this.urgencyToType(notif.urgency),
        title: notif.summary,
        body: notif.body,
        appName: notif.appName,
        appIcon: notif.appIcon,
        timestamp: new Date(notif.time * 1000),
        urgency: notif.urgency,
        actions: notif.actions.map(action => ({
          label: action.label,
          callback: () => notif.invoke(action.id)
        }))
      }
      
      this.systemNotifications.set([sysNotif, ...this.systemNotifications.get()])
      this.saveToHistory(sysNotif)
    })
  }
  
  private urgencyToType(urgency: number): Notification['type'] {
    switch (urgency) {
      case 0: return 'info'
      case 1: return 'info'
      case 2: return 'error'
      default: return 'info'
    }
  }
  
  show(notification: Omit<Notification, 'id' | 'timestamp'>): string {
    const id = `notif-${this.nextId++}`
    const notif = { 
      ...notification, 
      id,
      timestamp: new Date(),
      appName: 'HyprShell',
      appIcon: 'shell-symbolic'
    }
    
    this.notifications.set([notif, ...this.notifications.get()])
    
    // Auto-dismiss success notifications
    if (notif.type === 'success' && !notif.timeout) {
      setTimeout(() => this.dismiss(id), 3000)
    }
    
    return id
  }
  
  update(id: string, updates: Partial<Notification>) {
    const notifs = this.notifications.get()
    const index = notifs.findIndex(n => n.id === id)
    if (index >= 0) {
      notifs[index] = { ...notifs[index], ...updates }
      this.notifications.set([...notifs])
    }
  }
  
  dismiss(id: string) {
    this.notifications.set(
      this.notifications.get().filter(n => n.id !== id)
    )
  }
  
  getAllNotifications(): Notification[] {
    return [...this.notifications.get(), ...this.systemNotifications.get()]
      .sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
  }
  
  private saveToHistory(notif: Notification) {
    // Save to file for persistence
    const historyPath = GLib.get_user_cache_dir() + '/hyprshell/notifications.json'
    // Implementation details...
  }
}

// Usage example in WiFi connection
async connectToWiFi(ap: Network.AccessPoint, password: string) {
  const notifId = notificationService.show({
    type: 'progress',
    title: 'WiFi Connection',
    body: `Connecting to ${ap.ssid}...`
  })
  
  try {
    // Store password securely
    await execAsync(`secret-tool store --label="WiFi: ${ap.ssid}" service wifi ssid "${ap.ssid}"`, {
      stdin: password
    })
    
    // Connect using Astal Network
    const network = Network.get_default()
    await network.wifi.connect_to_access_point(ap, password)
    
    notificationService.update(notifId, {
      type: 'success',
      title: 'WiFi Connected',
      body: `Successfully connected to ${ap.ssid}`
    })
  } catch (error) {
    notificationService.update(notifId, {
      type: 'error',
      title: 'WiFi Connection Failed',
      body: error.message,
      timeout: 0 // Don't auto-dismiss errors
    })
  }
}
```

### 4. System Tab Implementation

```typescript
// SystemTab.tsx
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
import PowerProfiles from "gi://AstalPowerProfiles"

const SystemTab = () => {
  const network = Network.get_default()
  const bluetooth = Bluetooth.get_default()
  const powerProfiles = PowerProfiles.get_default()
  
  const toggles = [
    { 
      id: 'wifi', 
      label: 'WiFi', 
      icon: '📡', 
      active: bind(network.wifi, "enabled"),
      onToggle: (active: boolean) => network.wifi.enabled = active
    },
    { 
      id: 'bluetooth', 
      label: 'Bluetooth', 
      icon: '🦷', 
      active: bind(bluetooth, "enabled"),
      onToggle: (active: boolean) => bluetooth.enabled = active
    },
    { id: 'airplane', label: 'Airplane', icon: '✈️', active: Variable(false) },
    { id: 'dnd', label: 'Do Not Disturb', icon: '🔕', active: Variable(false) },
    { id: 'night-light', label: 'Night Light', icon: '🌙', active: Variable(false) }, // Shader toggle
    { id: 'location', label: 'Location', icon: '📍', active: Variable(false) },
    { id: 'vpn', label: 'VPN', icon: '🔐', active: Variable(false) },
    { id: 'caffeine', label: 'Caffeine', icon: '☕', active: Variable(false) },
    { id: 'screenshot', label: 'Screenshot', icon: '📸', active: Variable(false) },
    { id: 'dynamic-colors', label: 'Dynamic Colors', icon: '🎨', active: Variable(false) },
    { id: 'dark-mode', label: 'Dark Mode', icon: '🌓', active: Variable(false) },
    { id: 'gaming-mode', label: 'Gaming Mode', icon: '🎮', active: Variable(false) }
  ]
  
  return (
    <box vertical cssClasses={["system-tab"]} spacing={12}>
      {/* Quick toggles grid */}
      <grid cssClasses={["quick-toggles"]} columnSpacing={8} rowSpacing={8}>
        {toggles.map((toggle, i) => (
          <button
            cssClasses={["toggle-button"]}
            setup={(self) => {
              // Set grid position
              self.attach(self.get_parent(), i % 3, Math.floor(i / 3), 1, 1)
            }}
            onClicked={() => handleToggle(toggle)}>
            <box vertical>
              <label cssClasses={["toggle-icon"]} label={toggle.icon} />
              <label cssClasses={["toggle-label"]} label={toggle.label} />
            </box>
          </button>
        ))}
      </grid>
      
      {/* Sliders */}
      <box vertical cssClasses={["sliders-section"]} spacing={8}>
        <VolumeSlider />
        <BrightnessSlider />
        <MicrophoneSlider />
      </box>
      
      {/* Command palette button */}
      <button
        cssClasses={["command-palette-btn"]}
        onClicked={() => commandPalette.open()}>
        <box spacing={8}>
          <label label="🔍" />
          <label label="Command Palette" />
          <box hexpand />
          <label label="Ctrl+K" cssClasses={["shortcut-hint"]} />
        </box>
      </button>
      
      {/* System info */}
      <box cssClasses={["system-info"]}>
        <label label={`Uptime: ${getUptime()}`} />
      </box>
    </box>
  )
}

// Audio Control Components using AstalWirePlumber
import Wp from "gi://AstalWp"

const VolumeSlider = () => {
  const audio = Wp.get_default()?.audio
  if (!audio) return null
  
  const speaker = audio.defaultSpeaker
  
  return (
    <box cssClasses={["volume-control"]} spacing={8}>
      <icon icon={bind(speaker, "volumeIcon")} />
      <slider
        hexpand
        value={bind(speaker, "volume")}
        onDragged={(self) => speaker.volume = self.value}
      />
      <label label={bind(speaker, "volume").as(v => `${Math.round(v * 100)}%`)} />
      <button
        onClick={() => speaker.muted = !speaker.muted}>
        <icon icon={bind(speaker, "muted").as(m => m ? "audio-volume-muted" : "audio-volume-high")} />
      </button>
    </box>
  )
}

const MicrophoneSlider = () => {
  const audio = Wp.get_default()?.audio
  if (!audio) return null
  
  const mic = audio.defaultMicrophone
  
  return (
    <box cssClasses={["mic-control"]} spacing={8}>
      <icon icon={bind(mic, "volumeIcon")} />
      <slider
        hexpand
        value={bind(mic, "volume")}
        onDragged={(self) => mic.volume = self.value}
      />
      <label label={bind(mic, "volume").as(v => `${Math.round(v * 100)}%`)} />
      <button
        onClick={() => mic.muted = !mic.muted}>
        <icon icon={bind(mic, "muted").as(m => m ? "microphone-disabled" : "microphone-sensitivity-high")} />
      </button>
    </box>
  )
}

const BrightnessSlider = () => {
  const brightness = Variable(1.0)
  
  // Get current brightness
  execAsync("brightnessctl get").then(val => {
    const max = execAsync("brightnessctl max")
    brightness.set(parseInt(val) / parseInt(max))
  })
  
  return (
    <box cssClasses={["brightness-control"]} spacing={8}>
      <icon icon="display-brightness-symbolic" />
      <slider
        hexpand
        value={brightness.bind()}
        onDragged={(self) => {
          brightness.set(self.value)
          execAsync(`brightnessctl set ${Math.round(self.value * 100)}%`)
        }}
      />
      <label label={brightness.bind().as(v => `${Math.round(v * 100)}%`)} />
    </box>
  )
}

// NotificationCenter.tsx - UI Component for System Tab
const NotificationCenter = () => {
  const notificationService = new NotificationService()
  const searchQuery = Variable("")
  const groupByApp = Variable(true)
  const expandedGroups = Variable<Set<string>>(new Set())
  const isExpanded = Variable(false)
  
  const filteredNotifications = Variable.derive([
    bind(notificationService, "getAllNotifications"),
    searchQuery
  ], (notifs, query) => {
    if (!query) return notifs
    const lowerQuery = query.toLowerCase()
    return notifs.filter(n => 
      n.title.toLowerCase().includes(lowerQuery) ||
      n.body?.toLowerCase().includes(lowerQuery) ||
      n.appName?.toLowerCase().includes(lowerQuery)
    )
  })
  
  const groupedNotifications = Variable.derive([
    filteredNotifications,
    groupByApp
  ], (notifs, group) => {
    if (!group) return { ungrouped: notifs }
    
    const groups: Record<string, Notification[]> = {}
    notifs.forEach(notif => {
      const key = notif.appName || 'System'
      if (!groups[key]) groups[key] = []
      groups[key].push(notif)
    })
    return groups
  })
  
  return (
    <box vertical cssClasses={["notification-center-container"]}>
      {/* Collapsed Header */}
      <button
        cssClasses={["notification-header", bind(isExpanded).as(e => e ? "expanded" : "")]}
        onClick={() => isExpanded.set(!isExpanded.get())}>
        <icon icon={bind(isExpanded).as(e => e ? "pan-down-symbolic" : "pan-end-symbolic")} />
        <label label="Notifications" />
        <box hexpand />
        {/* Show active operations count */}
        {bind(notificationService.notifications).as(notifs => {
          const active = notifs.filter(n => n.type === 'progress').length
          return active > 0 ? (
            <box cssClasses={["active-count"]}>
              <spinner active />
              <label label={`${active}`} />
            </box>
          ) : null
        })}
        {/* Total notification count */}
        <label 
          label={bind(notificationService, "getAllNotifications").as(n => `${n.length}`)} 
          cssClasses={["notification-badge"]}
        />
      </button>
      
      <revealer
        revealChild={isExpanded.bind()}
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        <box vertical cssClasses={["notification-center"]} spacing={12}>
          {/* Active Operations */}
          <box vertical cssClasses={["active-operations"]}>
            <label label="Active Operations" cssClasses={["section-title"]} />
            {bind(notificationService.notifications).as(notifs => 
              notifs.filter(n => n.type === 'progress').map(notif => (
                <box key={notif.id} cssClasses={["operation-item"]}>
                  <spinner active />
                  <box vertical hexpand>
                    <label label={notif.title} />
                    {notif.body && <label label={notif.body} cssClasses={["operation-details"]} />}
                    {notif.progress !== undefined && (
                      <progressbar value={notif.progress} cssClasses={["operation-progress"]} />
                    )}
                  </box>
                  <button onClick={() => notificationService.dismiss(notif.id)}>
                    <icon icon="window-close" />
                  </button>
                </box>
              ))
            )}
          </box>
          
          {/* Notification History */}
          <box vertical cssClasses={["notification-history"]} vexpand>
            <box cssClasses={["history-header"]}>
              <label label="History" cssClasses={["section-title"]} />
              <box hexpand />
              <togglebutton
                active={groupByApp.bind()}
                onToggled={(active) => groupByApp.set(active)}>
                <icon icon="view-list-symbolic" />
              </togglebutton>
              <button onClick={() => notificationService.clearAll()}>
                <label label="Clear" />
              </button>
            </box>
            
            {/* Search */}
            <entry
              placeholder="Search notifications..."
              cssClasses={["notification-search"]}
              onChange={(text) => searchQuery.set(text)}
            />
            
            {/* Grouped Notifications */}
            <scrollable vexpand cssClasses={["notification-scroll"]}>
              <box vertical>
                {bind(groupedNotifications).as(groups => 
                  Object.entries(groups).map(([appName, notifs]) => (
                    <box vertical key={appName} cssClasses={["notification-group"]}>
                      {groupByApp.get() && (
                        <button
                          cssClasses={["group-header"]}
                          onClick={() => {
                            const expanded = expandedGroups.get()
                            if (expanded.has(appName)) {
                              expanded.delete(appName)
                            } else {
                              expanded.add(appName)
                            }
                            expandedGroups.set(new Set(expanded))
                          }}>
                          <icon icon={bind(expandedGroups).as(exp => 
                            exp.has(appName) ? "pan-down-symbolic" : "pan-end-symbolic"
                          )} />
                          <label label={appName} />
                          <box hexpand />
                          <label label={`${notifs.length}`} cssClasses={["notification-count"]} />
                        </button>
                      )}
                      
                      <revealer
                        revealChild={!groupByApp.get() || bind(expandedGroups).as(exp => exp.has(appName))}>
                        <box vertical cssClasses={["group-notifications"]}>
                          {notifs.slice(0, 50).map(notif => (
                            <NotificationItem key={notif.id} notification={notif} />
                          ))}
                        </box>
                      </revealer>
                    </box>
                  ))
                )}
              </box>
            </scrollable>
          </box>
        </box>
      </revealer>
    </box>
  )
}

const NotificationItem = ({ notification }: { notification: Notification }) => {
  const formatTime = (date: Date) => {
    const now = new Date()
    const diff = now.getTime() - date.getTime()
    const minutes = Math.floor(diff / 60000)
    const hours = Math.floor(diff / 3600000)
    const days = Math.floor(diff / 86400000)
    
    if (minutes < 1) return 'Just now'
    if (minutes < 60) return `${minutes}m ago`
    if (hours < 24) return `${hours}h ago`
    return `${days}d ago`
  }
  
  return (
    <box cssClasses={["notification-item", `type-${notification.type}`]}>
      {notification.appIcon && <icon icon={notification.appIcon} />}
      <box vertical hexpand>
        <box>
          <label label={notification.title} cssClasses={["notification-title"]} />
          <box hexpand />
          <label label={formatTime(notification.timestamp)} cssClasses={["notification-time"]} />
        </box>
        {notification.body && (
          <label label={notification.body} cssClasses={["notification-body"]} wrap />
        )}
        {notification.actions && notification.actions.length > 0 && (
          <box cssClasses={["notification-actions"]} spacing={4}>
            {notification.actions.map((action, i) => (
              <button key={i} onClick={action.callback} cssClasses={["notification-action"]}>
                <label label={action.label} />
              </button>
            ))}
          </box>
        )}
      </box>
    </box>
  )
}
```

### 5. Network Tab Implementation

```typescript
// NetworkTab.tsx
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"

const NetworkTab = () => {
  const network = Network.get_default()
  const bluetooth = Bluetooth.get_default()
  const wifi = network.wifi
  
  return (
    <box vertical cssClasses={["network-tab"]} spacing={12}>
      {/* WiFi Section */}
      <box vertical cssClasses={["wifi-section"]}>
        <box cssClasses={["section-header"]}>
          <label label="WiFi Networks" cssClasses={["section-title"]} />
          <box hexpand />
          <switch 
            active={bind(wifi, "enabled")}
            onToggled={(self) => wifi.enabled = self.active}
          />
          <button
            cssClasses={["scan-button"]}
            sensitive={bind(wifi, "scanning").as(s => !s)}
            onClicked={() => wifi.scan()}>
            <label label={bind(wifi, "scanning").as(s => s ? "Scanning..." : "Scan")} />
          </button>
        </box>
        
        <scrollable vscroll={Gtk.PolicyType.AUTOMATIC} cssClasses={["network-list"]}>
          <box vertical>
            {bind(wifi, "accessPoints").as(aps => 
              aps.sort((a, b) => b.strength - a.strength).map(ap => (
                <button
                  cssClasses={["network-item", bind(wifi, "activeAccessPoint").as(active => 
                    active?.ssid === ap.ssid ? "active" : ""
                  )]}
                  onClick={() => connectToAccessPoint(ap)}>
                  <icon icon={ap.iconName} />
                  <box vertical hexpand>
                    <label label={ap.ssid || "Hidden Network"} />
                    <label label={`${ap.strength}% - ${ap.security}`} cssClasses={["network-details"]} />
                  </box>
                  {bind(wifi, "activeAccessPoint").as(active => 
                    active?.ssid === ap.ssid && <icon icon="object-select-symbolic" />
                  )}
                </button>
              ))
            )}
          </box>
        </scrollable>
      </box>
      
      {/* Bluetooth Section */}
      <box vertical cssClasses={["bluetooth-section"]}>
        <box cssClasses={["section-header"]}>
          <label label="Bluetooth Devices" cssClasses={["section-title"]} />
          <box hexpand />
          <switch 
            active={bind(bluetooth, "enabled")}
            onToggled={(self) => bluetooth.enabled = self.active}
          />
        </box>
        
        <scrollable vscroll={Gtk.PolicyType.AUTOMATIC} cssClasses={["device-list"]}>
          <box vertical>
            {bind(bluetooth, "devices").as(devices => 
              devices.map(device => (
                <button
                  cssClasses={["bluetooth-item", device.connected ? "connected" : ""]}
                  onClick={() => device.connected ? device.disconnect() : device.connect()}>
                  <icon icon={device.iconName} />
                  <box vertical hexpand>
                    <label label={device.name} />
                    <label label={device.connected ? "Connected" : "Available"} cssClasses={["device-status"]} />
                  </box>
                </button>
              ))
            )}
          </box>
        </scrollable>
      </box>
    </box>
  )
}

// WiFi password modal
const showPasswordModal = (network: WifiNetwork): Promise<string> => {
  return new Promise((resolve, reject) => {
    const password = Variable("")
    const showPassword = Variable(false)
    
    const modal = Widget.Window({
      name: 'wifi-password-modal',
      layer: Astal.Layer.OVERLAY,
      keymode: Astal.KeyMode.EXCLUSIVE,
      visible: true,
      child: Widget.Box({
        cssClasses: ['modal-container'],
        child: Widget.Box({
          vertical: true,
          cssClasses: ['modal-content'],
          spacing: 12,
          children: [
            Widget.Label({
              label: `Connect to ${network.ssid}`,
              cssClasses: ['modal-title']
            }),
            Widget.Box({
              children: [
                Widget.Entry({
                  placeholder: 'Enter password',
                  visibility: showPassword.bind().as(v => !v),
                  onChange: (text) => password.set(text),
                  onActivate: () => handleConnect()
                }),
                Widget.Button({
                  child: Widget.Label({ 
                    label: showPassword.bind().as(v => v ? '👁️' : '👁️‍🗨️')
                  }),
                  onClicked: () => showPassword.set(!showPassword.get())
                })
              ]
            }),
            Widget.Box({
              spacing: 8,
              homogeneous: true,
              children: [
                Widget.Button({
                  label: 'Cancel',
                  onClicked: () => {
                    modal.destroy()
                    reject(new Error('User cancelled'))
                  }
                }),
                Widget.Button({
                  label: 'Connect',
                  cssClasses: ['suggested-action'],
                  onClicked: handleConnect
                })
              ]
            })
          ]
        })
      })
    })
    
    const handleConnect = () => {
      const pw = password.get()
      if (pw.length < 8) {
        // Show error
        return
      }
      modal.destroy()
      resolve(pw)
    }
  })
}
```

### 6. Calendar Tab Implementation

```typescript
// CalendarService.ts
class GoogleCalendarService {
  private clientId = process.env.GOOGLE_CALENDAR_CLIENT_ID
  private clientSecret = process.env.GOOGLE_CALENDAR_CLIENT_SECRET
  private redirectUri = 'http://localhost:8080/callback'
  
  async authenticate() {
    // Check existing token
    try {
      const token = await execAsync('secret-tool lookup service hyprshell-calendar')
      const parsed = JSON.parse(token)
      if (parsed.expires_at > Date.now()) {
        return parsed.access_token
      }
    } catch {
      // No valid token
    }
    
    // OAuth flow
    const state = generateRandomString()
    const authUrl = `https://accounts.google.com/o/oauth2/v2/auth?${new URLSearchParams({
      client_id: this.clientId,
      redirect_uri: this.redirectUri,
      response_type: 'code',
      scope: 'https://www.googleapis.com/auth/calendar',
      state,
      access_type: 'offline',
      prompt: 'consent'
    })}`
    
    // Start local server
    const server = await this.startCallbackServer(state)
    
    // Open browser
    await execAsync(`xdg-open "${authUrl}"`)
    
    // Wait for callback
    const code = await server.waitForCode()
    
    // Exchange for token
    const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        code,
        client_id: this.clientId,
        client_secret: this.clientSecret,
        redirect_uri: this.redirectUri,
        grant_type: 'authorization_code'
      })
    })
    
    const tokens = await tokenResponse.json()
    
    // Store securely
    await execAsync('secret-tool store --label="HyprShell Calendar" service hyprshell-calendar', {
      stdin: JSON.stringify({
        ...tokens,
        expires_at: Date.now() + tokens.expires_in * 1000
      })
    })
    
    return tokens.access_token
  }
}

// CalendarTab.tsx
const CalendarTab = () => {
  const events = Variable<CalendarEvent[]>([])
  const view = Variable<'month' | 'week' | 'day'>('month')
  const currentDate = Variable(new Date())
  
  const loadEvents = async () => {
    const notifId = notificationService.show({
      type: 'progress',
      title: 'Calendar',
      body: 'Loading events...'
    })
    
    try {
      const token = await calendarService.authenticate()
      const response = await fetch(
        `https://www.googleapis.com/calendar/v3/calendars/primary/events?${new URLSearchParams({
          timeMin: startOfMonth(currentDate.get()).toISOString(),
          timeMax: endOfMonth(currentDate.get()).toISOString(),
          singleEvents: 'true',
          orderBy: 'startTime'
        })}`,
        {
          headers: { Authorization: `Bearer ${token}` }
        }
      )
      
      const data = await response.json()
      events.set(data.items)
      
      notificationService.dismiss(notifId)
    } catch (error) {
      notificationService.update(notifId, {
        type: 'error',
        title: 'Calendar Error',
        body: error.message
      })
    }
  }
  
  return (
    <box vertical cssClasses={["calendar-tab"]}>
      {/* Calendar view renderer based on current view */}
    </box>
  )
}
```

### 7. AI Assistant Implementation

```typescript
// AISidebar.tsx
const AISidebar = () => {
  const isVisible = Variable(false)
  const activeModel = Variable<'claude' | 'gemini'>('claude')
  const messages = Variable<Message[]>([])
  const isStreaming = Variable(false)
  
  // Gemini Live state
  const geminiLive = {
    isScreenSharing: Variable(false),
    isCameraActive: Variable(false),
    isVoiceActive: Variable(false),
    websocket: null as WebSocket | null
  }
  
  const sendMessage = async (content: string) => {
    // Add user message
    messages.set([...messages.get(), {
      role: 'user',
      content,
      timestamp: new Date()
    }])
    
    isStreaming.set(true)
    
    if (activeModel.get() === 'claude') {
      await sendToClaude(content)
    } else {
      await sendToGemini(content)
    }
    
    isStreaming.set(false)
  }
  
  const sendToClaude = async (content: string) => {
    try {
      const apiKey = await execAsync('secret-tool lookup service hyprshell-claude')
      
      const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey.trim(),
          'anthropic-version': '2023-06-01'
        },
        body: JSON.stringify({
          model: 'claude-3-opus-20240229',
          messages: messages.get().map(m => ({
            role: m.role,
            content: m.content
          })),
          max_tokens: 4096
        })
      })
      
      const data = await response.json()
      
      messages.set([...messages.get(), {
        role: 'assistant',
        content: data.content[0].text,
        timestamp: new Date()
      }])
    } catch (error) {
      notificationService.show({
        type: 'error',
        title: 'Claude Error',
        body: error.message
      })
    }
  }
  
  const initGeminiLive = async () => {
    const apiKey = await execAsync('secret-tool lookup service hyprshell-gemini')
    
    geminiLive.websocket = new WebSocket(
      `wss://generativelanguage.googleapis.com/v1/models/gemini-pro:streamGenerateContent?key=${apiKey.trim()}`
    )
    
    geminiLive.websocket.onmessage = (event) => {
      // Handle streaming messages
      const data = JSON.parse(event.data)
      // Update messages with streaming content
    }
    
    // Initialize WebRTC for screen/camera sharing
    if (geminiLive.isScreenSharing.get() || geminiLive.isCameraActive.get()) {
      await setupWebRTC()
    }
  }
  
  const setupWebRTC = async () => {
    // Screen capture via Wayland portal
    if (geminiLive.isScreenSharing.get()) {
      const portal = Gio.DBusProxy.new_for_bus_sync(
        Gio.BusType.SESSION,
        Gio.DBusProxyFlags.NONE,
        null,
        'org.freedesktop.portal.Desktop',
        '/org/freedesktop/portal/desktop',
        'org.freedesktop.portal.ScreenCast'
      )
      
      // Request screen capture
      // Implementation details...
    }
  }
  
  return (
    <revealer
      revealChild={isVisible.bind()}
      transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
      transitionDuration={300}>
      <box cssClasses={["ai-sidebar"]} vertical>
        {/* Model selector */}
        <box cssClasses={["ai-header"]}>
          <dropdown
            selected={activeModel.bind()}
            options={[
              { value: 'claude', label: 'Claude' },
              { value: 'gemini', label: 'Gemini' }
            ]}
            onChange={(model) => activeModel.set(model)}
          />
          <box hexpand />
          <button onClicked={() => isVisible.set(false)}>
            <label label="✕" />
          </button>
        </box>
        
        {/* Messages */}
        <scrollable vexpand cssClasses={["chat-messages"]}>
          <box vertical>
            {messages.bind().as(msgs => 
              msgs.map(msg => <ChatMessage message={msg} />)
            )}
          </box>
        </scrollable>
        
        {/* Gemini Live controls */}
        {activeModel.bind().as(model => 
          model === 'gemini' && (
            <box cssClasses={["gemini-controls"]}>
              <togglebutton
                active={geminiLive.isScreenSharing.bind()}
                onToggled={(active) => {
                  geminiLive.isScreenSharing.set(active)
                  if (active) initGeminiLive()
                }}>
                <label label="🖥️ Screen" />
              </togglebutton>
              <togglebutton
                active={geminiLive.isCameraActive.bind()}
                onToggled={(active) => {
                  geminiLive.isCameraActive.set(active)
                  if (active) initGeminiLive()
                }}>
                <label label="📷 Camera" />
              </togglebutton>
              <togglebutton
                active={geminiLive.isVoiceActive.bind()}
                onToggled={(active) => {
                  geminiLive.isVoiceActive.set(active)
                  if (active) initGeminiLive()
                }}>
                <label label="🎤 Voice" />
              </togglebutton>
            </box>
          )
        )}
        
        {/* Input */}
        <box cssClasses={["chat-input-area"]}>
          <entry
            placeholder="Type a message..."
            onActivate={(text) => {
              sendMessage(text)
              // Clear entry
            }}
          />
          <button sensitive={isStreaming.bind().as(s => !s)}>
            <label label="📤" />
          </button>
        </box>
      </box>
    </revealer>
  )
}
```

### 8. Shader Integration

```typescript
// ShaderManager.ts
class ShaderManager {
  private currentShader: string | null = null
  
  async loadShader(name: string) {
    const shaderPath = `/home/tai/.dotfiles/modules/wm/hyprland/shaders/${name}.glsl`
    
    // Apply via Hyprland
    await execAsync(`hyprctl keyword decoration:screen_shader ${shaderPath}`)
    
    this.currentShader = name
    
    notificationService.show({
      type: 'success',
      title: 'Shader Applied',
      body: `${name} shader is now active`
    })
  }
  
  async disableShader() {
    await execAsync('hyprctl keyword decoration:screen_shader ""')
    this.currentShader = null
  }
}

// Example shader - holographic.glsl
/*
precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;

void main() {
    vec2 uv = v_texcoord;
    
    // Holographic chromatic aberration
    float shift = sin(uv.y * 50.0 + time * 2.0) * 0.001;
    
    vec3 color;
    color.r = texture2D(tex, uv + vec2(shift, 0.0)).r;
    color.g = texture2D(tex, uv).g;
    color.b = texture2D(tex, uv - vec2(shift, 0.0)).b;
    
    // Subtle iridescence
    float angle = atan(uv.y - 0.5, uv.x - 0.5);
    float iridescence = sin(angle * 3.0 + time) * 0.5 + 0.5;
    vec3 iriColor = mix(
        vec3(0.5, 0.8, 1.0),
        vec3(1.0, 0.5, 0.8),
        iridescence
    );
    
    color = mix(color, color * iriColor, 0.05);
    
    gl_FragColor = vec4(color, 1.0);
}
*/
```

## Styling Guidelines

### Color Palette
```scss
// In style.scss
$bg-primary: rgba(20, 20, 30, 0.95);
$bg-secondary: rgba(30, 30, 45, 0.9);
$bg-overlay: rgba(0, 0, 0, 0.5);

$text-primary: rgba(255, 255, 255, 0.95);
$text-secondary: rgba(255, 255, 255, 0.7);
$text-muted: rgba(255, 255, 255, 0.5);

$accent-primary: rgba(100, 200, 255, 1);
$accent-secondary: rgba(150, 100, 255, 1);

$success: rgba(50, 255, 150, 1);
$warning: rgba(255, 200, 50, 1);
$error: rgba(255, 50, 100, 1);

// Holographic gradients
$holo-gradient-1: linear-gradient(135deg, rgba(100, 200, 255, 0.2), rgba(150, 100, 255, 0.2));
$holo-gradient-2: linear-gradient(90deg, rgba(0, 255, 200, 0.7), rgba(150, 255, 0, 0.7), rgba(255, 200, 0, 0.7));
```

### Component Styling Patterns
```scss
// Glassmorphic container
.glass-container {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.02));
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  box-shadow: 
    inset 0 1px 0 rgba(255, 255, 255, 0.1),
    0 8px 32px rgba(0, 0, 0, 0.3);
}

// Holographic button
.holo-button {
  background: linear-gradient(135deg, rgba(100, 200, 255, 0.2), rgba(150, 100, 255, 0.2));
  border: 1px solid rgba(100, 200, 255, 0.3);
  border-radius: 8px;
  color: $text-primary;
  transition: all 200ms cubic-bezier(0.4, 0, 0.2, 1);
}

.holo-button:hover {
  background: linear-gradient(135deg, rgba(100, 200, 255, 0.3), rgba(150, 100, 255, 0.3));
  border-color: rgba(100, 200, 255, 0.5);
  box-shadow: 0 0 20px rgba(100, 200, 255, 0.3);
}
```

## Dynamic Color System

### Wallpaper Color Service Implementation
```typescript
// WallpaperColorService.ts
import { execAsync } from "astal/process"
import { monitorFile } from "astal/file"
import GdkPixbuf from "gi://GdkPixbuf"

interface ColorPalette {
  primary: string
  secondary: string
  accent: string
  background: string
  surface: string
  text: string
  muted: string
  vibrant: string[]
  holographic: string[]
}

class WallpaperColorService {
  private currentPalette = Variable<ColorPalette>(this.getDefaultPalette())
  private wallpaperPath = Variable<string>("")
  private enabled = Variable(true)
  
  constructor() {
    this.initWallpaperMonitoring()
  }
  
  private getDefaultPalette(): ColorPalette {
    return {
      primary: "rgba(100, 200, 255, 1)",
      secondary: "rgba(150, 100, 255, 1)",
      accent: "rgba(255, 100, 200, 1)",
      background: "rgba(20, 20, 30, 0.95)",
      surface: "rgba(30, 30, 45, 0.9)",
      text: "rgba(255, 255, 255, 0.95)",
      muted: "rgba(255, 255, 255, 0.5)",
      vibrant: [
        "rgba(255, 0, 128, 0.8)",
        "rgba(0, 255, 128, 0.8)",
        "rgba(128, 0, 255, 0.8)"
      ],
      holographic: [
        "linear-gradient(135deg, rgba(100, 200, 255, 0.2), rgba(150, 100, 255, 0.2))",
        "linear-gradient(90deg, rgba(0, 255, 200, 0.7), rgba(150, 255, 0, 0.7), rgba(255, 200, 0, 0.7))"
      ]
    }
  }
  
  private async initWallpaperMonitoring() {
    // Get current wallpaper from swww
    try {
      const output = await execAsync("swww query")
      // Parse output to get wallpaper path
      const match = output.match(/image: (.+)/)
      if (match) {
        this.wallpaperPath.set(match[1])
        await this.extractColors(match[1])
      }
    } catch (error) {
      console.error("Failed to query swww:", error)
    }
    
    // Monitor wallpaper changes
    // swww doesn't provide direct monitoring, so poll periodically
    setInterval(async () => {
      if (!this.enabled.get()) return
      
      try {
        const output = await execAsync("swww query")
        const match = output.match(/image: (.+)/)
        if (match && match[1] !== this.wallpaperPath.get()) {
          this.wallpaperPath.set(match[1])
          await this.extractColors(match[1])
        }
      } catch (error) {
        // Ignore errors
      }
    }, 2000) // Check every 2 seconds
  }
  
  private async extractColors(imagePath: string) {
    try {
      // Load image
      const pixbuf = GdkPixbuf.Pixbuf.new_from_file(imagePath)
      const width = pixbuf.get_width()
      const height = pixbuf.get_height()
      const pixels = pixbuf.get_pixels()
      const hasAlpha = pixbuf.get_has_alpha()
      const channels = hasAlpha ? 4 : 3
      
      // Sample pixels for color extraction
      const samples: Array<[number, number, number]> = []
      const sampleSize = 100 // Sample 100x100 grid
      const stepX = Math.floor(width / sampleSize)
      const stepY = Math.floor(height / sampleSize)
      
      for (let y = 0; y < height; y += stepY) {
        for (let x = 0; x < width; x += stepX) {
          const idx = (y * width + x) * channels
          samples.push([
            pixels[idx],
            pixels[idx + 1],
            pixels[idx + 2]
          ])
        }
      }
      
      // K-means clustering to find dominant colors
      const clusters = this.kMeansClustering(samples, 8)
      
      // Generate palette
      const palette = this.generatePalette(clusters)
      
      // Apply palette
      this.currentPalette.set(palette)
      this.applyPalette(palette)
      
      // Notify shader system
      this.updateShaderColors(palette)
      
    } catch (error) {
      console.error("Failed to extract colors:", error)
    }
  }
  
  private kMeansClustering(samples: Array<[number, number, number]>, k: number) {
    // Simple k-means implementation
    let centers = samples.slice(0, k)
    const maxIterations = 20
    
    for (let iter = 0; iter < maxIterations; iter++) {
      // Assign samples to clusters
      const clusters: Array<Array<[number, number, number]>> = Array(k).fill(null).map(() => [])
      
      samples.forEach(sample => {
        let minDist = Infinity
        let closestCluster = 0
        
        centers.forEach((center, i) => {
          const dist = Math.sqrt(
            Math.pow(sample[0] - center[0], 2) +
            Math.pow(sample[1] - center[1], 2) +
            Math.pow(sample[2] - center[2], 2)
          )
          if (dist < minDist) {
            minDist = dist
            closestCluster = i
          }
        })
        
        clusters[closestCluster].push(sample)
      })
      
      // Update centers
      centers = clusters.map(cluster => {
        if (cluster.length === 0) return centers[0]
        
        const sum = cluster.reduce((acc, sample) => [
          acc[0] + sample[0],
          acc[1] + sample[1],
          acc[2] + sample[2]
        ], [0, 0, 0])
        
        return [
          Math.round(sum[0] / cluster.length),
          Math.round(sum[1] / cluster.length),
          Math.round(sum[2] / cluster.length)
        ] as [number, number, number]
      })
    }
    
    // Sort by brightness
    return centers.sort((a, b) => {
      const brightnessA = a[0] * 0.299 + a[1] * 0.587 + a[2] * 0.114
      const brightnessB = b[0] * 0.299 + b[1] * 0.587 + b[2] * 0.114
      return brightnessB - brightnessA
    })
  }
  
  private generatePalette(colors: Array<[number, number, number]>): ColorPalette {
    // Find most vibrant colors
    const vibrant = colors.sort((a, b) => {
      const satA = this.getSaturation(a)
      const satB = this.getSaturation(b)
      return satB - satA
    }).slice(0, 3)
    
    // Generate holographic gradients
    const holographic = [
      `linear-gradient(135deg, rgba(${vibrant[0].join(',')}, 0.3), rgba(${vibrant[1].join(',')}, 0.3))`,
      `linear-gradient(90deg, ${vibrant.map(c => 
        `rgba(${c.join(',')}, 0.7)`
      ).join(', ')})`
    ]
    
    // Generate main colors
    const primary = `rgba(${vibrant[0].join(',')}, 1)`
    const secondary = `rgba(${vibrant[1].join(',')}, 1)`
    const accent = `rgba(${vibrant[2].join(',')}, 1)`
    
    // Generate background colors (darker versions)
    const bgColor = colors[colors.length - 1] // Darkest color
    const background = `rgba(${bgColor[0] * 0.2}, ${bgColor[1] * 0.2}, ${bgColor[2] * 0.2}, 0.95)`
    const surface = `rgba(${bgColor[0] * 0.3}, ${bgColor[1] * 0.3}, ${bgColor[2] * 0.3}, 0.9)`
    
    return {
      primary,
      secondary,
      accent,
      background,
      surface,
      text: "rgba(255, 255, 255, 0.95)",
      muted: "rgba(255, 255, 255, 0.5)",
      vibrant: vibrant.map(c => `rgba(${c.join(',')}, 0.8)`),
      holographic
    }
  }
  
  private getSaturation(color: [number, number, number]): number {
    const [r, g, b] = color.map(c => c / 255)
    const max = Math.max(r, g, b)
    const min = Math.min(r, g, b)
    const delta = max - min
    return max === 0 ? 0 : delta / max
  }
  
  private applyPalette(palette: ColorPalette) {
    // Update CSS variables
    const style = `
      .window {
        --color-primary: ${palette.primary};
        --color-secondary: ${palette.secondary};
        --color-accent: ${palette.accent};
        --color-background: ${palette.background};
        --color-surface: ${palette.surface};
        --color-text: ${palette.text};
        --color-muted: ${palette.muted};
        --gradient-holo-1: ${palette.holographic[0]};
        --gradient-holo-2: ${palette.holographic[1]};
      }
    `
    
    // Inject styles
    const styleElement = Widget.Label({
      css: style,
      visible: false
    })
    
    // Apply to all windows
    App.get_windows().forEach(window => {
      window.add(styleElement)
    })
  }
  
  private async updateShaderColors(palette: ColorPalette) {
    // Generate shader with dynamic colors
    const shaderContent = `
precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;

// Dynamic colors from wallpaper
vec3 primaryColor = vec3(${this.hexToGLSL(palette.primary)});
vec3 secondaryColor = vec3(${this.hexToGLSL(palette.secondary)});
vec3 accentColor = vec3(${this.hexToGLSL(palette.accent)});

void main() {
    vec2 uv = v_texcoord;
    vec3 color = texture2D(tex, uv).rgb;
    
    // Holographic effect with dynamic colors
    float wave = sin(uv.y * 50.0 + time * 2.0) * 0.001;
    vec3 shift;
    shift.r = texture2D(tex, uv + vec2(wave, 0.0)).r;
    shift.g = texture2D(tex, uv).g;
    shift.b = texture2D(tex, uv - vec2(wave, 0.0)).b;
    
    // Iridescence based on wallpaper colors
    float angle = atan(uv.y - 0.5, uv.x - 0.5);
    float iridescence = sin(angle * 3.0 + time) * 0.5 + 0.5;
    vec3 iriColor = mix(primaryColor, secondaryColor, iridescence);
    
    color = mix(shift, shift * iriColor, 0.1);
    
    gl_FragColor = vec4(color, 1.0);
}
    `
    
    // Save to temp file and apply
    const shaderPath = "/tmp/hyprshell-dynamic.glsl"
    await execAsync(`echo '${shaderContent}' > ${shaderPath}`)
    
    // Only apply if dynamic colors are enabled
    if (this.enabled.get()) {
      await execAsync(`hyprctl keyword decoration:screen_shader ${shaderPath}`)
    }
  }
  
  private hexToGLSL(rgba: string): string {
    // Convert rgba(r,g,b,a) to GLSL vec3
    const match = rgba.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/)
    if (!match) return "1.0, 1.0, 1.0"
    
    return `${parseInt(match[1]) / 255}, ${parseInt(match[2]) / 255}, ${parseInt(match[3]) / 255}`
  }
  
  // Public API
  toggleEnabled() {
    this.enabled.set(!this.enabled.get())
    if (!this.enabled.get()) {
      // Reset to default colors
      this.applyPalette(this.getDefaultPalette())
      execAsync("hyprctl keyword decoration:screen_shader ''")
    } else {
      // Re-apply current palette
      this.applyPalette(this.currentPalette.get())
    }
  }
  
  getCurrentPalette() {
    return this.currentPalette.get()
  }
  
  overrideColor(key: keyof ColorPalette, value: string) {
    const palette = this.currentPalette.get()
    palette[key] = value
    this.currentPalette.set(palette)
    this.applyPalette(palette)
  }
}

// AppearanceTab.tsx
const AppearanceTab = () => {
  const colorService = new WallpaperColorService()
  const currentPalette = bind(colorService, "currentPalette")
  const previewMode = Variable<'split' | 'full'>('split')
  
  return (
    <box vertical cssClasses={["appearance-tab"]} spacing={12}>
      {/* Dynamic Colors Section */}
      <box vertical cssClasses={["dynamic-colors-section"]}>
        <box cssClasses={["section-header"]}>
          <label label="Dynamic Colors" cssClasses={["section-title"]} />
          <box hexpand />
          <switch 
            active={bind(colorService, "enabled")}
            onToggled={() => colorService.toggleEnabled()}
          />
        </box>
        
        {/* Current Wallpaper */}
        <box cssClasses={["wallpaper-info"]}>
          <label label="Current Wallpaper:" />
          <label label={bind(colorService, "wallpaperPath")} cssClasses={["wallpaper-path"]} />
        </box>
        
        {/* Color Palette Preview */}
        <box cssClasses={["palette-preview"]}>
          {bind(currentPalette).as(palette => 
            Object.entries(palette).filter(([key]) => 
              !['vibrant', 'holographic'].includes(key)
            ).map(([key, color]) => (
              <box vertical key={key} cssClasses={["color-item"]}>
                <box 
                  cssClasses={["color-swatch"]}
                  css={`background: ${color}; min-height: 48px; min-width: 48px;`}
                />
                <label label={key} cssClasses={["color-label"]} />
              </box>
            ))
          )}
        </box>
        
        {/* Holographic Gradients */}
        <box vertical cssClasses={["gradient-preview"]}>
          <label label="Holographic Gradients" cssClasses={["subsection-title"]} />
          {bind(currentPalette).as(palette => 
            palette.holographic.map((gradient, i) => (
              <box 
                key={i}
                cssClasses={["gradient-swatch"]}
                css={`background: ${gradient}; min-height: 32px;`}
              />
            ))
          )}
        </box>
      </box>
      
      {/* Color Overrides */}
      <box vertical cssClasses={["color-overrides-section"]}>
        <label label="Color Overrides" cssClasses={["section-title"]} />
        {bind(currentPalette).as(palette => 
          Object.entries(palette).filter(([key]) => 
            !['vibrant', 'holographic'].includes(key)
          ).map(([key, color]) => (
            <box key={key} cssClasses={["override-item"]} spacing={8}>
              <label label={key} cssClasses={["override-label"]} />
              <box hexpand />
              <entry 
                text={color}
                cssClasses={["color-input"]}
                onChange={(text) => colorService.overrideColor(key, text)}
              />
              <colorbutton
                rgba={parseColor(color)}
                onColorSet={(rgba) => {
                  const color = `rgba(${Math.round(rgba.red * 255)}, ${Math.round(rgba.green * 255)}, ${Math.round(rgba.blue * 255)}, ${rgba.alpha})`
                  colorService.overrideColor(key, color)
                }}
              />
            </box>
          ))
        )}
      </box>
      
      {/* Theme Profiles */}
      <box vertical cssClasses={["theme-profiles-section"]}>
        <label label="Theme Profiles" cssClasses={["section-title"]} />
        <box cssClasses={["profile-grid"]}>
          {['Holographic', 'Cyberpunk', 'Minimal', 'Nature', 'High Contrast'].map(theme => (
            <button key={theme} cssClasses={["theme-button"]}>
              <label label={theme} />
            </button>
          ))}
        </box>
      </box>
    </box>
  )
}
```

## Command System

### Command Palette Implementation
```typescript
// CommandPalette.ts
interface Command {
  id: string
  name: string
  category: string
  keywords: string[]
  shortcut?: string
  action: () => void | Promise<void>
}

class CommandPaletteService {
  private commands = new Map<string, Command>()
  private isOpen = Variable(false)
  private searchQuery = Variable("")
  private selectedIndex = Variable(0)
  
  constructor() {
    this.registerBuiltinCommands()
    this.setupKeyboardShortcuts()
  }
  
  private registerBuiltinCommands() {
    // System commands
    this.register({
      id: 'toggle-wifi',
      name: 'Toggle WiFi',
      category: 'Network',
      keywords: ['wireless', 'internet'],
      action: async () => {
        const network = Network.get_default()
        network.wifi.enabled = !network.wifi.enabled
      }
    })
    
    // Tab navigation
    tabs.forEach(tab => {
      this.register({
        id: `open-${tab.id}`,
        name: `Open ${tab.label}`,
        category: 'Navigation',
        keywords: [tab.id],
        shortcut: `Ctrl+${tabs.indexOf(tab) + 1}`,
        action: () => {
          controlCenterState.activeTab.set(tab.id)
          if (!controlCenterState.isExpanded.get()) {
            toggleControlCenter()
          }
        }
      })
    })
  }
  
  search(query: string): Command[] {
    const results: Array<{ command: Command; score: number }> = []
    const lowerQuery = query.toLowerCase()
    
    this.commands.forEach(command => {
      let score = 0
      
      // Name match
      if (command.name.toLowerCase().includes(lowerQuery)) {
        score += command.name.toLowerCase().startsWith(lowerQuery) ? 100 : 50
      }
      
      // Keyword match
      if (command.keywords.some(k => k.includes(lowerQuery))) {
        score += 25
      }
      
      // Category match
      if (command.category.toLowerCase().includes(lowerQuery)) {
        score += 10
      }
      
      if (score > 0) {
        results.push({ command, score })
      }
    })
    
    return results
      .sort((a, b) => b.score - a.score)
      .map(r => r.command)
  }
}
```

## Performance Optimization Notes

1. **Lazy Loading**: Only load tab content when first accessed
2. **Debouncing**: Debounce all user inputs (sliders, search) by 50-100ms
3. **Virtual Scrolling**: Use for long lists (WiFi networks, processes)
4. **Caching**: Cache API responses with appropriate TTLs
5. **Animation Frame**: Use requestAnimationFrame for smooth animations
6. **Memory Management**: Clear unused tab data when switching

## Security Checklist

- [ ] All API keys stored in system keyring
- [ ] OAuth tokens refreshed securely
- [ ] WiFi passwords never in plain text
- [ ] HTTPS only for all API calls
- [ ] Input validation on all user inputs
- [ ] XSS prevention in markdown rendering
- [ ] Secure WebSocket connections for Gemini

## Testing Strategy

1. **Component Testing**: Test each tab in isolation
2. **Integration Testing**: Test tab switching, data flow
3. **Performance Testing**: Monitor memory usage over time
4. **Security Testing**: Attempt to extract credentials
5. **Multi-monitor Testing**: Ensure single instance works correctly

## Known Limitations & Workarounds

1. **GTK CSS**: Remember the limitations listed at the beginning
2. **Wayland Screen Capture**: Requires portal implementation
3. **Bluetooth**: Some operations may require sudo
4. **GPU Monitoring**: Different commands for NVIDIA/AMD

## Implementation Order

Follow the phases in the roadmap section. Each phase builds on the previous one. Start with Phase 1 (Foundation) and work through systematically. The most complex parts are:

1. Calendar OAuth and sync
2. Gemini Live WebRTC
3. Performance monitoring with charts
4. Command palette with fuzzy search

## Remember

- Always show status notifications for async operations
- Always store credentials securely
- Always handle errors gracefully
- Always follow the established patterns
- This is a Wayland/Hyprland environment, not X11
- The user values aesthetics highly - make it beautiful