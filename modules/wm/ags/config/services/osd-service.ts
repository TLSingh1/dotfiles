import { Variable, bind, interval } from "astal"
import { exec, execAsync, subprocess } from "astal/process"
import { showOSD } from "../widget/osd/OSD"
import Wp from "gi://AstalWp"
import Brightness from "../services/brightness"

class OSDService {
    private wp?: Wp.Wp
    private brightness: typeof Brightness
    private lastVolume = 0
    private lastMute = false
    
    constructor() {
        this.brightness = Brightness
        this.initializeServices()
    }
    
    private async initializeServices() {
        try {
            // Initialize WirePlumber for audio
            this.wp = new Wp.Wp()
            this.setupAudioHandlers()
        } catch (error) {
            console.error("Failed to initialize WirePlumber:", error)
        }
        
        // Setup brightness handlers
        this.setupBrightnessHandlers()
        
        // Setup other handlers
        this.setupKeyboardHandlers()
        
        // Monitor external volume changes (from keybindings)
        this.monitorVolumeChanges()
    }
    
    private setupAudioHandlers() {
        if (!this.wp) return
        
        // Wait for WirePlumber to be ready
        if (this.wp.audio) {
            this.connectAudioHandlers()
        } else {
            // Try again after a short delay
            setTimeout(() => this.connectAudioHandlers(), 1000)
        }
    }
    
    private connectAudioHandlers() {
        if (!this.wp || !this.wp.audio) return
        
        // Volume changes
        const speaker = this.wp.audio.default_speaker
        if (speaker) {
            this.lastVolume = speaker.volume
            this.lastMute = speaker.mute
            
            speaker.connect("notify::volume", () => {
                if (Math.abs(speaker.volume - this.lastVolume) > 0.01) {
                    this.lastVolume = speaker.volume
                    showOSD({
                        type: "volume",
                        icon: this.getVolumeIcon(speaker.volume, speaker.mute),
                        value: Math.round(speaker.volume * 100),
                        muted: speaker.mute
                    })
                }
            })
            
            speaker.connect("notify::mute", () => {
                if (speaker.mute !== this.lastMute) {
                    this.lastMute = speaker.mute
                    showOSD({
                        type: "volume",
                        icon: this.getVolumeIcon(speaker.volume, speaker.mute),
                        value: Math.round(speaker.volume * 100),
                        muted: speaker.mute
                    })
                }
            })
        }
        
        // Microphone changes
        const mic = this.wp.audio.default_microphone
        if (mic) {
            mic.connect("notify::volume", () => {
                showOSD({
                    type: "microphone",
                    icon: mic.mute ? "microphone-disabled-symbolic" : "microphone-sensitivity-high-symbolic",
                    value: Math.round(mic.volume * 100),
                    muted: mic.mute
                })
            })
            
            mic.connect("notify::mute", () => {
                showOSD({
                    type: "microphone",
                    icon: mic.mute ? "microphone-disabled-symbolic" : "microphone-sensitivity-high-symbolic",
                    value: Math.round(mic.volume * 100),
                    muted: mic.mute
                })
            })
        }
    }
    
    private monitorVolumeChanges() {
        // Alternative method: Poll for volume changes
        // This catches changes from external commands like wpctl
        interval(100, () => {
            if (!this.wp || !this.wp.audio || !this.wp.audio.default_speaker) return
            
            const speaker = this.wp.audio.default_speaker
            const currentVolume = speaker.volume
            const currentMute = speaker.mute
            
            // Check if volume or mute state changed
            if (Math.abs(currentVolume - this.lastVolume) > 0.01 || currentMute !== this.lastMute) {
                this.lastVolume = currentVolume
                this.lastMute = currentMute
                
                showOSD({
                    type: "volume",
                    icon: this.getVolumeIcon(currentVolume, currentMute),
                    value: Math.round(currentVolume * 100),
                    muted: currentMute
                })
            }
        })
    }
    
    private setupBrightnessHandlers() {
        this.brightness.connect("notify::screen", () => {
            const value = Math.round(this.brightness.screen * 100)
            showOSD({
                type: "brightness",
                icon: this.getBrightnessIcon(value),
                value: value
            })
        })
    }
    
    private setupKeyboardHandlers() {
        // Monitor for keyboard layout changes
        this.monitorKeyboardLayout()
        
        // Monitor for caps lock / num lock
        this.monitorKeyboardState()
    }
    
    private getVolumeIcon(volume: number, muted: boolean): string {
        if (muted || volume === 0) return "audio-volume-muted-symbolic"
        if (volume < 0.33) return "audio-volume-low-symbolic"
        if (volume < 0.66) return "audio-volume-medium-symbolic"
        return "audio-volume-high-symbolic"
    }
    
    private getBrightnessIcon(value: number): string {
        // Try standard brightness icon
        return "display-brightness-symbolic"
    }
    
    private async monitorKeyboardLayout() {
        // Monitor keyboard layout changes
        // For now, this is disabled until we have a proper way to monitor layout changes
        // without relying on socket paths that may change
    }
    
    private async monitorKeyboardState() {
        // Monitor caps lock, num lock, etc.
        // This would need to hook into X11/Wayland keyboard state
    }
    
    // Public methods for manual triggers
    showVolumeOSD(volume: number, muted: boolean = false) {
        showOSD({
            type: "volume",
            icon: this.getVolumeIcon(volume / 100, muted),
            value: volume,
            muted: muted
        })
    }
    
    showBrightnessOSD(brightness: number) {
        showOSD({
            type: "brightness",
            icon: this.getBrightnessIcon(brightness),
            value: brightness
        })
    }
    
    showMicrophoneOSD(volume: number, muted: boolean = false) {
        showOSD({
            type: "microphone",
            icon: muted ? "microphone-disabled-symbolic" : "microphone-sensitivity-high-symbolic",
            value: volume,
            muted: muted
        })
    }
    
    showKeyboardOSD(layout: string) {
        showOSD({
            type: "keyboard",
            icon: "input-keyboard-symbolic",
            label: layout.toUpperCase()
        })
    }
    
    showWorkspaceOSD(workspace: number) {
        showOSD({
            type: "workspace",
            icon: "view-paged-symbolic",
            label: `Workspace ${workspace}`
        })
    }
    
    showMediaOSD(action: "play" | "pause" | "next" | "previous") {
        const icons = {
            play: "media-playback-start-symbolic",
            pause: "media-playback-pause-symbolic",
            next: "media-skip-forward-symbolic",
            previous: "media-skip-backward-symbolic"
        }
        
        showOSD({
            type: "media",
            icon: icons[action],
            label: action.charAt(0).toUpperCase() + action.slice(1)
        })
    }
    
    showCapsLockOSD(enabled: boolean) {
        showOSD({
            type: "keyboard",
            icon: "caps-lock-symbolic",
            label: enabled ? "Caps Lock ON" : "Caps Lock OFF"
        })
    }
    
    showNumLockOSD(enabled: boolean) {
        showOSD({
            type: "keyboard",
            icon: "num-lock-symbolic",
            label: enabled ? "Num Lock ON" : "Num Lock OFF"
        })
    }
}

export default new OSDService()