import Foundation
import AppKit

// MARK: - Browser Service Protocol
protocol BrowserServiceProtocol {
    func getInstalledBrowsers() async -> [BrowserInfo]
    func getCurrentDefaultBrowser() async -> BrowserInfo?
    func setDefaultBrowser(_ browserInfo: BrowserInfo) async throws
}

// MARK: - Browser Service Error
enum BrowserServiceError: LocalizedError {
    case browserNotInstalled
    case unsupportedOS
    case setDefaultFailed(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .browserNotInstalled:
            return "浏览器未安装"
        case .unsupportedOS:
            return "当前系统版本不支持此操作"
        case .setDefaultFailed(let message):
            return "设置默认浏览器失败: \(message)"
        case .unknown:
            return "未知错误"
        }
    }
}

// MARK: - Browser Service Implementation
final class BrowserService: BrowserServiceProtocol {
    static let shared = BrowserService()
    private let workspace: NSWorkspace

    init(workspace: NSWorkspace = .shared) {
        self.workspace = workspace
    }

    // MARK: - Get Installed Browsers
    func getInstalledBrowsers() async -> [BrowserInfo] {
        var installedBrowsers: [BrowserInfo] = []

        for var browser in BrowserConfiguration.knownBrowsers {
            if let appURL = workspace.urlForApplication(withBundleIdentifier: browser.bundleId) {
                browser.isInstalled = true
                // 使用实际的应用 URL 加载图标
                if let icon = await loadIcon(at: appURL.path) {
                    browser.icon = icon
                }
                installedBrowsers.append(browser)
            }
        }

        return installedBrowsers
    }

    // MARK: - Get Current Default Browser
    func getCurrentDefaultBrowser() async -> BrowserInfo? {
        guard let url = URL(string: "https://"),
              let appURL = workspace.urlForApplication(toOpen: url),
              let bundleID = Bundle(url: appURL)?.bundleIdentifier else {
            return nil
        }

        let displayName = getApplicationDisplayName(appURL: appURL)
        let icon = await loadIcon(at: appURL.path)
        let websiteURL = inferWebsiteURL(from: bundleID)

        var browserInfo = BrowserInfo(
            bundleId: bundleID,
            displayName: displayName,
            appPath: appURL.path,
            websiteURL: websiteURL
        )
        browserInfo.icon = icon
        browserInfo.isDefault = true
        browserInfo.isInstalled = true

        return browserInfo
    }

    // MARK: - Set Default Browser
    func setDefaultBrowser(_ browserInfo: BrowserInfo) async throws {
        guard #available(macOS 13.0, *) else {
            throw BrowserServiceError.unsupportedOS
        }

        guard isBrowserInstalled(bundleId: browserInfo.bundleId) else {
            throw BrowserServiceError.browserNotInstalled
        }

        guard let appUrl = workspace.urlForApplication(withBundleIdentifier: browserInfo.bundleId) else {
            throw BrowserServiceError.browserNotInstalled
        }

        return try await withCheckedThrowingContinuation { continuation in
            workspace.setDefaultApplication(at: appUrl, toOpenURLsWithScheme: "http") { error in
                if let error = error {
                    continuation.resume(throwing: BrowserServiceError.setDefaultFailed(error.localizedDescription))
                } else {
                    continuation.resume()
                }
            }
        }
    }

    // MARK: - Private Helpers
    private func isBrowserInstalled(bundleId: String) -> Bool {
        workspace.urlForApplication(withBundleIdentifier: bundleId) != nil
    }

    private func loadIcon(at path: String) async -> NSImage? {
        // 方法1: 尝试从 Bundle 加载图标（更可靠）
        if let bundle = Bundle(path: path),
           let iconFile = bundle.object(forInfoDictionaryKey: "CFBundleIconFile") as? String {
            let iconPath = bundle.bundlePath + "/Contents/Resources/" + iconFile
            if let icon = NSImage(contentsOfFile: iconPath) {
                return icon
            }
            // 尝试添加 .icns 扩展名
            if let icon = NSImage(contentsOfFile: iconPath + ".icns") {
                return icon
            }
        }

        // 方法2: 使用 NSWorkspace 获取图标（备用方案）
        return NSWorkspace.shared.icon(forFile: path)
    }

    private func getApplicationDisplayName(appURL: URL) -> String {
        if let bundle = Bundle(url: appURL),
           let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                      bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return name
        }
        return appURL.deletingPathExtension().lastPathComponent
    }

    private func inferWebsiteURL(from bundleID: String) -> URL {
        let urlString: String
        if bundleID.contains("chrome") {
            urlString = "https://google.com/chrome"
        } else if bundleID.contains("firefox") {
            urlString = "https://mozilla.org/firefox"
        } else if bundleID.contains("edge") {
            urlString = "https://microsoft.com/edge"
        } else if bundleID.contains("safari") {
            urlString = "https://apple.com/safari"
        } else {
            urlString = "https://www.google.com"
        }
        return URL(string: urlString)!
    }
}
