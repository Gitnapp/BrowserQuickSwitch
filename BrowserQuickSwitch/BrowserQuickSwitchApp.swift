import SwiftUI

@main
struct BrowserQuickSwitchApp: App {
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
            
            Divider()
            
            Button("About") {
                showAboutWindow()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Image(systemName: "globe")
        }
    }
    
    private func showAboutWindow() {
        let aboutWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        aboutWindow.title = "关于 BrowserQuickSwitch"
        aboutWindow.center()
        aboutWindow.isReleasedWhenClosed = false
        
        let aboutView = AboutView()
        aboutWindow.contentView = NSHostingView(rootView: aboutView)
        
        aboutWindow.makeKeyAndOrderFront(nil)
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 应用图标
            Image(systemName: "globe")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            // 应用名称
            Text("BrowserQuickSwitch")
                .font(.title)
                .fontWeight(.medium)
            
            // 版本信息
            Text("版本 1.0 (1.0.0)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // 版权信息
            VStack(spacing: 4) {
                Text("Copyright © 2024")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text("保留一切权利。")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(40)
        .frame(width: 400, height: 300)
    }
}
