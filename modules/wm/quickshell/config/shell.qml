//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

// Adjust this to make the shell smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1

import "./modules/common/"
// Commented out until we copy these modules
// import "./modules/backgroundWidgets/"
import "./modules/bar/"
import "./modules/overview/"
// import "./modules/cheatsheet/"
// import "./modules/dock/"
// import "./modules/mediaControls/"
// import "./modules/notificationPopup/"
// import "./modules/onScreenDisplay/"
// import "./modules/onScreenKeyboard/"
// import "./modules/overview/"
// import "./modules/screenCorners/"
// import "./modules/session/"
// import "./modules/sidebarLeft/"
// import "./modules/sidebarRight/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import "./services/"

ShellRoot {
    // Enable/disable modules here. False = not loaded at all, so rest assured
    // no unnecessary stuff will take up memory if you decide to only use, say, the overview.
    property bool enableBar: true // Enable the bar
    property bool enableBackgroundWidgets: false
    property bool enableCheatsheet: false
    property bool enableDock: false
    property bool enableMediaControls: false
    property bool enableNotificationPopup: false
    property bool enableOnScreenDisplayBrightness: false
    property bool enableOnScreenDisplayVolume: false
    property bool enableOnScreenKeyboard: false
    property bool enableOverview: true
    property bool enableReloadPopup: false
    property bool enableScreenCorners: false
    property bool enableSession: false
    property bool enableSidebarLeft: false
    property bool enableSidebarRight: false

    // Force initialization of some singletons
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        // Cliphist.refresh() // Disabled until we verify cliphist is working
        FirstRunExperience.load()
    }

    // Components will be enabled as we add them
    LazyLoader { active: enableBar; component: Bar {} }
    // LazyLoader { active: enableBackgroundWidgets; component: BackgroundWidgets {} }
    // LazyLoader { active: enableCheatsheet; component: Cheatsheet {} }
    // LazyLoader { active: enableDock && Config.options.dock.enable; component: Dock {} }
    // LazyLoader { active: enableMediaControls; component: MediaControls {} }
    // LazyLoader { active: enableNotificationPopup; component: NotificationPopup {} }
    // LazyLoader { active: enableOnScreenDisplayBrightness; component: OnScreenDisplayBrightness {} }
    // LazyLoader { active: enableOnScreenDisplayVolume; component: OnScreenDisplayVolume {} }
    // LazyLoader { active: enableOnScreenKeyboard; component: OnScreenKeyboard {} }
    LazyLoader { active: enableOverview; component: Overview {} }
    // LazyLoader { active: enableReloadPopup; component: ReloadPopup {} }
    // LazyLoader { active: enableScreenCorners; component: ScreenCorners {} }
    // LazyLoader { active: enableSession; component: Session {} }
    // LazyLoader { active: enableSidebarLeft; component: SidebarLeft {} }
    // LazyLoader { active: enableSidebarRight; component: SidebarRight {} }
}

