import SwiftUI

@main
struct BrowserQuickSwitchApp: App {
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
            
            Divider()
            
            Button("About") {
                openURL(URL(string: "https://yourappwebsite.com/about")!)
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            Image(systemName: "globe")
        }
    }
}
