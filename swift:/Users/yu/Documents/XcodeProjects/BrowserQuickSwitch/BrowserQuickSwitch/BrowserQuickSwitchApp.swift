import SwiftUI

@main
struct BrowserQuickSwitchApp: App {
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image(systemName: "safari")
        }
        .commands {
            CommandMenu("App") {
                Button("About BrowserQuickSwitch") {
                    if let url = URL(string: "https://yourappwebsite.com/about") {
                        openURL(url)
                    }
                }
                
                Divider()
                
                Button("Quit BrowserQuickSwitch") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
    }
}