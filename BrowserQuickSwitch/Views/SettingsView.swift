import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("showBrowserIcon") private var showBrowserIcon = true

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("设置")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // Settings Options
            VStack(alignment: .leading, spacing: 16) {
                Text("显示选项")
                    .font(.headline)
                    .foregroundColor(.secondary)

                VStack(spacing: 12) {
                    SettingRow(
                        title: "图标模式",
                        description: "关闭后切换为 ✓ 指示器模式",
                        isOn: $showBrowserIcon
                    )
                }
            }

            Spacer()

            // Footer Info
            VStack(spacing: 4) {
                Text("更改将立即生效")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .frame(width: 400, height: 250)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Setting Row
struct SettingRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(.switch)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    SettingsView()
}
