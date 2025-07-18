import SwiftUI
import AppKit

struct BrowserInfo {
    let bundleId: String
    let displayName: String
    let icon: NSImage
    let websiteURL: URL
    let isDefault: Bool
}

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var currentDefaultBrowser: BrowserInfo?
    
    // 提取的已知浏览器字典
    private let knownBrowsers: [String: BrowserInfo] = [
        "safari": BrowserInfo(bundleId: "com.apple.Safari", displayName: "Safari", icon: NSWorkspace.shared.icon(forFile: "/Applications/Safari.app"), websiteURL: URL(string: "https://apple.com/safari")!, isDefault: false),
        "safari beta": BrowserInfo(bundleId: "com.apple.Safari.beta", displayName: "Safari Beta", icon: NSWorkspace.shared.icon(forFile: "/Applications/Safari Beta.app"), websiteURL: URL(string: "https://apple.com/safari")!, isDefault: false),
        "chrome": BrowserInfo(bundleId: "com.google.Chrome", displayName: "Chrome", icon: NSWorkspace.shared.icon(forFile: "/Applications/Google Chrome.app"), websiteURL: URL(string: "https://google.com/chrome")!, isDefault: false),
        "chrome canary": BrowserInfo(bundleId: "com.google.Chrome.canary", displayName: "Chrome Canary", icon: NSWorkspace.shared.icon(forFile: "/Applications/Google Chrome Canary.app"), websiteURL: URL(string: "https://google.com/chrome")!, isDefault: false),
        "chrome dev": BrowserInfo(bundleId: "com.google.Chrome.dev", displayName: "Chrome Dev", icon: NSWorkspace.shared.icon(forFile: "/Applications/Google Chrome Dev.app"), websiteURL: URL(string: "https://google.com/chrome")!, isDefault: false),
        "chrome beta": BrowserInfo(bundleId: "com.google.Chrome.beta", displayName: "Chrome Beta", icon: NSWorkspace.shared.icon(forFile: "/Applications/Google Chrome Beta.app"), websiteURL: URL(string: "https://google.com/chrome")!, isDefault: false),
        "firefox": BrowserInfo(bundleId: "org.mozilla.firefox", displayName: "Firefox", icon: NSWorkspace.shared.icon(forFile: "/Applications/Firefox.app"), websiteURL: URL(string: "https://mozilla.org/firefox")!, isDefault: false),
        "firefox developer edition": BrowserInfo(bundleId: "org.mozilla.firefoxdeveloperedition", displayName: "Firefox Developer Edition", icon: NSWorkspace.shared.icon(forFile: "/Applications/Firefox Developer Edition.app"), websiteURL: URL(string: "https://mozilla.org/firefox/developer")!, isDefault: false),
        "firefox nightly": BrowserInfo(bundleId: "org.mozilla.nightly", displayName: "Firefox Nightly", icon: NSWorkspace.shared.icon(forFile: "/Applications/Firefox Nightly.app"), websiteURL: URL(string: "https://mozilla.org/firefox/nightly")!, isDefault: false),
        "firefox beta": BrowserInfo(bundleId: "org.mozilla.firefox.beta", displayName: "Firefox Beta", icon: NSWorkspace.shared.icon(forFile: "/Applications/Firefox Beta.app"), websiteURL: URL(string: "https://mozilla.org/firefox/beta")!, isDefault: false),
        "microsoft edge": BrowserInfo(bundleId: "com.microsoft.edgemac", displayName: "Microsoft Edge", icon: NSWorkspace.shared.icon(forFile: "/Applications/Microsoft Edge.app"), websiteURL: URL(string: "https://microsoft.com/edge")!, isDefault: false),
        "microsoft edge canary": BrowserInfo(bundleId: "com.microsoft.edgemac.Canary", displayName: "Microsoft Edge Canary", icon: NSWorkspace.shared.icon(forFile: "/Applications/Microsoft Edge Canary.app"), websiteURL: URL(string: "https://microsoft.com/edge")!, isDefault: false),
        "microsoft edge dev": BrowserInfo(bundleId: "com.microsoft.edgemac.Dev", displayName: "Microsoft Edge Dev", icon: NSWorkspace.shared.icon(forFile: "/Applications/Microsoft Edge Dev.app"), websiteURL: URL(string: "https://microsoft.com/edge")!, isDefault: false),
        "microsoft edge beta": BrowserInfo(bundleId: "com.microsoft.edgemac.Beta", displayName: "Microsoft Edge Beta", icon: NSWorkspace.shared.icon(forFile: "/Applications/Microsoft Edge Beta.app"), websiteURL: URL(string: "https://microsoft.com/edge")!, isDefault: false),
        "brave": BrowserInfo(bundleId: "com.brave.browser", displayName: "Brave", icon: NSWorkspace.shared.icon(forFile: "/Applications/Brave Browser.app"), websiteURL: URL(string: "https://brave.com")!, isDefault: false),
        "opera": BrowserInfo(bundleId: "com.operasoftware.Opera", displayName: "Opera", icon: NSWorkspace.shared.icon(forFile: "/Applications/Opera.app"), websiteURL: URL(string: "https://opera.com")!, isDefault: false),
        "vivaldi": BrowserInfo(bundleId: "com.vivaldi.Vivaldi", displayName: "Vivaldi", icon: NSWorkspace.shared.icon(forFile: "/Applications/Vivaldi.app"), websiteURL: URL(string: "https://vivaldi.com")!, isDefault: false),
        "yandex browser": BrowserInfo(bundleId: "ru.yandex.desktop.yandex-browser", displayName: "Yandex Browser", icon: NSWorkspace.shared.icon(forFile: "/Applications/Yandex.app"), websiteURL: URL(string: "https://yandex.com/browser")!, isDefault: false),
        "maxthon": BrowserInfo(bundleId: "com.maxthon.mac", displayName: "Maxthon", icon: NSWorkspace.shared.icon(forFile: "/Applications/Maxthon.app"), websiteURL: URL(string: "https://maxthon.com")!, isDefault: false),
        "zen browser": BrowserInfo(bundleId: "app.zen-browser.zen", displayName: "Zen Browser", icon: NSWorkspace.shared.icon(forFile: "/Applications/Zen Browser.app"), websiteURL: URL(string: "https://zenbrowser.com")!, isDefault: false),
        "dia": BrowserInfo(bundleId: "company.thebrowser.dia", displayName: "Dia", icon: NSWorkspace.shared.icon(forFile: "/Applications/Dia.app"), websiteURL: URL(string: "https://dia.com")!, isDefault: false),
        "quark": BrowserInfo(bundleId: "com.quark.desktop", displayName: "Quark", icon: NSWorkspace.shared.icon(forFile: "/Applications/Quark.app"), websiteURL: URL(string: "https://quark.com")!, isDefault: false)
    ]
    
    private func getInstalledBrowsers() -> [BrowserInfo] {
        var installedBrowsers = [BrowserInfo]()
        
        for (_, browserInfo) in knownBrowsers {
            if NSWorkspace.shared.urlForApplication(withBundleIdentifier: browserInfo.bundleId) != nil {
                installedBrowsers.append(browserInfo)
            }
        }
        
        return installedBrowsers
    }
    
    var body: some View {
        let installedBrowsers = getInstalledBrowsers()
        
        Group {
            ForEach(installedBrowsers, id: \.bundleId) { browserInfo in
                Toggle(browserInfo.displayName, isOn: Binding(
                    get: { currentDefaultBrowser?.bundleId == browserInfo.bundleId },
                    set: { isOn in
                        if isOn {
                            handleBrowserSelection(browserInfo)
                        }
                    }
                ))
                .toggleStyle(CheckboxToggleStyle())
                .padding(.vertical, 5)
            }
        }
        .alert("提示", isPresented: $showAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            updateCurrentDefaultBrowser()
        }
    }
    
    private func isBrowserInstalled(bundleId: String) -> Bool {
        return NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) != nil
    }
    
    private func handleBrowserSelection(_ browserInfo: BrowserInfo) {
        guard isBrowserInstalled(bundleId: browserInfo.bundleId) else {
            showAlert(message: "\(browserInfo.displayName) 未安装")
            return
        }
        
        setDefaultBrowser(browserInfo: browserInfo) { success in
            if success {
            } else {
                showAlert(message: "设置默认浏览器失败，请手动设置。")
            }
        }
    }
    
    private func setDefaultBrowser(browserInfo: BrowserInfo, completion: @escaping (Bool) -> Void) {
        // 方法1: macOS 13+ 官方API
        if #available(macOS 13.0, *) {
            guard let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: browserInfo.bundleId) else {
                showAlert(message: "\(browserInfo.displayName) 未安装")
                completion(false)
                return
            }
            
            NSWorkspace.shared.setDefaultApplication(at: appUrl, toOpenURLsWithScheme: "http") { error in
                if let error = error {
                    print("设置失败: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    self.showAlert(message: "\(browserInfo.displayName) 已设为默认")
                    self.updateCurrentDefaultBrowser()
                    completion(true)
                }
            }
        } else {
            showAlert(message: "当前系统版本不支持自动设置默认浏览器，请手动设置。")
            completion(false)
        }
    }
        

    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func updateCurrentDefaultBrowser() {
        if #available(macOS 13.0, *) {
            if let defaultBrowser = getDefaultBrowser() {
                currentDefaultBrowser = defaultBrowser
            } else {
                showAlert(message: "无法获取当前默认浏览器，请手动设置。")
            }
        } else {
            // macOS 12及以下版本的处理
            // 由于我们放弃了AppleScript方法，所以这里可以留空或者给出提示
            showAlert(message: "当前系统版本不支持自动获取默认浏览器，请手动设置。")
        }
    }
    
    // MARK: - 核心功能实现
    // 获取系统默认浏览器
    private func getDefaultBrowser() -> BrowserInfo? {
        guard let url = URL(string: "https://"),
              let appURL = NSWorkspace.shared.urlForApplication(toOpen: url),
              let bundleID = Bundle(url: appURL)?.bundleIdentifier else {
            return nil
        }
        
        return BrowserInfo(
            bundleId: bundleID,
            displayName: getApplicationDisplayName(appURL: appURL),
            icon: NSWorkspace.shared.icon(forFile: appURL.path),
            websiteURL: URL(string: "https://\(bundleID.contains("chrome") ? "google.com/chrome" : bundleID.contains("firefox") ? "mozilla.org/firefox" : "apple.com/safari")")!,
            isDefault: true
        )
    }
    
    // 获取应用的显示名称
    private func getApplicationDisplayName(appURL: URL) -> String {
        if let bundle = Bundle(url: appURL),
           let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? 
                      bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return name
        }
        
        // Bug 修复: 添加了 lastPathComponent
        return appURL.deletingPathExtension().lastPathComponent
    }
}
