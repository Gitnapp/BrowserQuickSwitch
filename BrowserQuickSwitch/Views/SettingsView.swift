import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("showBrowserIcon") private var showBrowserIcon = true
    @AppStorage("detectNonStandardPaths") private var detectNonStandardPaths = false

    var body: some View {
        VStack(spacing: 0) {
            // macOS Style Header with Image and App Name
            VStack(spacing: 12) {
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

                Text("BrowserQuickSwitch")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 32)
            .padding(.bottom, 24)

            // Settings Options in a Form/List style
            Form {
                VStack(alignment: .leading, spacing: 20) {
                    SettingRow(
                        title: "图标模式",
                        description: "关闭后切换为 ✓ 指示器模式",
                        isOn: $showBrowserIcon
                    )
                    SettingRow(
                        title: "非标准应用目录探测",
                        description: "允许检测不在标准应用目录中的浏览器",
                        isOn: $detectNonStandardPaths
                    )
                }
                .padding(.horizontal, 40)
            }

            Spacer()

            // Footer Info
            Text("更改将立即生效")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .frame(width: 450, height: 380)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Setting Row
struct SettingRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .trailing, spacing: 4) {
                Text(title)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
            }
            .frame(width: 140, alignment: .trailing)

            VStack(alignment: .leading, spacing: 4) {
                Toggle("", isOn: $isOn)
                    .toggleStyle(.switch)
                    .labelsHidden()

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
