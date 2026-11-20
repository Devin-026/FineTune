# FineTune 简体中文社区维护版

本版本基于 [ronitsingh10/FineTune](https://github.com/ronitsingh10/FineTune)，由 [Devin-026/FineTune](https://github.com/Devin-026/FineTune) 维护。应用仍名为 FineTune，原作者为 Ronit Singh；版权、GPLv3 许可及原作者支持入口均保留。

## 使用

- 要求 macOS 15 或更新系统，支持 Apple 芯片和 Intel。
- 在本仓库 Actions 的成功 CI 运行中下载 `FineTune-Chinese` 构建产物，解压内层 `FineTune-Chinese.zip` 后，将 `FineTune.app` 放入“应用程序”。它与官方版使用相同应用标识，请先退出官方版。
- 首次启动按系统提示授予“屏幕与系统音频录制”权限；只有需要媒体键功能时才授予辅助功能权限。
- 中文系统自动显示简体中文。也可在“设置 → 通用 → 界面语言”选择简体中文、English 或跟随 macOS，退出并重新启动后生效。语言偏好仅作用于 FineTune。
- 菜单栏显示正在播放音频的应用，拖动对应滑块调节音量。应用、设备和自定义预设的原有名称保持原样。
- 更新入口指向本 fork 的 Releases；原版 Sparkle 自动更新在本维护版中停用，防止覆盖汉化内容。

社区构建使用临时签名，尚未进行 Apple Developer ID 签名或 Apple 公证。若 macOS 阻止打开，可确认下载来源后，在“系统设置 → 隐私与安全性”使用系统提供的“仍要打开”。不要关闭全局安全保护。

## 本地开发与验证

安装完整 Xcode 26 或更新版本，打开 `FineTune.xcodeproj`。项目自动同步 `FineTune/` 目录中的资源。

```sh
python3 scripts/validate_localization.py
xcodebuild build -project FineTune.xcodeproj -scheme FineTune -configuration Debug CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO
xcodebuild test -project FineTune.xcodeproj -scheme FineTune -configuration Debug -skip-testing:FineTuneUITests CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO
```

中文界面字符串位于 `FineTune/Localizable.xcstrings`；系统权限文案位于 `FineTune/InfoPlist.xcstrings`。使用 `String(localized:)`，保留英文源文案；不要翻译持久化的枚举 rawValue、设备 UID、SF Symbols 名、URL scheme 或用户输入的名称。

人工验收需检查：中英文启动、切换语言后重启、菜单栏与设置窗口、播放中的应用音量和静音、耳机连接／断开、EQ 与预设保存、权限提示。资源检查或成功编译不能代替真实音频及视觉验收。

## 同步原作者更新

```sh
git remote add upstream https://github.com/ronitsingh10/FineTune.git  # 已存在则跳过
git fetch upstream
git switch -c sync-upstream
git merge upstream/main
```

处理冲突后运行检查并提交 PR。先保留英文主键和存储标识，再补充新中文文案；确认更新源仍指向本 fork。原版发布工作流依赖作者的私有签名密钥，仅在原作者仓库运行；本 fork 的 CI 独立生成可供测试的应用包。
