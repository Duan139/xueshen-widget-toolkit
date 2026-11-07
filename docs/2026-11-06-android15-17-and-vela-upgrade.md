# 学深星球 Android 14–16 提醒升级与小米手环 (Vela) 优化说明（2026-11-06）

## 一、改动概述

本次针对深职大「学深星球」小组件与课前提醒补丁，以及小米手环 Vela 快应用做了三部分修改：
1. **Android 16 (API 36) Live Updates 实时通知适配**：在保持原有课前倒计时通知的基础上，为 API 36+ 增加 `setRequestPromotedOngoing(true)` 与 `setShortCriticalText("即将上课")`，并通过 `setTimeoutAfter(courseStartMillis - now)` 在上课时自动消除常驻通知。
2. **Android 14+ 精确闹钟权限缺失时的降级修复**：当 `AlarmManager.canScheduleExactAlarms()` 返回 `false` 或抛出 `SecurityException` 时，降级为 `setAndAllowWhileIdle()`，并去掉接收端原本 60 秒（`0xea60`）的超时丢弃限制，只要在开课前触发都正常弹出提醒。
3. **小米手环 Vela 快应用（`szpu_band_timetable`）交互与定时器优化**：增加切天/进退详情页的短振反馈，将固定 1 秒轮询改为按距离上课时间分段唤醒，并在低频刷新段只显示分钟数，避免秒数跳变。

> [!IMPORTANT]
> 当前仓库仅包含 smali 补丁与辅助脚本，不包含 APK 本体。以下 smali 改动需在本地反编译目录通过 `apktool b` 重新打包，并按仓库 `tools/VAll4.java` 流程在真机 ART 上做验证。

---

## 二、Android 16 (API 36) Live Updates 与倒计时通知（`CourseReminderReceiver.smali`）

### 2.1 Android 16 Live Updates 官方要求
根据 Android 16 官方文档（Create live update notifications），一条通知要提升为状态栏胶囊（Promoted Ongoing Notification / Live Update），必须满足：
1. `AndroidManifest.xml` 声明 `<uses-permission android:name="android.permission.POST_PROMOTED_NOTIFICATIONS" />`；
2. 通知为常驻通知：`setOngoing(true)`；
3. 设置标题 `setContentTitle(...)`；
4. 调用 `setRequestPromotedOngoing(true)`（API 36 新增方法，必须加 `Build.VERSION.SDK_INT >= 36` 判断，否则低版本会抛 `NoSuchMethodError`）；
5. 不可使用自定义 `RemoteViews`，不可开启 `setColorized(true)`，通知渠道重要性不能为 `IMPORTANCE_MIN`。

### 2.2 `CourseReminderReceiver.smali` 实际改动

| 项目 | 原版 Mod9 | 本次修改 |
|---|---|---|
| **迟到闹钟过滤** | 超过 `reminder_fire_millis + 60s` 直接丢弃 | 去掉 60 秒上限，只要 `now >= reminder_fire_millis` 且 `now < course_start_millis` 均正常提醒，配合非精确闹钟降级 |
| **常驻与自动消失** | 普通通知，无倒计时 | `setOngoing(true)` + `setUsesChronometer(true)` + `setChronometerCountDown(true)` + `setWhen(courseStartMillis)`，并设置 `setTimeoutAfter(courseStartMillis - now)` 在开课时自动关闭 |
| **打扰控制** | 默认 | `setOnlyAlertOnce(true)` |
| **通知类别** | `setCategory("alarm")` | 保持 `"alarm"`，避免丢失勿扰模式下的闹钟策略 |
| **锁屏可见性** | 默认 | `setVisibility(VISIBILITY_PUBLIC)` (`0x1`)，具体锁屏展示仍受系统渠道设置与用户隐私设置控制 |
| **API 36 实时胶囊** | 无 | 当 `SDK_INT >= 36` (`0x24`) 时调用 `setRequestPromotedOngoing(true)` 与 `setShortCriticalText("即将上课")` |

---

## 三、Android 14 / 15 / 16 权限与后台限制说明

