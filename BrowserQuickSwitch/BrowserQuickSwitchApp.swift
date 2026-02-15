import SwiftUI

// MARK: - Main App
@main
struct BrowserQuickSwitchApp: App {
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        // MenuBar Extra
        MenuBarExtra {
            MenuContent()
        } label: {
            Image(systemName: "globe")
        }
        
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
    
    var body: some View {
        ContentView()
        
        Divider()
        
        Button("关于") {
            openAboutWindow()
        }
        
        Button("退出") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
    }
    
    // MARK: - Helpers
    private func openAboutWindow() {
        // 使用 SwiftUI 的 openWindow 环境变量
        openWindow(id: "about")
        
        // 激活应用并将窗口置于前台
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
