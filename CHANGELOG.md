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
