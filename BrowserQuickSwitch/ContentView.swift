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
        Toggle(isOn: Binding(
            get: { isSelected },
            set: { newValue in
                if newValue {
                    onSelect()
                }
            }
        )) {
            HStack(spacing: 8) {
                if let icon = browserInfo.icon {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                Text(browserInfo.displayName)
            }
        }
        .toggleStyle(CheckboxToggleStyle())
        .padding(.vertical, 5)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .frame(width: 300)
}
