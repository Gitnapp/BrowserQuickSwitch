import SwiftUI

// MARK: - Main App
@main
struct BrowserQuickSwitchApp: App {
    @Environment(\.openWindow) private var openWindow
    @StateObject private var updaterService = UpdaterService()

    var body: some Scene {
        // MenuBar Extra
        MenuBarExtra {
            MenuContent(updaterService: updaterService)
        } label: {
            Image(systemName: "globe")
        }

        // Settings Window
        Window("设置", id: "settings") {
            SettingsView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)

        // About Window (SwiftUI way)
        Window("关于 BrowserQuickSwitch", id: "about") {
            AboutView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}

// MARK: - Menu Content View
struct MenuContent: View {
    @Environment(\.openWindow) private var openWindow
    @ObservedObject var updaterService: UpdaterService

    var body: some View {
        ContentView()

        Divider()

        Button("检查更新...") {
            updaterService.checkForUpdates()
        }
        .disabled(!updaterService.canCheckForUpdates)

        Button("设置") {
            openSettingsWindow()
        }
        .keyboardShortcut(",")

        Button("关于") {
            openAboutWindow()
        }

        Button("退出") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
    }

    // MARK: - Helpers
    private func openSettingsWindow() {
        openWindow(id: "settings")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func openAboutWindow() {
        openWindow(id: "about")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
