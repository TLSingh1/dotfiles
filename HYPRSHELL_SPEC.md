# HyprShell - Desktop Environment Shell Specification

**Note**: This document is an implementation guide for Claude AI agents working on the HyprShell project. It serves as the single source of truth for features, requirements, and implementation details.

## Vision
Build a complete desktop environment shell that transcends traditional window management, integrating AI assistance, system control, productivity tools, and entertainment into a cohesive, beautiful experience.

## Core Design Principles
1. **Unified Experience**: Single expandable control center instead of scattered panels
2. **Performance First**: Lazy loading, efficient resource usage, single instance per display
3. **Security by Default**: All credentials in system keyring, encrypted communications
4. **Holographic Aesthetic**: Glassmorphic UI with custom GLSL shaders via Hyprshade
5. **Power User Focused**: Command palette, keyboard shortcuts, deep system integration

## Available Astal Libraries
AGS/Astal provides powerful system integration libraries that significantly simplify implementation:

- **AstalNetwork**: NetworkManager integration (WiFi/Ethernet control)
- **AstalBluetooth**: Bluetooth device management
- **AstalWirePlumber**: Audio control (volume, devices, streams)
- **AstalBattery**: Battery monitoring and power management
- **AstalHyprland**: Hyprland window manager integration
- **AstalNotifd**: Notification daemon functionality
- **AstalMpris**: Media player control
- **AstalTray**: System tray integration
- **AstalApps**: Application queries and launching
- **AstalAuth**: PAM authentication
- **AstalPowerProfiles**: Power profile management
- **AstalCava**: Audio visualization

These libraries provide reactive bindings and eliminate the need for many shell commands, resulting in cleaner, more performant code.

## Feature Set

### 1. Expandable Control Center (Left Sidebar)
- **Current State**: 48px wide vertical bar with launcher, workspaces, performance bars, clock, power
- **Expanded State**: 800-900px overlay with tabbed interface
- **Trigger**: Launcher button (◈) at top
- **Animation**: Smooth cubic-bezier transition with backdrop blur
- **Behavior**: Click outside to close, ESC key dismisses, remembers last active tab

### 2. System Tab
**Quick Toggles (4x3 Grid)**:
- WiFi on/off
- Bluetooth on/off
- Airplane mode
- Do Not Disturb
- Night light (shader toggle)
- Location services
- VPN status
- Caffeine (prevent sleep)
- Screenshot tool
- Dynamic Colors (wallpaper-based theming)
- Dark Mode
- Gaming Mode (disable notifications)

**Sliders**:
- Master volume with output device dropdown
- Brightness with auto-brightness toggle
- Microphone gain with input device selector

**Notification Center**:
- Collapsible section showing active operations and notification history
- **Active Operations Area**:
  - Real-time progress for ongoing tasks (WiFi connection, file transfers, etc.)
  - Cancelable operations with X button
  - Progress bars or spinners for each operation
  - Estimated time remaining when available
- **Notification History**:
  - Chronological list of all notifications (system + app)
  - Grouped by application with expandable sections
  - Search/filter bar for finding specific notifications
  - Quick actions (mark as read, clear all, pin important)
  - Notification persistence settings (keep for 24h, 7 days, forever)
  - Click notification to open related app/tab
- **Integration with AstalNotifd**:
  - Captures all system notifications
  - Stores notification metadata (app, time, urgency)
  - Handles notification actions and callbacks

**Additional Elements**:
- Command palette launcher button
- System uptime indicator
- Resource usage mini-graph (CPU/Memory sparklines)

### 3. Network Tab
**WiFi Section**:
- Current connection card (SSID, signal, IP, speed)
- Available networks list with signal strength bars
- Saved networks management (edit, forget)
- Password modal with show/hide toggle
- Advanced settings (DNS, static IP)

**Bluetooth Section**:
- Paired devices with battery levels
- Discovery mode with scanning animation
- Device type icons (headphones, keyboard, mouse, phone)
- Quick connect/disconnect toggles
- Pairing flow with PIN display

**VPN Section**:
- Pre-configured VPN list
- Quick connect buttons
- Status indicators

