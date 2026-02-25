import SwiftUI

// MARK: - About View
struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // App Icon
            appIcon

            // App Name
            Text("BrowserQuickSwitch")
                .font(.title)
                .fontWeight(.bold)
            // Version Info
            versionInfo

            Spacer()

            // Copyright
            copyrightInfo

            Spacer()
        }
        .frame(width: 450, height: 380)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Subviews
    private var appIcon: some View {
        Group {
            if let appIcon = NSImage(named: NSImage.applicationIconName) {
                Image(nsImage: appIcon)
                    .resizable()
                    .frame(width: 64, height: 64)
            } else {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.accentColor)
            }
        }
    }

    private var versionInfo: some View {
        VStack(spacing: 4) {
            Text("版本 \(appVersion)")
                .font(.body)
                .foregroundColor(.secondary)

            Text("Build \(buildNumber)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var copyrightInfo: some View {
        VStack(spacing: 4) {
            Text("Copyright © 2025 Zijian")
                .font(.footnote)
                .foregroundColor(.secondary)

            Text("保留一切权利")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - App Info Helpers
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
}

// MARK: - Preview
#Preview {
    AboutView()
}
