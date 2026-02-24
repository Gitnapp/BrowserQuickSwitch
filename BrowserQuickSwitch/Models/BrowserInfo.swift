import SwiftUI
import AppKit

// MARK: - Browser Info Model
struct BrowserInfo: Identifiable, Equatable {
    let id: String
    let bundleId: String
    let displayName: String
    let appPath: String
    let websiteURL: URL
    let icon: NSImage?

    init(bundleId: String, displayName: String, appPath: String, websiteURL: URL, icon: NSImage? = nil) {
        self.id = bundleId
        self.bundleId = bundleId
        self.displayName = displayName
        self.appPath = appPath
        self.websiteURL = websiteURL
        self.icon = icon
    }

    // Equatable conformance
    static func == (lhs: BrowserInfo, rhs: BrowserInfo) -> Bool {
        lhs.bundleId == rhs.bundleId
    }
}

// MARK: - Browser Configuration
enum BrowserConfiguration {
    private static func makeURL(_ string: String) -> URL {
        guard let url = URL(string: string) else {
            fatalError("Invalid URL: \(string)")
        }
        return url
    }

    static let knownBrowsers: [BrowserInfo] = [
        // Safari
        BrowserInfo(bundleId: "com.apple.Safari", displayName: "Safari", appPath: "/Applications/Safari.app", websiteURL: makeURL("https://apple.com/safari")),
        BrowserInfo(bundleId: "com.apple.Safari.beta", displayName: "Safari Beta", appPath: "/Applications/Safari Beta.app", websiteURL: makeURL("https://apple.com/safari")),

        // Chrome
        BrowserInfo(bundleId: "com.google.Chrome", displayName: "Chrome", appPath: "/Applications/Google Chrome.app", websiteURL: makeURL("https://google.com/chrome")),
        BrowserInfo(bundleId: "com.google.Chrome.canary", displayName: "Chrome Canary", appPath: "/Applications/Google Chrome Canary.app", websiteURL: makeURL("https://google.com/chrome")),
        BrowserInfo(bundleId: "com.google.Chrome.dev", displayName: "Chrome Dev", appPath: "/Applications/Google Chrome Dev.app", websiteURL: makeURL("https://google.com/chrome")),
        BrowserInfo(bundleId: "com.google.Chrome.beta", displayName: "Chrome Beta", appPath: "/Applications/Google Chrome Beta.app", websiteURL: makeURL("https://google.com/chrome")),

        BrowserInfo(bundleId: "com.google.chrome.for.testing", displayName: "Chrome for Testing", appPath: "/Applications/Google Chrome for Testing.app", websiteURL: makeURL("https://google.com/chrome")),
        // Firefox
        BrowserInfo(bundleId: "org.mozilla.firefox", displayName: "Firefox", appPath: "/Applications/Firefox.app", websiteURL: makeURL("https://mozilla.org/firefox")),
        BrowserInfo(bundleId: "org.mozilla.firefoxdeveloperedition", displayName: "Firefox Developer Edition", appPath: "/Applications/Firefox Developer Edition.app", websiteURL: makeURL("https://mozilla.org/firefox/developer")),
        BrowserInfo(bundleId: "org.mozilla.nightly", displayName: "Firefox Nightly", appPath: "/Applications/Firefox Nightly.app", websiteURL: makeURL("https://mozilla.org/firefox/nightly")),
        BrowserInfo(bundleId: "org.mozilla.firefox.beta", displayName: "Firefox Beta", appPath: "/Applications/Firefox Beta.app", websiteURL: makeURL("https://mozilla.org/firefox/beta")),

        // Microsoft Edge
        BrowserInfo(bundleId: "com.microsoft.edgemac", displayName: "Microsoft Edge", appPath: "/Applications/Microsoft Edge.app", websiteURL: makeURL("https://microsoft.com/edge")),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Canary", displayName: "Microsoft Edge Canary", appPath: "/Applications/Microsoft Edge Canary.app", websiteURL: makeURL("https://microsoft.com/edge")),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Dev", displayName: "Microsoft Edge Dev", appPath: "/Applications/Microsoft Edge Dev.app", websiteURL: makeURL("https://microsoft.com/edge")),
        BrowserInfo(bundleId: "com.microsoft.edgemac.Beta", displayName: "Microsoft Edge Beta", appPath: "/Applications/Microsoft Edge Beta.app", websiteURL: makeURL("https://microsoft.com/edge")),

        // Other Browsers
        BrowserInfo(bundleId: "com.orabrowser.app", displayName: "Ora", appPath: "/Applications/Ora.app", websiteURL: makeURL("https://orabrowser.com")),
        BrowserInfo(bundleId: "com.brave.browser", displayName: "Brave", appPath: "/Applications/Brave Browser.app", websiteURL: makeURL("https://brave.com")),
        BrowserInfo(bundleId: "com.operasoftware.Opera", displayName: "Opera", appPath: "/Applications/Opera.app", websiteURL: makeURL("https://opera.com")),
        BrowserInfo(bundleId: "com.vivaldi.Vivaldi", displayName: "Vivaldi", appPath: "/Applications/Vivaldi.app", websiteURL: makeURL("https://vivaldi.com")),
        BrowserInfo(bundleId: "ru.yandex.desktop.yandex-browser", displayName: "Yandex Browser", appPath: "/Applications/Yandex.app", websiteURL: makeURL("https://yandex.com/browser")),
        BrowserInfo(bundleId: "com.maxthon.mac", displayName: "Maxthon", appPath: "/Applications/Maxthon.app", websiteURL: makeURL("https://maxthon.com")),
        BrowserInfo(bundleId: "app.zen-browser.zen", displayName: "Zen Browser", appPath: "/Applications/Zen Browser.app", websiteURL: makeURL("https://zenbrowser.com")),
        BrowserInfo(bundleId: "company.thebrowser.dia", displayName: "Dia", appPath: "/Applications/Dia.app", websiteURL: makeURL("https://dia.com")),
        BrowserInfo(bundleId: "com.quark.desktop", displayName: "Quark", appPath: "/Applications/Quark.app", websiteURL: makeURL("https://quark.com")),
        BrowserInfo(bundleId: "net.imput.helium", displayName: "Helium", appPath: "/Applications/Helium.app", websiteURL: makeURL("https://github.com/JadenGeller/Helium"))
        BrowserInfo(bundleId: "io.browsewithnook.nook", displayName: "Nook", appPath: "/Applications/Nook.app", websiteURL: makeURL("https://browsewithnook.com")),
    ]
}
