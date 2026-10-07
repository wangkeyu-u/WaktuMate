# WaktuMate Malaysia

SwiftUI 日常礼拜工具：按马来西亚区域显示礼拜时间、下一拜倒计时和本地通知，附带打卡、Tasbih、朝拜罗盘和练习计时。首次启动选择信仰档案；不同档案使用各自的工具与参考入口。

## 运行

最低系统为 iOS 17。用 Xcode 打开仓库根目录的工程，选择 `WaktuMate` scheme 和 iPhone 模拟器或真机：

```bash
open WaktuMate.xcodeproj
xcodebuild -project WaktuMate.xcodeproj -scheme WaktuMate \
  -destination 'generic/platform=iOS Simulator' build
```

真机运行需选择自己的开发者 Team。定位、朝向、系统通知和日历导出依赖设备能力及相应权限。

## 数据与状态

`PrayerTimeService` 通过 Waktu Solat v2 获取指定区域的月度时间，或用 GPS 端点查区域。远程读取失败时，服务返回内置 `MockPrayerTimes.json` 并显示离线示例提示。这是展示用数据，不是当前月份的离线缓存。

`TodayViewModel` 计算下一拜和倒计时；日期显示使用 `Asia/Kuala_Lumpur`。`NotificationService` 调度当天启用的提醒。档案、语言、打卡和计数保存在 `UserDefaults`；没有账号同步。

## 目录

```text
WaktuMate.xcodeproj/     Xcode target 与构建设置
WaktuMate/App/          应用入口和档案导航
WaktuMate/Models/       日期、区域、礼拜、档案和设置
WaktuMate/Services/     API、存储、通知、定位和日历
WaktuMate/ViewModels/   页面状态和计算
WaktuMate/Views/        SwiftUI 界面
WaktuMate/Resources/    区域与离线示例
```

[设计说明](docs/design.md)记录界面和档案的原则。各档案背景使用 AI 辅助生成的本地资源。

## 当前范围

支持英文、马来语和中文，包含地图外链、参考资料入口、节日通知和 Apple Calendar 导出。没有月度离线缓存、后台持续刷新或 Home Screen Widget。现有目录没有自动化测试套件；API 可用性、真实设备通知及跨日期行为需要分别验收。