### 4. Calendar Tab
**Core Features**:
- Full Google Calendar integration via OAuth2
- Month/Week/Day/Agenda views
- Multiple calendar support with color coding
- Event creation with natural language parsing
- Drag-and-drop event rescheduling
- Recurring event support
- Meeting link detection (Zoom, Meet, Teams)
- System notifications for reminders
- Offline support with sync queue

**UI Elements**:
- Mini calendar navigator
- Event search
- Calendar visibility toggles
- Quick event creation button

### 5. Performance Tab
**Monitoring Section**:
- Real-time graphs (5-10 minute history)
  - CPU usage & temperature
  - Memory usage & pressure
  - GPU usage & temperature
  - Battery level & discharge rate
- Click graphs for detailed view

**Process Manager**:
- Top 10 processes by CPU/Memory
- Search/filter capability
- Quick actions: Kill, Nice adjustment
- Process tree view toggle

**System Actions**:
- Power profile selector (Performance/Balanced/Power Saver)
- Clear cache button
- System info display

### 6. Crypto Tab
**Portfolio Overview**:
- Total portfolio value
- 24h change percentage and amount
- Allocation pie chart

**Price Charts**:
- Support for BTC, ETH, and user-selected coins
- Time frames: 1H, 4H, 1D, 1W, 1M, 1Y
- Line and candlestick chart types
- Volume indicator below price
- Price alerts configuration

**Watchlist**:
- Favorite coins with mini sparklines
- Quick stats (current price, 24h%, volume)
- Add/remove coins

### 7. Audio Tab
**Device Management**:
- Output devices with active indicator
- Input devices with level meters
- Quick device switching

**Volume Mixer**:
- Master volume
- Per-application volume sliders
- Application icons
- Mute toggles

**Audio Profiles**:
- Preset EQ profiles (Music, Gaming, Voice)
- Custom profile creation

### 8. Appearance Tab
**Dynamic Color System**:
- **Wallpaper Color Extraction**:
  - Real-time monitoring of swww wallpaper changes
  - Intelligent color extraction using advanced algorithms:
    - Dominant color detection
    - Complementary color generation
    - Vibrant and muted palette options
  - Holographic enhancement:
    - Iridescent overlay generation
    - Chromatic aberration accents
    - Glassmorphic transparency levels
- **Live Preview**:
  - Split-screen preview showing current vs new colors
  - Apply button with smooth transition animation
  - Reset to defaults option
- **Color Overrides**:
  - Individual color pickers for:
    - Primary, secondary, accent colors
    - Background and surface colors
    - Text and icon colors
  - Import/export color schemes
  - Community theme marketplace integration

**Visual Effects**:
- **Shader Selection**:
  - Dropdown with installed shaders
  - Live preview window
  - Shader parameters adjustment
  - Performance impact indicator
- **Animation Settings**:
  - Global animation speed
  - Transition curve selection
  - Reduce motion option
- **Transparency Control**:
  - Window transparency levels
  - Blur intensity adjustment
  - Exclusion rules for specific apps

**Theme Profiles**:
- **Preset Themes**:
  - Holographic (default)
  - Cyberpunk
  - Minimal
  - Nature-inspired
  - High contrast
- **Profile Management**:
  - Save current settings as profile
  - Schedule themes by time of day
  - Automatic dark/light mode switching
  - Per-workspace theme assignment

**Performance Settings**:
- GPU acceleration toggle
- Reduced effects mode
- Battery saver visual preset

### 9. AI Assistant (Right Sidebar)
**Chat Interface**:
- Model selector dropdown (Claude, Gemini)
- Conversation history with markdown rendering
- Code syntax highlighting
- Copy code blocks button
- Clear conversation option

**Gemini Live Features**:
- Screen share toggle
- Camera toggle
- Voice interaction mode
- WebSocket status indicator

**Input Area**:
- Multi-line text input
- File attachment button
- Send button with loading state

### 10. Command Palette
**Features**:
- Fuzzy search all settings and actions
- Recent commands section
- Keyboard navigation
- Command categories
- Shortcut hints
- Real-time preview of actions

