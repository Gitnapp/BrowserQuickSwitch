## [2026-06-28] 菜单栏图标改为无背景的地球轮廓

**改动文件：**
- `BrowserQuickSwitch/BrowserQuickSwitchApp.swift` — 菜单栏图标改用 `globe.europe.africa.fill` 模板符号（去掉蓝色方形背景，只保留地球形状），渲染为 17pt 模板图，随明暗自动适配
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.12（Build 17）

**变更说明：**
此前用 App 图标作菜单栏图标：直接用彩色 App 图标会因 `MenuBarExtra` 按 NSImage 固有尺寸渲染而超大溢出；改为单色模板符号后，去掉了蓝色方形背景，只留地球轮廓，并按系统标准尺寸略放大（17pt），与系统其它菜单栏图标观感一致。仓库内只有压平的 PNG，没有 Icon Composer 的 `.icon` 分层源，无法精确抽取原前景，故用 SF Symbol 复刻地球形状。

**影响范围：**
菜单栏 UI / 发布版本

---

## [2026-06-28] 更换菜单栏图标为 safari（指南针）

**改动文件：**
- `BrowserQuickSwitch/BrowserQuickSwitchApp.swift` — 菜单栏图标由 `globe` 改为 `safari`
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.11（Build 16）

**变更说明：**
原 `globe` 地球图标过于通用，改用 `safari` 指南针图标，在菜单栏中更直观地表达"浏览器"。ContentView 中无图标浏览器的兜底 `globe` 保持不变。

**影响范围：**
菜单栏 UI / 发布版本

---

## [2026-06-28] 修复中英文混排的 i18n 问题

**改动文件：**
- `BrowserQuickSwitch/Localizable.xcstrings` — 补全缺失的英文翻译（"检查更新..." 及一组提示/错误文案）
- `BrowserQuickSwitch/ViewModels/BrowserViewModel.swift` — 弹窗提示文案用 `String(localized:)` 包装，使其参与本地化
- `BrowserQuickSwitch/Services/BrowserService.swift` — `BrowserServiceError` 描述用 `String(localized:)` 包装
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.10（Build 15）

**变更说明：**
英文环境下菜单里"检查更新..."仍显示中文，而"Settings/About/Quit"为英文，出现中英混排。根因是字符串目录（源语言 zh-Hans）缺少"检查更新..."的英文翻译，回退到了中文源 key。补全该翻译后菜单恢复一致。同时发现弹窗提示与错误信息是以裸 `String` 经 `Text(_:)` 逐字显示、根本不参与本地化（英文环境下会弹出中文 toast），改用 `String(localized:)` 并补齐对应翻译。

**影响范围：**
本地化 / 菜单与提示文案 / 发布版本

---

## [2026-06-28] 添加 ego lite 浏览器支持，并加固 Sparkle 更新签名

**改动文件：**
- `BrowserQuickSwitch/Models/BrowserInfo.swift` — 添加 ego lite（bundle id: `com.citrolabs.ego.lite`）到已知浏览器列表
- `README.md` — 更新支持浏览器列表
- `.github/workflows/build.yml` — 用 inside-out 逐层 ad-hoc 签名替换 `codesign --deep`，并逐个校验 Sparkle 嵌套组件
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.9（Build 14）

**变更说明：**
新增 ego lite 识别，安装在标准应用目录时会显示在菜单中，可切换为默认浏览器。

同时修复一个可能阻断自动更新安装的签名隐患：`codesign --deep` 被 Apple 不推荐，且对“框架内嵌套 helper app + XPC service”（正是 Sparkle 的结构）签名不可靠——一旦 `Installer.xpc` / `Autoupdate` 等嵌套组件签名无效，macOS 会在更新阶段拒绝启动它们，导致下载成功但安装失败。CI 改为按 XPC service → Updater.app → Autoupdate → Sparkle.framework → 主 app 的顺序逐层签名，并对每个嵌套组件单独执行 `codesign --verify --strict`。

**影响范围：**
浏览器检测 / 默认浏览器切换 / CI/CD 发布包 / Sparkle 自动更新

