import { GObject } from "astal"
import { exec, execAsync } from "astal/process"

class BrightnessService extends GObject.Object {
    static {
        GObject.registerClass({
            Properties: {
                'screen': GObject.ParamSpec.float(
                    'screen', 'Screen', 'Screen brightness',
                    GObject.ParamFlags.READABLE,
                    0, 1, 0
                ),
                'kbd': GObject.ParamSpec.float(
                    'kbd', 'Keyboard', 'Keyboard brightness',
                    GObject.ParamFlags.READABLE,
                    0, 1, 0
                ),
            },
        }, this)
    }
    
    private _screen = 0
    private _kbd = 0
    
    get screen() { return this._screen }
    get kbd() { return this._kbd }
    
    constructor() {
        super()
        this.initBrightness()
        this.monitorBrightness()
    }
    
    private async initBrightness() {
        try {
            // Get initial screen brightness
            const screenMax = Number(await execAsync(["brightnessctl", "m"]))
            const screenCurrent = Number(await execAsync(["brightnessctl", "g"]))
            this._screen = screenCurrent / screenMax
            
            // Get keyboard backlight if available
            try {
                const kbdMax = Number(await execAsync(["brightnessctl", "-d", "*::kbd_backlight", "m"]))
                const kbdCurrent = Number(await execAsync(["brightnessctl", "-d", "*::kbd_backlight", "g"]))
                this._kbd = kbdCurrent / kbdMax
            } catch {
                // No keyboard backlight
                this._kbd = 0
            }
            
            this.notify("screen")
            this.notify("kbd")
        } catch (error) {
            console.error("Failed to initialize brightness:", error)
        }
    }
    
    private monitorBrightness() {
        // Monitor for brightness changes using udev or polling
        // For now, we'll use a simple polling approach
        setInterval(async () => {
            try {
                const screenMax = Number(await execAsync(["brightnessctl", "m"]))
                const screenCurrent = Number(await execAsync(["brightnessctl", "g"]))
                const newScreen = screenCurrent / screenMax
                
                if (Math.abs(newScreen - this._screen) > 0.01) {
                    console.log(`Brightness changed from ${Math.round(this._screen * 100)}% to ${Math.round(newScreen * 100)}%`)
                    this._screen = newScreen
                    this.notify("screen")
                }
                
                try {
                    const kbdMax = Number(await execAsync(["brightnessctl", "-d", "*::kbd_backlight", "m"]))
                    const kbdCurrent = Number(await execAsync(["brightnessctl", "-d", "*::kbd_backlight", "g"]))
                    const newKbd = kbdCurrent / kbdMax
                    
                    if (Math.abs(newKbd - this._kbd) > 0.01) {
                        this._kbd = newKbd
                        this.notify("kbd")
                    }
                } catch {
                    // No keyboard backlight
                }
            } catch (error) {
                console.error("Brightness monitor error:", error)
            }
        }, 500) // Poll every 500ms
    }
    
    async setScreen(value: number) {
        value = Math.max(0, Math.min(1, value))
        try {
            await execAsync(["brightnessctl", "s", `${Math.round(value * 100)}%`])
            this._screen = value
            this.notify("screen")
        } catch (error) {
            console.error("Failed to set screen brightness:", error)
        }
    }
    
    async setKbd(value: number) {
        value = Math.max(0, Math.min(1, value))
        try {
            await execAsync(["brightnessctl", "-d", "*::kbd_backlight", "s", `${Math.round(value * 100)}%`])
            this._kbd = value
            this.notify("kbd")
        } catch (error) {
            console.error("Failed to set keyboard brightness:", error)
        }
    }
}

export default new BrightnessService()