### 11. Visual Effects
**Hyprshade Integration**:
- Holographic base shader
- Blue light filter with schedule
- CRT/retro effect
- Dynamic blur for UI elements
- Shader hot-reloading
- Dynamic color-aware shaders (uses extracted wallpaper colors)

### 12. Notification System
**Operation Status Notifications** (appear for these operations):

**Network Operations**:
- WiFi: "Scanning for networks...", "Connecting to [SSID]...", "Connected", "Authentication failed"
- Bluetooth: "Scanning for devices...", "Pairing with [Device]...", "Connected to [Device]", "Pairing failed"
- VPN: "Connecting to [VPN Name]...", "VPN connected", "VPN disconnected"

**System Operations**:
- Audio: "Switching to [Device Name]...", "Audio device changed"
- Display: "Applying display settings...", "Brightness adjusted to X%"
- Power: "Switching to [Profile] mode...", "System will sleep in X seconds"
- Shaders: "Loading [Shader Name]...", "Shader applied"

**Calendar Operations**:
- "Authenticating with Google...", "Calendar sync in progress...", "X events synced"
- "Creating event...", "Event updated", "Event deleted"
- "Offline changes queued (X items)"

**Performance Operations**:
- "Clearing system cache...", "Cache cleared (X MB freed)"
- "Terminating process [Name]...", "Process terminated"
- "Collecting system information..."

**Crypto Operations**:
- "Fetching latest prices...", "Rate limit reached, retrying in X seconds"
- "Updating portfolio...", "Portfolio synced"

**AI Operations**:
- "Connecting to [Model]...", "Processing response..."
- "Starting screen share...", "Camera activated"
- "WebSocket reconnecting..."

**Notification Behavior**:
- Appear as toast in top-right of control center
- Auto-dismiss success notifications after 3 seconds
- Error notifications require manual dismissal
- Progress notifications show loading spinner or progress bar
- Queue multiple notifications vertically
- Click notification to see related tab/section

## Technical Requirements

### Dependencies
- **Core**: Hyprland, AGS (GTK4), Node.js, TypeScript
- **Astal Libraries**: AstalNetwork, AstalBluetooth, AstalWirePlumber, AstalBattery, AstalHyprland, AstalNotifd, AstalMpris, AstalTray, AstalApps, AstalAuth, AstalPowerProfiles, AstalCava
- **Security**: gnome-keyring or similar, Secret Service API
- **APIs**: Google Calendar OAuth2, Anthropic API, Google AI API, CoinMarketCap/CoinGecko
- **Optional**: hyprshade, nvidia-smi/radeontop, grimblast

### Data Management
- **State Persistence**: Tab states, user preferences, window positions
- **Cache Strategy**: 5-minute system metrics, 1-hour crypto data, 24-hour calendar events
- **Secure Storage**: API keys, OAuth tokens, WiFi passwords in system keyring

### Performance Targets
- **Startup**: < 500ms to show bar
- **Expansion**: < 300ms animation
- **Tab Switch**: < 100ms
- **Memory**: < 150MB base, < 300MB with all tabs loaded
- **CPU**: < 2% idle, < 10% during animations

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
**Goal**: Expandable sidebar with basic tab structure

**Tasks**:
1. Create expansion animation system
   - Smooth width transition
   - Backdrop blur overlay
   - Click-outside handler
2. Implement tab navigation
   - Tab bar component
   - Tab content container
   - State management for active tab
3. Set up development environment
   - TypeScript configuration
   - Build system
   - Hot reload setup
4. Create base styling
   - Glassmorphic containers
   - Consistent spacing system
   - Color palette definition

**Deliverable**: Expandable sidebar that shows placeholder content for each tab

### Phase 2: System & Audio Tabs with Notification Center (Week 2-3)
**Goal**: Fully functional system controls, audio management, and notification center

**Tasks**:
1. Implement quick toggles grid
   - Create toggle button component with 4x3 layout
   - Wire up WiFi toggle via AstalNetwork
   - Wire up Bluetooth toggle via AstalBluetooth
   - Implement other system toggles including Dynamic Colors
