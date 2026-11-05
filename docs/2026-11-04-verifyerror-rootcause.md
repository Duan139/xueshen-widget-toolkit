# 学深星球 Mod9 闪退根因与修复 — 2026-11-04

## 结论

Mod9 候选包「登录后退回桌面」不是玄学，是**确定性字节码校验失败**。ART 在类加载时
拒绝 `WidgetCountdownHelper`，任何触发该类首次加载的代码路径都会让进程当场死掉。

登录返回 → `MainActivity.onResume()` → 异步快照排程 → 加载 `WidgetCountdownHelper`
→ `VerifyError` → 回桌面。荣耀真机与 MuMu 模拟器复现的是同一条错误。

## 缺陷 1（本次崩溃根因）

```
java.lang.VerifyError: Verifier rejected class com.szpu.nativeapp.widget.WidgetCountdownHelper:
  boolean isWithinEveningBlock(long, int, int) failed to verify:
  [0x0] register v9 has type Long (High Half) but expected Integer
```

真机栈：`MainActivity.onResume(MainActivity.java:164)`
模拟器栈：`widget.CourseReminderSnapshotRunnable.run(Unknown Source:24)`
（两者是同一条异步快照路径的两端，与交接说明「onResume 只做异步快照补排」一致。）

`isWithinEveningBlock(JII)Z` 是 `private static`，寄存器固定：

| reg | 含义 |
|---|---|
| v8 | nowMillis 低 32 位 |
| v9 | nowMillis 高 32 位 |
| v10 | startPeriod |
| v11 | endPeriod |

Mod9 写的是 `startTimeForPeriod(v9)` / `endTimeForPeriod(v10)`，整体错位一格，
把 long 的高半区当 int 传。校验器第一条指令就拒。

修复：v9→v10、v10→v11。两个操作数字节，代码长度与所有跳转偏移不变。

```
before: 71 10 11 df 09 00 0c 00 71 10 f5 de 0a 00 0c 01
after : 71 10 11 df 0a 00 0c 00 71 10 f5 de 0b 00 0c 01
```

## 缺陷 2（修好缺陷 1 后必然接着崩，交接说明未记录）

```
java.lang.VerifyError: Verifier rejected class com.cloudslow.szpu.bandsync.AlertScheduler:
  java.util.List upcoming(String, long, long, int) failed to verify:
  [0x72] copy2 v5<-v14 type=Undefined/Undefined
```

在 **classes4.dex**。交接说明的 methodlevel 候选已经修掉了这一处，手机上那份
countdown-candidate 没有。`AlertScheduler` 同样在 onResume 的排程路径上。

## 之前「静态对比没找到业务逻辑被改」是怎么错的

两个独立的假阴性，都必须记住：

1. **`.NET Framework` 的 `System.IO.Compression.ZipArchiveEntry` 没有 `Crc32` 属性。**
   取它得到 `$null`，于是所有条目的 CRC 都「相等」，diff 报 0 项变更。
   → 用 Python `zipfile` 重算，真实变更 **49 个文件**，包含 `classes.dex` 与 `classes4.dex`。

2. **`Class.forName(name, false, loader)` 不做校验。** ART 是懒校验，
   不初始化就不会触发 verifier，全包扫描报 `verifyErr=0`。
   → 改 `initialize=true` 后立刻复现，并挖出缺陷 2。

## 包谱系（全部实测）

| 包 | 证书 SHA-256 | 缺陷1 | 缺陷2 |
|---|---|---|---|
| 学深星球_手机精简适配版_v2.6.10 | `94123652…` 正式 keystore | 不含该类 | 正常 |
| 手机上 countdown-candidate（作废） | `780023dc…` XueShen Temporary Test | **坏** | **坏** |
| 交接说明 methodlevel-static-signed | `5994739e…` = Mod9 原版证书 | **坏** | 已修 |
| **本次交付 fixed** | `5994739e…` Mod9 原版证书 | **已修** | 已修 |

- 交接说明指定的基线 `mod9.apk`（`cc7515c9…`）**本机不存在**，全盘与会话历史均无。
  因此以说明自带的 methodlevel 候选为基线打补丁。
- 交付包与 methodlevel **仅差 2 个字节** + 重新签名，改动面最小。
- 「精简适配版」是另一条血脉，不是 Mod9 基线。

## 验证（全程不装包、不碰手机数据）

设备：HONOR REP-AN00（Android 15，无 root，非 debuggable）
方法：`app_process` 把 APK 挂进 classpath，让真机 ART 自己校验。

