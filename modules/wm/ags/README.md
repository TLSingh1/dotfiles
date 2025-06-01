# AGS Desktop Environment

A modular, reactive desktop environment built with AGS (Aylur's Gtk Shell) and Astal framework for NixOS + Hyprland.

## Project Overview

### What We're Building

We're creating a fully-featured desktop environment from scratch that includes:

1. **Dynamic App Launcher** - A multi-view launcher that serves as the central hub for:

   - Application search and launching
   - System notifications display
   - System resource monitoring
   - Quick settings and controls

2. **Animated Status Bar** - A vertical bar on the left side featuring:

   - Workspace indicators
   - System tray
   - Dynamic sliding animation that transitions to the launcher

3. **Desktop Widgets** - Starting with a clock and expanding to:
   - Weather display
   - Media controls
   - System monitors
   - Calendar

### Architecture & Design Principles

#### 1. **Service-Oriented State Management**

```typescript
// Each feature has a dedicated service managing its state
class Service {
  // Reactive state using Astal Variables
  state = Variable(initialValue);

  // Singleton pattern for global access
  static get() {
    return instance;
  }
}
```

#### 2. **Reactive UI with Bindings**

- UI automatically updates when state changes
- No manual DOM manipulation
- Declarative component design using JSX

#### 3. **Modular Widget System**

- Each widget is self-contained in `src/widgets/WidgetName/`
- Widgets can be enabled/disabled independently
- Clear separation between UI and business logic

#### 4. **Type-Safe Development**

- Full TypeScript support
- Generated types for GTK and Astal libraries
- Compile-time error checking

#### 5. **Nix-First Approach**

- Reproducible builds with Nix flakes
- Development shell with all dependencies
- Easy integration with NixOS configurations

## Technical Implementation

### Core Technologies

- **AGS**: The bundler and TypeScript runtime
- **Astal**: Reactive framework providing Variables and Bindings
- **GTK3**: Widget toolkit with layer-shell support
- **SCSS**: For advanced styling with variables and nesting
- **Hyprland IPC**: For workspace and window management

### File Structure Explained

```
ags/
├── flake.nix              # Nix flake for building & dev shell
├── default.nix            # NixOS/home-manager module
├── src/
│   ├── app.ts            # Entry point - initializes the app
│   ├── tsconfig.json     # TypeScript configuration
│   ├── env.d.ts          # Type definitions for imports
│   │
│   ├── widgets/          # UI Components
│   │   ├── Clock/        # Each widget in its own directory
│   │   ├── Launcher/
│   │   └── StatusBar/
│   │
│   ├── services/         # State Management
│   │   ├── launcher.ts   # Launcher state & logic
│   │   └── ...          # Other services
│   │
│   ├── lib/             # Utilities & Helpers
│   │   ├── animations.ts # Animation system
│   │   └── utils.ts     # Common utilities
│   │
│   └── styles/          # Styling
│       └── main.scss    # Global styles & widget styles
```

### Key Design Patterns

#### 1. **Variable Pattern for State**

```typescript
const myState = Variable("initial value");
myState.subscribe((value) => console.log("Changed to:", value));
myState.set("new value");
```

#### 2. **Binding Pattern for UI**

```tsx
<label label={bind(myState).as((value) => `Label: ${value}`)} />
```

#### 3. **Service Singleton Pattern**

```typescript
export class MyService {
  private static instance: MyService;
  static get() {
    if (!this.instance) this.instance = new MyService();
    return this.instance;
  }
}
```

## Current Status

### ✅ Completed

- Project scaffolding and structure
- Nix flake configuration
- TypeScript setup
- Clock widget with real-time updates
- Service architecture pattern
- Animation system framework
- Basic styling system

### 🚧 In Progress

- Type generation setup (`ags init`)

## Development Guide

### Prerequisites

- NixOS with flakes enabled
- Hyprland window manager
- Basic knowledge of TypeScript and React-like components

### Getting Started

1. **Enter Development Shell**

   ```bash
   cd modules/wm/ags
   nix develop
   ```

2. **Initialize AGS Types** (first time only)

   ```bash
   ags init -d ./src
   ```

3. **Run in Development Mode**
   ```bash
   cd src
   ags run app.ts
   ```

### Testing Individual Widgets

```bash
# Use the provided test script
./test-clock.sh

# Or manually run with AGS
cd src && ags run app.ts
```

### Building for Production

```bash
nix build
```

## Implementation Roadmap

### Phase 1: Foundation (Current)

- [x] Project structure
- [x] Build system with Nix
- [x] Basic clock widget
- [ ] Type generation and LSP setup
- [ ] Basic styling system

### Phase 2: Core Widgets

- [ ] **Status Bar Implementation**

  - [ ] Window container with proper anchoring
  - [ ] Workspace indicators using Hyprland IPC
  - [ ] System tray integration
  - [ ] Basic styling

- [ ] **Launcher Foundation**
  - [ ] Window with keyboard handling
  - [ ] Search input field
  - [ ] Basic app listing from .desktop files
  - [ ] Keyboard navigation

### Phase 3: Animations & Polish

- [ ] **Sliding Animation System**

  - [ ] Status bar slide-out animation
  - [ ] Launcher slide-in animation
  - [ ] Synchronized transitions
  - [ ] Easing functions

- [ ] **Visual Polish**
  - [ ] Consistent design language
  - [ ] Hover effects
  - [ ] Focus indicators
  - [ ] Smooth transitions

### Phase 4: Advanced Features

- [ ] **Multi-View Launcher**

  - [ ] Tab system for different views
  - [ ] Application grid with icons
  - [ ] Notification center integration
  - [ ] System stats dashboard

- [ ] **Enhanced Status Bar**
  - [ ] Active window title
  - [ ] System indicators (battery, network, etc.)
  - [ ] Quick settings menu

### Phase 5: Extended Functionality

- [ ] **Additional Widgets**

  - [ ] Weather widget
  - [ ] Media player controls
  - [ ] Calendar widget
  - [ ] System monitor graphs

- [ ] **System Integration**
  - [ ] Power menu
  - [ ] Screenshot tool integration
  - [ ] Clipboard manager
  - [ ] Do Not Disturb mode

### Phase 6: Configuration & Distribution

- [ ] **User Configuration**

  - [ ] Config file system
  - [ ] Theme support
  - [ ] Widget positioning options
  - [ ] Keybinding configuration

- [ ] **Documentation**
  - [ ] User guide
  - [ ] Configuration examples
  - [ ] Theming guide
  - [ ] Contributing guidelines

## Adding New Features

### Creating a New Widget

1. **Create Widget Directory**

   ```bash
   mkdir -p src/widgets/MyWidget
   ```

2. **Implement Widget Component**

   ```tsx
   // src/widgets/MyWidget/index.tsx
   import { App, Astal } from "astal/gtk3";

   export default function MyWidget() {
     return (
       <window name="mywidget" application={App}>
         <box>Content</box>
       </window>
     );
   }
   ```

3. **Add Widget Styles**

   ```scss
   // src/styles/main.scss
   .MyWidget {
     // widget-specific styles
   }
   ```

4. **Register in app.ts**

   ```typescript
   import MyWidget from "./widgets/MyWidget";

   App.start({
     main() {
       MyWidget();
     },
   });
   ```

### Creating a New Service

1. **Create Service File**

   ```typescript
   // src/services/myservice.ts
   import { Variable } from "astal";

   export class MyService {
     private static instance: MyService;
     readonly myState = Variable(initialValue);

     static get() {
       if (!this.instance) this.instance = new MyService();
       return this.instance;
     }
   }
   ```

2. **Use in Widgets**
   ```tsx
   const service = MyService.get();
   return <label label={bind(service.myState)} />;
   ```

## Integration with NixOS

### Adding to Your System

In your home-manager configuration:

```nix
{ inputs, ... }:
{
  imports = [
    ./modules/wm/ags
  ];

  programs.ags-desktop.enable = true;
}
```

### Customizing the Package

```nix
programs.ags-desktop = {
  enable = true;
  package = inputs.self.packages.${pkgs.system}.my-desktop.override {
    # custom overrides
  };
};
```

## Contributing

When contributing to this project:

1. Follow the established patterns (services, widgets, etc.)
2. Maintain TypeScript type safety
3. Test widgets in isolation before integration
4. Update this README when adding major features
5. Keep the modular structure intact

## Troubleshooting

### Common Issues

1. **Type Errors**: Run `ags init -d ./src` to regenerate types
2. **Build Failures**: Ensure you're in the dev shell (`nix develop`)
3. **Runtime Errors**: Check the console output of `ags run`
4. **Styling Issues**: Verify SCSS syntax and that styles are imported

### Debug Mode

Run with verbose output:

```bash
AGS_DEBUG=1 ags run app.ts
```

## Resources

- [Astal Documentation](https://aylur.github.io/astal/)
- [AGS Wiki](https://github.com/Aylur/ags/wiki)
- [GTK3 Documentation](https://docs.gtk.org/gtk3/)
- [Hyprland IPC](https://wiki.hyprland.org/IPC/)

---

This is a living document that will be updated as the project evolves. Check back regularly for updates and new features!
