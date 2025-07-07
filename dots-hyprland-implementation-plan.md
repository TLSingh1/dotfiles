# dots-hyprland Implementation Plan

This document outlines the features from the dots-hyprland repository that will be iteratively implemented into the NixOS configuration.

## Overview

The dots-hyprland repository features a comprehensive Hyprland setup with Quickshell widgets, Material You theming, and various utilities. The goal is to implement these features incrementally into the existing NixOS dotfiles structure.

## Feature Categories

### 1. Enhanced Hyprland Configuration

#### Core Window Management
- [ ] Advanced gesture controls for touchpad workspace navigation
  - Workspace swipe with configurable distance/fingers
  - Dynamic workspace creation on swipe
- [ ] Custom animation curves (Material Design-inspired)
  - expressiveFastSpatial, expressiveSlowSpatial, emphasizedDecel bezier curves
  - Separate animations for windows, layers, fade, workspaces
- [ ] Advanced visual effects
  - X-ray blur (size: 14, passes: 3)
  - Rounded corners (18px)
  - Shadows with custom range and offset
  - Dim inactive windows (2.5% strength)
- [ ] Window behavior
  - Smart window snapping
  - Resize on border
  - No focus fallback
  - Tearing support for immediate window rule

#### Keybinds System
- [ ] Overview/launcher toggle (Super key)
- [ ] Sidebar toggles (left: Super+A, right: Super+N)
- [ ] Cheatsheet (Super+/)
- [ ] Media controls (Super+M)
- [ ] On-screen keyboard (Super+K)
- [ ] Session menu (Ctrl+Alt+Delete)
- [ ] Screenshot modes (Super+Shift+S for snip)
- [ ] AI integration (Super+Shift+Alt+RightClick)
- [ ] Workspace navigation with number keys

### 2. Quickshell Widget System

#### Core Components
- [ ] Top bar (`modules/bar/`)
  - Workspaces indicator
  - Active window title
  - Clock widget
  - System tray
  - Resource monitors (CPU/RAM)
  - Battery indicator
  - Weather widget
  - Media player controls

- [ ] Left sidebar (`modules/sidebarLeft/`)
  - AI chat interface (Gemini/Ollama support)
  - Translation tool
  - Anime/image browser (Booru integration)
  - API command buttons

- [ ] Right sidebar (`modules/sidebarRight/`)
  - Calendar widget
  - Notification center
  - Quick toggles (WiFi, Bluetooth, Night Light, Game Mode)
  - Volume mixer with per-app controls
  - Todo list widget

- [ ] Overview mode (`modules/overview/`)
  - App launcher with search
  - Live window previews
  - Calculator functionality
  - Command runner

- [ ] Additional widgets
  - On-screen display for volume/brightness
  - Media controls popup
  - Cheatsheet overlay
  - Session control menu
  - On-screen keyboard
  - Notification popups

### 3. Material You Color System

#### Color Generation
- [ ] Wallpaper-based theme generation using matugen
- [ ] Material You color schemes (vibrant, neutral, etc.)
- [ ] Python-based color generation as alternative
- [ ] Color harmonization algorithms

#### Theme Application
- [ ] Hyprland colors configuration
- [ ] GTK 3/4 theme generation
- [ ] Qt5/Qt6 theme via qt5ct/qt6ct
- [ ] Kvantum theme generation
- [ ] Terminal color schemes
- [ ] Fuzzel launcher theming
- [ ] KDE color integration

### 4. Terminal Setup

#### Kitty Configuration
- [ ] JetBrains Mono Nerd Font
- [ ] Custom keybinds (Ctrl+C for copy/interrupt)
- [ ] Search functionality (Ctrl+F)
- [ ] Window padding for consistency
- [ ] Fish shell integration

#### Fish Shell
- [ ] Starship prompt integration
- [ ] Custom aliases (ls → eza, clear with full reset)
- [ ] Dynamic color sequence loading
- [ ] No greeting message

#### Foot Terminal (Alternative)
- [ ] Configuration with similar features to Kitty

### 5. Utilities & Services

#### Core Utilities
- [ ] Clipboard history manager (cliphist)
  - Text and image history
  - Fuzzel integration for selection
- [ ] Screenshot/recording tools
  - hyprshot for screenshots
  - Custom recording script with region selection
  - OCR capability (tesseract)
- [ ] Color picker (hyprpicker)
- [ ] Emoji picker with fuzzel
- [ ] Input method framework (fcitx5)

#### Auto-start Services
- [ ] Wallpaper daemon (swww)
- [ ] Color temperature adjustment (gammastep with geoclue)
- [ ] Idle management (hypridle)
- [ ] Lock screen (hyprlock)
- [ ] Authentication agent (polkit-kde or polkit-gnome)
- [ ] Audio effects processor (easyeffects)
- [ ] Notification daemon (built into Quickshell)

### 6. Application Launchers

- [ ] Fuzzel as primary launcher
  - Custom theme from Material You colors
  - Emoji picker integration
  - Clipboard history integration
- [ ] Anyrun as alternative launcher (optional)

### 7. Additional Features

#### System Integration
- [ ] XDG desktop portal configuration
- [ ] D-Bus activation environment
- [ ] Session lock restoration
- [ ] Chrome/Electron app flags for Wayland

#### Development Tools
- [ ] Hyprland IPC integration
- [ ] Quickshell IPC for widget communication
- [ ] Custom scripts for wallpaper switching
- [ ] Keybind cheatsheet generation

## Implementation Order (Recommended)

1. **Phase 1: Core Hyprland**
   - Basic Hyprland configuration with animations
   - Essential keybinds
   - Auto-start services

2. **Phase 2: Basic Widgets**
   - Top bar implementation
   - Basic Quickshell setup
   - System tray and clock

3. **Phase 3: Color System**
   - Matugen integration
   - Basic theme application
   - Terminal colors

4. **Phase 4: Advanced Widgets**
   - Sidebars implementation
   - Overview mode
   - Media controls

5. **Phase 5: Utilities**
   - Screenshot tools
   - Clipboard manager
   - App launchers

6. **Phase 6: Polish**
   - AI integration
   - Advanced features
   - Performance optimization

## Notes

- Each feature should be implemented as a separate NixOS module when possible
- Maintain compatibility with existing configurations
- Test each phase thoroughly before moving to the next
- Consider machine-specific configurations (desktop vs laptop)