---

## [2026-05-11] 修复 Sparkle 更新包签名验证失败

**改动文件：**
- `.github/workflows/build.yml` — zip 前对 Release `.app` 执行 ad-hoc bundle 签名并严格验证
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.8（Build 13）

**变更说明：**
修复 GitHub Actions 使用 `CODE_SIGNING_ALLOWED=NO` 构建后，发布包内 `.app` 只有无效的 linker ad-hoc 签名，导致 Sparkle 报 “The update is improperly signed and could not be validated”。CI 现在会在打包前重新 ad-hoc 签名整个 app bundle，生成有效的 `_CodeSignature/CodeResources`。

**影响范围：**
CI/CD 发布包 / Sparkle 自动更新

---

## [2026-05-11] 添加 ChatGPT Atlas 浏览器支持

**改动文件：**
- `BrowserQuickSwitch/Models/BrowserInfo.swift` — 添加 ChatGPT Atlas 到已知浏览器列表
- `BrowserQuickSwitch/Services/BrowserService.swift` — 默认浏览器网站推断支持 Atlas
- `README.md` — 更新支持浏览器列表
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 版本提升到 1.1.7（Build 12）

**变更说明：**
新增 ChatGPT Atlas（bundle id: `com.openai.atlas`）识别，安装在标准应用目录时会显示在菜单中，可切换为默认浏览器。

**影响范围：**
浏览器检测 / 默认浏览器切换 / 发布版本

---

## [2026-03-25] 集成 Sparkle 自动更新

**改动文件：**
- `BrowserQuickSwitch/BrowserQuickSwitch.entitlements` — 移除沙盒，Sparkle 需要直接文件访问权限
- `BrowserQuickSwitch.xcodeproj/project.pbxproj` — 添加 Sparkle 2 SPM 依赖
- `BrowserQuickSwitch/Info.plist` — 添加 SUFeedURL 和 SUPublicEDKey
- `BrowserQuickSwitch/Services/UpdaterService.swift` — 新建 Sparkle 更新服务封装
- `BrowserQuickSwitch/BrowserQuickSwitchApp.swift` — 菜单栏添加"检查更新..."按钮
- `scripts/generate_keys.swift` — EdDSA 密钥对生成脚本
- `scripts/sign_update.swift` — EdDSA 签名脚本（CI 使用）
- `.github/workflows/build.yml` — CI 增加签名、生成 appcast.xml、部署到 gh-pages

**变更说明：**
集成 Sparkle 2 框架实现应用内自动更新。关闭沙盒以支持 Sparkle 直接替换 app 文件。CI 流程扩展为：编译 → EdDSA 签名 → 生成 appcast.xml → 发布 Release → 部署 appcast 到 GitHub Pages。应用启动时自动检查更新，用户也可通过菜单栏手动触发。

**影响范围：**
前端（SwiftUI 菜单）/ 构建配置 / CI/CD

---

## [2026-03-25] 修复 CI 部署 appcast.xml 到 gh-pages 的文件冲突

**改动文件：**
- `.github/workflows/build.yml` — 部署步骤先将 appcast.xml 复制到 /tmp，再 checkout gh-pages

**变更说明：**
CI 在 Generate appcast.xml 步骤中生成的 appcast.xml 会与 gh-pages 分支上的同名文件冲突，导致 `git checkout gh-pages` 失败。改为先保存到 /tmp 再切换分支后复制回来。

**影响范围：**
CI/CD 配置

---

## [2026-03-25] 添加 GitHub CI/CD 自动编译并发布 Release

**改动文件：**
- `.github/workflows/build.yml` — push 到 main 时自动编译并发布 Release

**变更说明：**
新增 GitHub Actions 工作流，push 到 main 分支后自动：编译项目 → 从 pbxproj 提取版本号 → 打包 .zip → 创建 GitHub Release（tag 格式 `v{version}-build{build}`）。版本号未变时跳过发布，避免重复 Release。使用 macOS 15 + Xcode 16.3 runner，CI 环境跳过代码签名。

**影响范围：**
CI/CD 配置
