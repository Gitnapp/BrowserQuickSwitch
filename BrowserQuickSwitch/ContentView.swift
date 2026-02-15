import SwiftUI
import AppKit

// MARK: - Content View
struct ContentView: View {
    @StateObject private var viewModel = BrowserViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("加载中...")
                    .padding()
            } else if viewModel.installedBrowsers.isEmpty {
                Text("未检测到已安装的浏览器")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                browserList
            }
        }
        .alert("提示", isPresented: $viewModel.showAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .task {
            await viewModel.loadBrowsers()
        }
    }

    // MARK: - Browser List
    private var browserList: some View {
        ForEach(viewModel.installedBrowsers) { browserInfo in
            BrowserRow(
                browserInfo: browserInfo,
                isSelected: viewModel.isDefaultBrowser(browserInfo),
                onSelect: {
                    Task {
                        await viewModel.selectBrowser(browserInfo)
                    }
                }
            )
        }
    }
}

// MARK: - Browser Row
struct BrowserRow: View {
    let browserInfo: BrowserInfo
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .font(.system(size: 14))

                // Browser icon
                if let icon = browserInfo.icon {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                }

                // Browser name
                Text(browserInfo.displayName)
                    .foregroundColor(.primary)

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        )
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .frame(width: 300)
}