2. Create slider components
   - Volume slider with AstalWirePlumber integration
   - Brightness control via backlight
   - Microphone gain control using AstalWirePlumber
3. Build audio mixer
   - Enumerate audio devices using AstalWirePlumber
   - Per-application volume controls
   - Device switching logic
4. Implement Notification Center
   - AstalNotifd integration for system notifications
   - Notification storage service with persistence
   - Active operations tracking system
   - Notification grouping and filtering
   - Search functionality
   - Quick actions and callbacks
   - Notification history UI with collapsible sections
5. Add command palette trigger
   - Button in system tab
   - Keyboard shortcut registration

**Deliverable**: Working system controls, audio management, and full notification center

### Phase 3: Network Tab (Week 4)
**Goal**: Complete WiFi and Bluetooth management

**Tasks**:
1. WiFi implementation
   - Network scanning via AstalNetwork
   - Network list component with signal strength
   - Password modal with validation
   - Keyring integration for password storage
   - Connection state management using AstalNetwork reactive bindings
2. Bluetooth implementation
   - Device discovery via AstalBluetooth
   - Pairing flow with PIN support using AstalBluetooth
   - Device type detection and icons
   - Battery level polling
3. Error handling
   - Connection failure notifications
   - Timeout handling
   - Retry mechanisms
4. VPN section
   - List configured VPNs
   - Quick connect implementation

**Deliverable**: Full network management capabilities

### Phase 4: Appearance & Dynamic Theming (Week 5)
**Goal**: Dynamic wallpaper-based color system and appearance customization

**Tasks**:
1. Wallpaper Color Service
   - swww wallpaper monitoring integration
   - Color extraction algorithms:
     - K-means clustering for dominant colors
     - Complementary color calculation
     - Vibrant/muted palette generation
   - Holographic color enhancement:
     - Iridescent gradient generation
     - Chromatic aberration accents
     - Glassmorphic opacity levels
2. Theme Engine
   - CSS variable injection system
   - Real-time theme updates without flicker
   - Theme transition animations
   - Performance optimization for color changes
3. Appearance Tab UI
   - Live preview system with split view
   - Color override controls
   - Theme profile management
   - Import/export functionality
4. Shader Integration
   - Dynamic color-aware shader generation
   - Pass extracted colors to GLSL shaders
   - Hyprshade parameter updates
5. System Integration
   - Store theme preferences in gsettings
   - Sync with system dark mode
   - Per-workspace theme support via Hyprland IPC

**Deliverable**: Fully dynamic theming system with wallpaper-based colors

### Phase 5: Calendar Integration (Week 6-7)
**Goal**: Fully integrated Google Calendar

**Tasks**:
1. OAuth2 implementation
   - Auth flow with local callback server
   - Token storage in keyring
   - Token refresh logic
   - Error handling
2. Calendar data service
   - Event fetching and caching
   - Calendar list management
   - Event CRUD operations
   - Sync queue for offline changes
3. Calendar UI
   - Month view with event dots
   - Week view with time slots
   - Day view with hourly breakdown
   - Event detail modal
4. Advanced features
   - Drag-and-drop rescheduling
   - Recurring event UI
   - Natural language event creation
   - Meeting link detection

**Deliverable**: Full calendar functionality with Google Calendar sync

### Phase 6: Performance & Process Management (Week 8)
**Goal**: System monitoring and process control

**Tasks**:
1. Metrics collection service
   - CPU usage and temperature monitoring
   - Memory statistics
   - GPU monitoring (vendor-agnostic)
   - Battery statistics
   - Historical data storage (circular buffer)
2. Chart component
   - Canvas-based rendering
   - Real-time updates
   - Zoom and pan interactions
   - Multiple series support
3. Process manager
   - Process enumeration
   - Sorting and filtering
   - Kill/nice operations
   - Search implementation
4. System actions
   - Power profile switching
   - Cache clearing
   - System info collection

**Deliverable**: Complete system monitoring and management

### Phase 7: Crypto Integration (Week 9)
**Goal**: Cryptocurrency portfolio tracking

**Tasks**:
1. API integration
   - CoinMarketCap API client
   - CoinGecko fallback
   - Rate limiting and caching
   - Error handling
