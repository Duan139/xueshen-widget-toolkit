# 荣耀 MagicOS 日历导入与锁屏提醒辅助方案（2026-11-07）

## 一、背景与限制说明

在荣耀 MagicOS 上，系统级的「灵动胶囊」与「YOYO 建议」卡片直通能力属于受控接口（仓库早期逆向结论已确认非合作方或未接入官方 Kit 的第三方修改版无法直接调用灵动胶囊 API，且曾经尝试伪造 `com.hihonor.widget.type=honorcard` 在真机上未生效）。

因此，在不依赖荣耀私有 SDK 白名单的前提下，目前可行的辅助手段只有两条：
1. **导出标准 `.ics` 日历文件导入系统日历**：借助荣耀系统日历自身的课前提醒以及 YOYO 建议对系统日历日程的识别（在桌面/负一屏展示日程提醒，具体是否出现在 AOD 取决于机型与 MagicOS 版本设置）。
2. **将应用自身的课前通知设为锁屏公开可见（`VISIBILITY_PUBLIC`）**：避免锁屏状态下通知内容被默认折叠为“敏感内容已隐藏”。

---

## 二、方案 A：导出 RFC 5545 标准 `.ics` 课表导入系统日历

仓库提供了 `tools/generate_honor_calendar.py` 脚本，可将课表 JSON 转换为标准 `.ics` 日历文件：
- **固定 UID**：基于学期起始日、周次、星期、节次和课程名生成确定性哈希 UID，重复导入时更新原日程，不会产生重复日程；
- **标准时区**：内置 `VTIMEZONE`（`Asia/Shanghai`），所有 `DTSTART`/`DTEND` 均携带 `TZID=Asia/Shanghai`；
- **支持单双周**：支持 `weekType` 字段（`all` / `odd` / `even` 或 `单周` / `双周`）；
- **RFC 5545 转义与折行**：自动处理特殊字符转义与 75 字节长行折行；
- **课前提醒**：内置 `-PT15M`（课前 15 分钟）`VALARM` 提醒。

### 使用方法
```bash
python3 tools/generate_honor_calendar.py [courses.json] [output.ics]
```
将生成的 `.ics` 文件发送到荣耀手机并用「系统日历」打开导入即可。

---

## 三、方案 B：通知锁屏可见性与倒计时（`CourseReminderReceiver.smali`）

在 `patches/CourseReminderReceiver.smali` 中，课前提醒通知做了如下配置：
- `setVisibility(Notification.VISIBILITY_PUBLIC)` (`0x1`)：声明通知内容可在锁屏上公开显示（最终是否显示仍受用户在系统「设置 > 通知和状态栏 > 锁屏通知」中的全局配置以及 `course_reminders` 渠道设置影响）；
- `setUsesChronometer(true)` + `setChronometerCountDown(true)` + `setWhen(courseStartMillis)`：在锁屏通知卡片上直接显示距离上课的倒计时；
- `setOngoing(true)` + `setTimeoutAfter(courseStartMillis - now)`：课前常驻，到点上课自动消失；
- `setCategory("alarm")`：保留闹钟分类。
