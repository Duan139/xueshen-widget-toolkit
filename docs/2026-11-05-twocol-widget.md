# 学深星球 双栏倒计时小组件 — 改造与验证记录（2026-11-05）

交付物：`<DESKTOP>/xueshen-mod9-twocol-20261105.apk`
- size 13,319,101 B
- SHA-256 `72EB71290FFDC516E5F0888ECC8B69CE43DA3574DC8A81E3B963A36E4E1FEF3C`
- 签名 `C=US, O=Android, CN=Android Debug`，SHA-256 `5994739e4ae0e2e69e016074d28e6815e2d479c3d5ceadb82f4fad1af5e2ed08`（= Mod9 原版证书，可覆盖升级）
- 包名 `com.cloudslow.szpu`，versionCode 163 / versionName 2.6.10
- zipalign `-c -v 4` 通过；dex 仅 classes/2/3/4（无调试 classes5.dex）

## 改动清单

| 文件 | 改动 |
|---|---|
| `res/layout/widget_timetable_medium.xml` | 整文件重写为双栏：左栏 TextClock(HH:mm) + 课程/倒计时/老师/教室；右栏「接下来的课程」列表 course_row_2..6 |
| `TimetableWidgetRenderer.smali` | 新增 `detailLines(Line)String`（把 `teacher · place（floor）` 的 ` · ` 换成换行）；`bindCourseRows` compact=false 分支改为左栏(index 0)走 detailLines 分行、右栏(index≥1)隐藏 place |
| `TimetableWidgetRenderer.smali` | `bindMedium` 的 `bindCourseRows` maxRows 由 2 改 6 |
| `WidgetCountdownHelper.smali` | `selectUpcomingLines` 尾部提前返回阈值 `const/4 v7, 0x2` → `0x6`（否则右栏永远只 1 门） |
| `CourseReminderReceiver.smali` | 新增 `private static vibrate(Context)`：`VibrationEffect.createWaveform([0,300,200], -1)`；在 `notify` 前调用 |

未改：提前量仍是 `0x927c0` = 600000ms = **10 分钟**（3 处，用户指定保持不变）；未改数据类 `Line` 字段（老师/教室在渲染层拆分）；未新增资源 ID（public.xml 无需改动）。

## 验证（MuMu VM1，Android 15 / API 35，127.0.0.1:16416）

1. **全包 ART 校验**：`CLASSES 9651 / verifyErr=1`，唯一错误 `Snackbar :: attempts to sub-type erroneous class BaseTransientBottomBar` —— 基线包同样存在，`app_process` 无主线程 Looper 的既有假阳性，非本次引入（加 `Looper.prepareMainLooper()` 后归零）。
2. **真实课表渲染**（`widget-real.png`）：快照 rows=14 / week=9 / term=2026-2027-1，左栏「课程A」+「距上课 31:56」+「张老师」+「教学楼101」，右栏标题正确。
3. **桌面绑定**（`requestPinAppWidget` + `updateAppWidgetOptions(250/110/530/300)` 补尺寸，绕开拖拽）：组件 id=6 挂在 lawnchair。截图 `home-widget-clean.png`：15:44 / 距上课 0:59，TextClock 走真实时间。
4. **点击链路**：点组件 → `TimetableWeekActivity`，第 9 周课表正常渲染（`week-activity.png`），无崩溃。
5. **自动闹钟**（非手动广播）：`dumpsys alarm` 显示 `ACTION_COURSE_REMINDER origWhen=15:35:00`，而 15:45 开课 ⇒ 提前正好 10 分钟。时钟拨到 15:34:30 后等待，闹钟在 15:35:00 自动触发。
6. **通知**（`notification.png`）：「课程即将开始 / 经济学原理·第7-8节·张老师·教学楼101」，`id=5007 importance=4 channel=course_reminders category=alarm`。
7. **手机震动**（`dumpsys vibrator_manager` 双记录）：
   - 主动震动 `duration 553ms usage=TOUCH com.cloudslow.szpu(uid=10073)`，`played [0ms/0.00, 300ms/1.00, 200ms/0.00]` 与代码 `[0,300,200]` 一致
   - 通知渠道震动 `duration 955ms usage=NOTIFICATION`
8. **崩溃**：`logcat -b crash -d` 全程为空。

## 未验证 / 已知限制

- **手环震动未测**：MuMu 无蓝牙手环。代码路径 `AlertReceiver → BandSession.sendAlert` 在包内早已存在，本次未改动。
- 右栏只列「尚未开始」的课（`selectUpcomingLines` 语义），当天无后续课时右栏留空属正确行为。
- 晚间 22:00 后、跨日课、单节课边界仍不可靠倒计时（Mod9 既有边界，本次未改）。
- 荣耀灵动胶囊：四条接入范式当前均不可行（API 35 vs API 36、需荣耀审核、非媒体场景、禁 RemoteViews）。

## 踩坑记录（供后续 session）

- `app_process` 裸跑有四类假阳性：无 Looper → Snackbar 连坐；无 Typeface → 所有 TextView NPE；`Class.forName(n,false,...)` 不触发校验；`dex2oat --compiler-filter=verify` 失败仍 exit 0。
- smali `.locals N` 改错会让 p0 与局部变量撞寄存器（`registers:` 是唯一可靠核对手段）；手写 `if-eqz/if-nez` 极易写反且症状隐蔽，改完必须渲染看图。
- 能用库方法表达的（`String.replace`）不要用 `indexOf`+`substring` 双分支。
- 删 smali 代码块前必须 grep `cond_*/goto_*` 标签引用者，否则 dexlib2 写 code_item 时才报错。
- `adb pull` 在 bash 下需 `export MSYS_NO_PATHCONV=1`；`screencap -p > file` 会破坏 PNG，必须 `screencap -p /sdcard/x.png` + `pull`。
- `am broadcast --el` 值是**毫秒**，`date +%s` 是秒，别忘乘 1000。
