# Dynamic Theming Implementation Plan

## Overview
Real-time theme generation based on SWWW wallpaper changes with cyberpunk enhancement filters.

## Architecture

### 1. **Wallpaper Monitor Service**
```qml
// services/WallpaperMonitor.qml
QtObject {
    property string currentWallpaper: ""
    property var colorScheme: ({})
    
    // Watch SWWW for changes
    Process {
        id: swwwMonitor
        command: ["swww", "query"]
        running: true
        interval: 1000 // Poll every second
    }
}
```

### 2. **Color Extraction Pipeline**
```python
# scripts/extract-colors.py
import material_color_utilities as mcu
from PIL import Image
import json
import sys

def extract_colors(image_path):
    # Load image
    img = Image.open(image_path)
    
    # Extract dominant colors
    colors = mcu.QuantizeCelebi(img, 128)
    
    # Generate Material You scheme
    theme = mcu.MaterialYouColors(colors[0])
    
    # Apply cyberpunk enhancements
    cyberpunk_theme = apply_cyberpunk_filter(theme)
    
    return cyberpunk_theme

def apply_cyberpunk_filter(theme):
    # Increase saturation for neon effect
    # Add glow colors
    # Ensure high contrast
    # Add complementary accent colors
    pass
```

### 3. **Theme Distribution System**
```qml
// services/ThemeManager.qml
Singleton {
    // Material You base colors
    property color primary: "#5eead4"
    property color secondary: "#38bdf8"
    property color tertiary: "#d8709a"
    property color background: "#0a0a0a"
    property color surface: "#1a1a1a"
    
    // Cyberpunk enhancements
    property color neonPrimary: Qt.lighter(primary, 1.8)
    property color neonAccent: "#ff00ff"
    property color glowColor: Qt.rgba(primary.r, primary.g, primary.b, 0.4)
    
    // Visual effects
    property real glassOpacity: 0.12
    property real blurAmount: 32
    property bool darkMode: true
    
    // Animated properties
    Behavior on primary { ColorAnimation { duration: 600; easing.type: Easing.InOutQuad } }
    Behavior on secondary { ColorAnimation { duration: 600; easing.type: Easing.InOutQuad } }
}
```

### 4. **Component Integration**
Every component subscribes to ThemeManager:
```qml
// Example: Bar component
Rectangle {
    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.glassOpacity)
    
    // Neon border effect
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Theme.neonPrimary
        border.width: 1
        opacity: 0.8
        
        // Glow effect
        layer.enabled: true
        layer.effect: Glow {
            radius: 8
            samples: 16
            color: Theme.glowColor
            spread: 0.2
        }
    }
}
```

## Implementation Steps

### Phase 1: Core Theme System (Week 1)
1. Set up SWWW monitoring script
2. Integrate material-color-utilities-python
3. Create basic theme extraction
4. Build ThemeManager singleton
5. Create theme transition animations

### Phase 2: Cyberpunk Filters (Week 2)
1. Develop color enhancement algorithms
2. Add neon color generation
3. Create glow and highlight colors
4. Implement dark/light mode logic
5. Add holographic gradient generation

### Phase 3: Live Integration (Week 3)
1. Connect SWWW monitor to theme system
2. Implement smooth color transitions
3. Add theme persistence
4. Create manual theme override options
5. Build theme preview component

## Color Generation Rules

### From Material You Base:
```
Primary Color → Extract from wallpaper
↓
Neon Primary = Increase lightness by 80%, saturation by 40%
↓
Glow Color = Primary with 40% opacity
↓
Accent Colors = Complementary colors with high saturation
↓
Background = Dark: #0a0a0a-#1a1a1a, Light: #fafafa-#f0f0f0
```

### Cyberpunk Color Relationships:
- **Primary**: Main interface color (from wallpaper)
- **Neon**: Bright version for highlights and glows
- **Accent**: Contrasting color for important elements
- **Warning**: Orange-red neon (#ff4444)
- **Success**: Cyan-green neon (#00ff88)
- **Info**: Blue-purple neon (#00aaff)

## Visual Effects Library

### 1. **Neon Glow Shader**
```glsl
// shaders/neon-glow.frag
uniform sampler2D source;
uniform vec4 glowColor;
uniform float intensity;

void main() {
    vec4 color = texture2D(source, qt_TexCoord0);
    float brightness = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec4 glow = glowColor * brightness * intensity;
    gl_FragColor = color + glow;
}
```

### 2. **Holographic Effect**
```qml
LinearGradient {
    SequentialAnimation on angle {
        loops: Animation.Infinite
        NumberAnimation { from: 0; to: 360; duration: 3000 }
    }
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) }
        GradientStop { position: 0.33; color: Qt.rgba(Theme.secondary.r, Theme.secondary.g, Theme.secondary.b, 0.1) }
        GradientStop { position: 0.66; color: Qt.rgba(Theme.tertiary.r, Theme.tertiary.g, Theme.tertiary.b, 0.1) }
        GradientStop { position: 1.0; color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) }
    }
}
```

### 3. **Glitch Transition**
```qml
ShaderEffect {
    property real glitchAmount: 0.0
    
    SequentialAnimation {
        id: glitchAnimation
        NumberAnimation { target: shader; property: "glitchAmount"; to: 1.0; duration: 50 }
        NumberAnimation { target: shader; property: "glitchAmount"; to: 0.0; duration: 150 }
    }
}
```

## Testing & Debugging

### Theme Testing Script:
```bash
#!/bin/bash
# Test theme extraction with different wallpapers
for wallpaper in ~/.wallpapers/*; do
    echo "Testing: $wallpaper"
    python extract-colors.py "$wallpaper" > /tmp/theme.json
    cat /tmp/theme.json | jq .
done
```

### Debug Overlay:
- Show current theme colors
- Display extraction time
- Monitor theme change events
- Preview next theme

## Performance Optimizations
1. Cache extracted colors
2. Debounce wallpaper changes
3. Use GPU for color transitions
4. Preload common wallpaper themes
5. Async color extraction

This system will give you the dynamic, responsive theming you want with that cyberpunk edge!