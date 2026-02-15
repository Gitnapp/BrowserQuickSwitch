import Foundation
import SwiftUI

// MARK: - Browser View Model
@MainActor
final class BrowserViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var installedBrowsers: [BrowserInfo] = []
    @Published private(set) var currentDefaultBrowser: BrowserInfo?
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published private(set) var isLoading = false

    // MARK: - Dependencies
    private let browserService: BrowserServiceProtocol

    // MARK: - Initialization
    init(browserService: BrowserServiceProtocol = BrowserService.shared) {
        self.browserService = browserService
    }

    // MARK: - Public Methods
    func loadBrowsers() async {
        isLoading = true
        defer { isLoading = false }

        async let installedBrowsersTask = browserService.getInstalledBrowsers()
        async let defaultBrowserTask = browserService.getCurrentDefaultBrowser()

        // 并行加载浏览器列表和默认浏览器
        let (browsers, defaultBrowser) = await (installedBrowsersTask, defaultBrowserTask)

        installedBrowsers = browsers
        currentDefaultBrowser = defaultBrowser

        // 标记默认浏览器
        updateDefaultBrowserStatus()
    }

    func selectBrowser(_ browserInfo: BrowserInfo) async {
        // 如果已经是默认浏览器，不需要操作
        guard currentDefaultBrowser?.bundleId != browserInfo.bundleId else {
            return
        }

        do {
            try await browserService.setDefaultBrowser(browserInfo)

            // 更新成功后刷新状态
            await refreshDefaultBrowser()

            showAlert(message: "\(browserInfo.displayName) 已设为默认浏览器")
        } catch BrowserServiceError.browserNotInstalled {
            showAlert(message: "\(browserInfo.displayName) 未安装")
        } catch BrowserServiceError.unsupportedOS {
            showAlert(message: "当前系统版本不支持自动设置默认浏览器，请手动设置")
        } catch {
            showAlert(message: "设置默认浏览器失败: \(error.localizedDescription)")
        }
    }

    func refreshDefaultBrowser() async {
        currentDefaultBrowser = await browserService.getCurrentDefaultBrowser()
        updateDefaultBrowserStatus()
    }

    // MARK: - Helper Methods
    func isDefaultBrowser(_ browserInfo: BrowserInfo) -> Bool {
        currentDefaultBrowser?.bundleId == browserInfo.bundleId
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }

    private func updateDefaultBrowserStatus() {
        guard let defaultBrowser = currentDefaultBrowser else { return }

        // 更新已安装浏览器列表中的默认状态
        for index in installedBrowsers.indices {
            installedBrowsers[index].isDefault =
                installedBrowsers[index].bundleId == defaultBrowser.bundleId
        }
    }
}