| 测试 | 坏包 | 修好包 |
|---|---|---|
| 单类校验 + 反射调用 | VerifyError（与 dropbox 逐字相同） | `verify=OK` |
| 全包 9651 类扫描 | verifyErr=3 | verifyErr=1（Snackbar，基线也有，非 Mod9 回归） |
| 语义边界 | — | 见下 |

语义实测（反射调用私有方法）：

```
period 9 start=17:30   period 10 end=18:55
period 11 start=19:05  period 12 end=20:30
17:19:59.999 -> false    17:20:00.000 -> true     ← 提前 10 分钟开窗
18:54:59.999 -> true     18:55:00.000 -> false    ← 下课即不属于本节
20:00 查 9-10 节 -> false                        ← 不串节
```

区间为 `[开课-10min, 下课)`，左闭右开，与交接说明一致。

## 端到端（MuMu 克隆机，源机未动）

克隆 VM-0 → VM-1，在 VM-1 上做 A/B：

1. 装 methodlevel（坏）→ 启动 → **崩溃**，dropbox 记录缺陷 1，栈为
   `CourseReminderSnapshotRunnable.run`
2. `install -r` 覆盖为 fixed（同证书，覆盖成功）→ 启动 → 存活
3. home / 重新进入 ×3 强制走 onResume → 全部存活，crash buffer 干净
4. 发 `ACTION_APPWIDGET_UPDATE` 广播打组件刷新 → 存活
5. 打开周课表页 → 正常渲染（显示「请先登录」）
6. 全程同一 PID 2467 未重启

**未验证**：教务账号真实登录。克隆机没有登录态，我没有拿你的账号去登录。

## 上手机前的硬约束

手机现装证书 `780023dc`，交付包证书 `5994739e`。**不同证书无法覆盖安装**，
只能卸载重装，本地登录态与学习进度会丢（无 root、非 debuggable、无备份通道）。

## 交付物

`xueshen-mod9-countdown-fixed-20261103.apk`
SHA-256 `65A873BB5032C73B77C820E6FBA0A68E69258067588ACE1AC80670B8458D2635`
13,750,146 B，apksigner V1+V2+V3 通过，zipalign 通过。

## 遗留

- `BaseSzpuActivity.onStart:224` 的 `DETECT_SCREEN_CAPTURE` SecurityException
  （今早 08:25 那批崩溃）是**另一个更早构建**的问题，当前包已声明该权限，不再复现。
- 交接说明的 `hasAnyWidget()` 无调用点（会留下无用刷新闹钟）仍未处理。

## 追加核验（2026-11-04 第二轮）：两处「遗留」都不成立

上一节我写的两条遗留里，第二条是**错的**，一并纠正。

### 1. `TimetableSettingsActivity.onCreate` —— 交付包已无此问题

| 构建 | 该类校验结果 |
|---|---|
| 精简适配版 v2.6.10（基线） | **VerifyError**（`initialize=true` 下稳定复现） |
| 本次交付包 | `VERIFY+LINK OK` |

实测：在模拟器上直接拉起 `TimetableSettingsActivity`，课表设置页正常渲染（调课开关、
课表颜色、节数、字体滑杆全部可见），进程存活，crash buffer 干净。

结论：缺陷真实存在于**基线**，但 Mod9 谱系已经修掉了它。**不需要再动。**
我上一轮把它列成交付包的遗留，是读串了包。

### 2. Snackbar / BaseTransientBottomBar —— 测试脚手架的假阳性

`app_process` 裸跑没有主线程 Looper。`BaseTransientBottomBar` 的静态块要建 `Handler`，
在 null Looper 上 NPE → 父类变 erroneous → 子类 `Snackbar` 被**连坐**拒绝，
报成一条看着很像真的 VerifyError。

加上 `Looper.prepareMainLooper()` 后：

```
mainLooper=Looper (main, tid 2)
OK  com.google.android.material.snackbar.BaseTransientBottomBar
OK  com.google.android.material.snackbar.Snackbar
```

### 交付包最终扫描结果

带主线程 Looper、`initialize=true` 重跑全包：

```
CLASSES 9651
SUMMARY ok=9643 verifyErr=0 otherLinkErr=0 clinitErr=3 skipped=5
```

`verifyErr=0`。Mod9 引入的两处校验失败全部清除，无第三处。

### 脚手架教训（写进技法记忆）

`app_process` 里做 ART 校验扫描，两个假阳性来源必须同时排除：
① `initialize` 必须为 true（懒校验）；② 必须先 `Looper.prepareMainLooper()`，
否则任何静态块碰 Handler 的框架类都会连累其全部子类。
两者缺一都会得出错误结论——我第一轮栽在①，第二轮栽在②。

