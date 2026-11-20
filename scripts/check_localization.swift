import Foundation
// The validator supplies a temporary .strings projection of the String Catalog.
// Xcode compiles the actual catalog during the separate application build.
let bundle = Bundle(path: CommandLine.arguments[1])!
let shown=3,total=42,ignoredCount=2,owner:Int32=1234
let processName="播放器",deviceName="耳机",count=2
let samples: [(String, String)] = [
    (String(localized: "General", bundle: bundle), "通用"),
    (String(localized: "Showing \(shown) of \(total) results", bundle: bundle), "显示 3 条，共 42 条结果"),
    (String(localized: "\(ignoredCount) ignored · edit to manage", bundle: bundle), "已忽略 2 个应用 · 点击编辑管理"),
    (String(localized: "In exclusive use by \(processName) (PID \(String(owner)))", bundle: bundle), "正由 播放器 独占使用（PID 1234）"),
    (String(localized: "\(count) devices", bundle: bundle), "2 台设备"),
    (String(localized: "\"\(deviceName)\" is back. \(count) app(s) switched back.", bundle: bundle), "“耳机”已重新连接，2 个应用已切回。")
]
for (actual, expected) in samples {
    if actual != expected {
        fputs("Expected \(expected), got \(actual)\n", stderr)
        exit(1)
    }
}
print("Foundation localized lookup and interpolation: \(samples.count) checks passed")
