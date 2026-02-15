import SwiftUI
import AppKit

// MARK: - Browser Info Model
struct BrowserInfo: Identifiable, Equatable {
    let id: String
    let bundleId: String
    let displayName: String
    let appPath: String
    let websiteURL: URL
    var icon: NSImage?
    var isDefault: Bool = false
    var isInstalled: Bool = false
    
    init(bundleId: String, displayName: String, appPath: String, websiteURL: URL) {
        self.id = bundleId
        self.bundleId = bundleId
        self.displayName = displayName
        self.appPath = appPath
        self.websiteURL = websiteURL
        self.icon = nil
        self.isDefault = false
        self.isInstalled = false
    }
    
    // Equatable conformance
    static func == (lhs: BrowserInfo, rhs: BrowserInfo) -> Bool {
        lhs.bundleId == rhs.bundleId
    }
}

// MARK: - Browser Configuration
enum BrowserConfiguration {
    static let knownBrowsers: [BrowserInfo] = [
        // Safari
        BrowserInfo(bundleId: "com.apple.Safari", displayName: "Safari", appPath: "/Applications/Safari.app", websiteURL: URL(string: "https://apple.com/safari")!),
        BrowserInfo(bundleId: "com.apple.Safari.beta", displayName: "Safari Beta", appPath: "/Applications/Safari Beta.app", websiteURL: URL(string: "https://apple.com/safari")!),
        
        // Chrome
        BrowserInfo(bundleId: "com.google.Chrome", displayName: "Chrome", appPath: "/Applications/Google Chrome.app", websiteURL: URL(string: "https://google.com/chrome")!),
        BrowserInfo(bundleId: "com.google.Chrome.canary", displayName: "Chrome Canary", appPath: "/Applications/Google Chrome Canary.app", websiteURL: URL(string: "https://google.com/chrome")!),
        BrowserInfo(bundleId: "com.google.Chrome.dev", displayName: "Chrome Dev", appPath: "/Applications/Google Chrome Dev.app", websiteURL: URL(string: "https://google.com/chrome")!),
        BrowserInfo(bundleId: "com.google.Chrome.beta", displayName: "Chrome Beta", appPath: "/Applications/Google Chrome Beta.app", websiteURL: URL(string: "https://google.com/chrome")!),
        
        // Firefox
        BrowserInfo(bundleId: "org.mozilla.firefox", displayName: "Firefox", appPath: "/Applications/Firefox.app", websiteURL: URL(string: "https://mozilla.org/firefox")!),
        BrowserInfo(bundleId: "org.mozilla.firefoxdeveloperedition", displayName: "Firefox Developer Edition", appPath: "/Applications/Firefox Developer Edition.app", websiteURL: URL(string: "https://mozilla.org/firefox/developer")!),
        BrowserInfo(bundleId: "org.mozilla.nightly", displayName: "Firefox Nightly", appPath: "/Applications/Firefox Nightly.app", websiteURL: URL(string: "https://mozilla.org/firefox/nightly")!),
        BrowserInfo(bundleId: "org.mozilla.firefox.beta", displayName: "Firefox Beta", appPath: "/Applications/Firefox Beta.app", websiteURL: URL(string: "https://mozilla.org/firefox/beta")!),
        
        // Microsoft Edge
        BrowserInfo(bundleId: "com.microsoft.edgemac", displayName: "Microsoft Edge", appPath: "/Applications/Microsoft Edge.app", websiteURL: URL(string: "https://microsoft.com/edge")!),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Canary", displayName: "Microsoft Edge Canary", appPath: "/Applications/Microsoft Edge Canary.app", websiteURL: URL(string: "https://microsoft.com/edge")!),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Dev", displayName: "Microsoft Edge Dev", appPath: "/Applications/Microsoft Edge Dev.app", websiteURL: URL(string: "https://microsoft.com/edge")!),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Beta", displayName: "Microsoft Edge Beta", appPath: "/Applications/Microsoft Edge Beta.app", websiteURL: URL(string: "https://microsoft.com/edge")!),
        
        // Other Browsers
        BrowserInfo(bundleId: "com.brave.browser", displayName: "Brave", appPath: "/Applications/Brave Browser.app", websiteURL: URL(string: "https://brave.com")!),
        BrowserInfo(bundleId: "com.operasoftware.Opera", displayName: "Opera", appPath: "/Applications/Opera.app", websiteURL: URL(string: "https://opera.com")!),
        BrowserInfo(bundleId: "com.vivaldi.Vivaldi", displayName: "Vivaldi", appPath: "/Applications/Vivaldi.app", websiteURL: URL(string: "https://vivaldi.com")!),
        BrowserInfo(bundleId: "ru.yandex.desktop.yandex-browser", displayName: "Yandex Browser", appPath: "/Applications/Yandex.app", websiteURL: URL(string: "https://yandex.com/browser")!),
        BrowserInfo(bundleId: "com.maxthon.mac", displayName: "Maxthon", appPath: "/Applications/Maxthon.app", websiteURL: URL(string: "https://maxthon.com")!),
        BrowserInfo(bundleId: "app.zen-browser.zen", displayName: "Zen Browser", appPath: "/Applications/Zen Browser.app", websiteURL: URL(string: "https://zenbrowser.com")!),
        BrowserInfo(bundleId: "company.thebrowser.dia", displayName: "Dia", appPath: "/Applications/Dia.app", websiteURL: URL(string: "https://dia.com")!),
        BrowserInfo(bundleId: "com.quark.desktop", displayName: "Quark", appPath: "/Applications/Quark.app", websiteURL: URL(string: "https://quark.com")!)
    ]
}
