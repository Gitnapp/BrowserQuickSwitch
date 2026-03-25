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