### 1. 精确闹钟权限（`SCHEDULE_EXACT_ALARM`）
- **背景**：从 Android 14（API 34）开始，针对新安装的普通应用，`SCHEDULE_EXACT_ALARM` 默认不授予，需要用户手动在系统设置中开启。（注：`USE_EXACT_ALARM` 属于日历/闹钟核心应用受限权限，普通第三方/个人打包若不走应用商店审核可以使用，但更稳妥的做法是做好无权限降级。）
- **代码改动（`WidgetCountdownHelper.smali`）**：
  - 在 `setExactReminderAlarm` 中，当 `canScheduleExactAlarms()` 为 `false` 或 `setExactAndAllowWhileIdle` 抛出 `SecurityException` 时，不再直接取消闹钟，而是降级调用 `setAndAllowWhileIdle(RTC_WAKEUP, triggerAtMillis, pendingIntent)`。
  - 同时配合 `CourseReminderReceiver.smali` 放宽触发窗口，避免 Doze 延迟导致提醒被吞。

### 2. Android 16 实时通知权限（`POST_PROMOTED_NOTIFICATIONS`）
- 在打包 APK 的 `AndroidManifest.xml` 中需补充：
  ```xml
  <uses-permission android:name="android.permission.POST_PROMOTED_NOTIFICATIONS" />
  ```
- 如需在设置页引导用户开启，可在 API 36+ 调用 `NotificationManager.canPostPromotedNotifications()` 检查状态。

### 3. 前台服务类型（`FOREGROUND_SERVICE_*`）
- Android 14+ 要求所有前台服务在 Manifest 中声明 `android:foregroundServiceType`。手环同步相关服务应声明为 `connectedDevice` 并配套 `FOREGROUND_SERVICE_CONNECTED_DEVICE` 权限。
- 注：Android 15 新增的前台服务 6 小时超时限制仅针对 `dataSync` 和 `mediaProcessing` 类型，**不影响 `connectedDevice`**。

---

## 四、AndroidManifest.xml 权限参考清单

在反编译目录合并补丁时，建议确认 `AndroidManifest.xml` 包含以下权限声明：

```xml
<!-- 通知与 Android 16 Live Update -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.POST_PROMOTED_NOTIFICATIONS" />

<!-- 精确闹钟 -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

<!-- 提醒与开机重排 -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- 蓝牙手环同步（如启用手环伴侣服务） -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_CONNECTED_DEVICE" />
```

---

## 五、小米手环 Vela 快应用（`szpu_band_timetable`）优化说明

### 5.1 改动内容
1. **自适应刷新间隔与文案匹配**：
   - 距离上课 **> 5 分钟**：每 30 秒刷新一次，并在跨越 5 分钟边界时精准对齐唤醒；文案仅显示 `还有 X分钟` 或 `还有 X小时Y分`，不显示秒数，避免 30 秒刷新导致秒数卡顿跳变。
   - 距离上课 **≤ 5 分钟**：每 1 秒刷新一次，显示 `还有 X分XX秒` / `还有 X秒`，并准时切入「正在上课」状态。
   - **正在上课**：每 30 秒刷新一次剩余分钟数。
   - **今日无课 / 已结课**：每 60 秒检查一次跨天。
2. **触感反馈**：在切换星期（`selectDay`）、进入课程详情（`openDetail`）、返回列表（`goBack`）时调用 `@system.vibrator` 的 `short` 振动。
3. **生产配置**：`manifest.json` 中已将 `debug` 设为 `false`、`logLevel` 设为 `"off"`。

### 5.2 关于 RPK 重新打包与签名的说明
> [!WARNING]
> 直接解压 `.rpk` 修改 webpack 编译产物后再压缩，会导致原有的 `META-INF/CERT` 签名与文件内容不匹配，手环安装器（如 AstroBox / 小米运动健康）可能会拒绝安装。
> 推荐把上述定时器与振动逻辑同步回你本地的 `band_app/src/pages/index/index.ux` 与 `detail/detail.ux` 源码，在 **Xiaomi AIoT-IDE** 中执行 `npm run build` / `npm run release` 用你自己的证书重新编译签名。