2. Portfolio management
   - Add/remove holdings
   - Calculate total value
   - Track profit/loss
   - Local storage
3. Chart implementation
   - Price charts with multiple timeframes
   - Candlestick rendering
   - Volume indicators
   - Touch/click interactions
4. Watchlist
   - Favorite coins
   - Mini sparklines
   - Quick stats

**Deliverable**: Full crypto portfolio tracking

### Phase 8: AI Assistant (Week 10-11)
**Goal**: Integrated AI chat with multi-model support

**Tasks**:
1. Right sidebar implementation
   - Slide-in animation
   - Resize handle
   - State persistence
2. Claude integration
   - API client implementation
   - Message streaming
   - Error handling
   - Rate limiting
3. Gemini integration
   - WebSocket connection
   - Message handling
   - Live features UI
4. Gemini Live features
   - WebRTC setup for media
   - Screen capture via Wayland portal
   - Camera access
   - Voice interaction
5. Chat UI
   - Message rendering with markdown
   - Code syntax highlighting
   - File attachments
   - Model switching

**Deliverable**: Fully functional AI assistant with both Claude and Gemini

### Phase 9: Command Palette (Week 12)
**Goal**: Universal command interface

**Tasks**:
1. Command registry
   - Define command structure
   - Register all system commands
   - Category organization
   - Shortcut mapping
2. Search implementation
   - Fuzzy matching algorithm
   - Ranking by relevance
   - Recent commands boost
   - Real-time filtering
3. UI implementation
   - Modal overlay
   - Keyboard navigation
   - Command preview
   - Shortcut hints
4. Integration
   - Hook into all tabs
   - Add custom commands API
   - Settings commands

**Deliverable**: Fully functional command palette

### Phase 10: Shader Integration (Week 13)
**Goal**: Beautiful visual effects via Hyprshade

**Tasks**:
1. Shader development
   - Holographic base shader
   - Glassmorphism effects
   - Blue light filter
   - Animation shaders
2. Hyprshade integration
   - Shader loading system
   - Hot reload support
   - Performance optimization
   - Fallback handling
3. UI controls
   - Shader selector in settings
   - Schedule configuration
   - Preview system
4. Performance tuning
   - FPS monitoring
   - Shader complexity analysis
   - Optimization passes

**Deliverable**: Integrated shader system with multiple effects

### Phase 11: Polish & Optimization (Week 14-15)
**Goal**: Production-ready system

**Tasks**:
1. Performance optimization
   - Memory leak detection
   - Render optimization
   - Lazy loading implementation
   - Cache tuning
2. Error handling
   - Global error boundaries
   - User-friendly error messages
   - Recovery mechanisms
   - Logging system
3. Accessibility
   - Keyboard navigation throughout
   - Screen reader support
   - High contrast mode
   - Font size controls
4. Settings system
   - Preferences UI
   - Import/export settings
   - Reset to defaults
   - Backup system
5. Documentation
   - User guide
   - Keyboard shortcuts reference
   - Troubleshooting guide
   - API documentation

**Deliverable**: Polished, optimized, production-ready system

### Phase 11: Testing & Deployment (Week 14)
**Goal**: Stable release

**Tasks**:
1. Testing
   - Unit tests for services
   - Integration tests
   - Performance benchmarks
   - Multi-monitor testing
2. Bug fixes
   - Issue tracking
   - Priority fixes
   - Edge case handling
3. Packaging
   - Build optimization
   - Distribution packages
   - Installation scripts
   - Update mechanism
4. Release
   - Version tagging
   - Release notes
   - Announcement preparation

**Deliverable**: HyprShell v1.0 release

## Success Metrics
- All features implemented and working
- Memory usage under 300MB with all features active
- No memory leaks over 24-hour usage
- Startup time under 500ms
- Smooth 60fps animations
- Zero security vulnerabilities
- Positive user feedback on aesthetics and functionality

## Future Considerations
- Plugin system for custom widgets
- Mobile companion app
- Voice control integration
- Multi-user profiles
- Sync across devices
- Custom widget marketplace