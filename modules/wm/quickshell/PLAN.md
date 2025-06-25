# Quickshell Module Development Plan

## Overview
This document outlines the plan for developing a new Quickshell-based desktop shell module that integrates seamlessly with the existing dotfiles configuration.

## Goals
- Create a modern, performant desktop shell using Quickshell
- Maintain consistency with the existing Material You 3 cyan/teal theme
- Provide feature parity with existing WM integrations (AGS)
- Follow established module patterns in the dotfiles repository

## Architecture

### Module Structure
```
modules/wm/quickshell/
├── default.nix           # Main module configuration
├── packages.nix          # Package definitions and overrides
├── config.nix           # Configuration file management
├── shell/               # Quickshell QML components
│   ├── shell.qml        # Main entry point
│   ├── components/      # Reusable QML components
│   ├── services/        # Backend services (system integration)
│   └── widgets/         # UI widgets
└── scripts/             # Helper scripts
```

### Core Components

#### 1. **Bar/Panel**
- **Features:**
  - Workspaces indicator
  - Active window title
  - System tray
  - Clock/date
  - Status indicators (network, bluetooth, battery)
  - Media controls
- **Location:** Top of screen
- **Style:** Transparent background with blur, rounded corners

#### 2. **App Launcher**
- **Features:**
  - Application search
  - Recent apps
  - Categories
  - Fuzzy search
- **Activation:** Super+Semicolon (;)
- **Style:** Centered popup with blur background

#### 3. **Notification System**
- **Features:**
  - Notification popups
  - Notification center
  - Do not disturb mode
  - History
- **Integration:** DBus notification daemon

#### 4. **System Menu**
- **Features:**
  - Power options (shutdown, reboot, logout)
  - User info
  - Quick settings
  - Lock screen
- **Activation:** Click on user avatar or keybind

#### 5. **Dashboard/Control Center**
- **Features:**
  - System monitoring
  - Media controls
  - Calendar
  - Quick toggles
- **Activation:** Gesture or keybind

## Theme Integration

### Color Scheme (Material You 3)
```qml
// Primary colors (cyan/teal)
readonly property color primary: "#5eead4"
readonly property color primaryDark: "#2dd4bf"
readonly property color primaryLight: "#7dd3c0"

// Secondary colors (blue/sapphire)
readonly property color secondary: "#38bdf8"
readonly property color secondaryDark: "#0891b2"

// Tertiary colors (pink/magenta)
readonly property color tertiary: "#d8709a"
readonly property color tertiaryAlt: "#c084fc"

// Background and surface
readonly property real backgroundOpacity: 0.15
readonly property int cornerRadius: 20
```

### Visual Effects
- Blur behind transparent surfaces
- Smooth animations (200-300ms duration)
- Consistent spacing (8px grid)
- Drop shadows for elevation

## Implementation Phases

### Phase 1: Foundation (Week 1)
- [ ] Create basic module structure (`default.nix`, `packages.nix`)
- [ ] Set up Quickshell flake input and packaging
- [ ] Create minimal shell entry point
- [ ] Implement theme/styling system
- [ ] Basic Hyprland integration

### Phase 2: Bar Implementation (Week 2)
- [ ] Create bar component with proper positioning
- [ ] Implement workspaces widget
- [ ] Add clock and date display
- [ ] Integrate system tray
- [ ] Add active window title

### Phase 3: App Launcher (Week 3)
- [ ] Create launcher popup component
- [ ] Implement application listing (`.desktop` files)
- [ ] Add fuzzy search functionality
- [ ] Implement keyboard navigation
- [ ] Add launch animations

### Phase 4: System Integration (Week 4)
- [ ] Network status service
- [ ] Bluetooth integration
- [ ] Battery monitoring
- [ ] Audio/volume controls
- [ ] Media player integration (MPRIS)

### Phase 5: Notifications (Week 5)
- [ ] DBus notification daemon
- [ ] Popup notifications
- [ ] Notification center
- [ ] Persistence and history

### Phase 6: Dashboard & Polish (Week 6)
- [ ] Dashboard/control center
- [ ] System monitoring widgets
- [ ] Calendar integration
- [ ] Final polish and animations
- [ ] Performance optimization

## Technical Considerations

### Dependencies
```nix
home.packages = with pkgs; [
    quickshell
    # Qt dependencies
    qt6.qtdeclarative
    qt6.qt5compat
    # System integration
    networkmanager
    bluez
    brightnessctl
    pamixer
    # Utilities
    jq
    ripgrep
    fd
    fuzzel  # For app launching backend
    grim    # Screenshots
    slurp   # Selection
    wl-clipboard
];
```

### Service Integration
- Use DBus for system services
- Hyprland IPC for workspace/window management
- PipeWire/PulseAudio for audio
- NetworkManager for network status
- UPower for battery information

### Performance Goals
- Startup time < 500ms
- Memory usage < 100MB
- Smooth 60fps animations
- Minimal CPU usage when idle

## Testing Strategy
- Test on both laptop (my-nixos) and desktop (nixos-desktop) hosts
- Verify theme consistency across all components
- Test all keybindings and interactions
- Monitor resource usage
- Ensure graceful degradation when services unavailable

## Migration Path
1. Develop alongside existing AGS setup
2. Add toggle option to switch between AGS and Quickshell
3. Gradual feature parity achievement
4. User testing period
5. Full migration when stable

## Next Steps
1. Add quickshell to flake inputs
2. Create basic `default.nix` following module pattern
3. Set up minimal shell with window rules
4. Begin Phase 1 implementation

---

**Note:** This plan is iterative and will be updated as development progresses. Each phase should produce a working, testable component.
