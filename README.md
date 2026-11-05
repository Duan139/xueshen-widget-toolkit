# xueshen-widget-toolkit

深职大「学深星球」教务 App 桌面小组件的逆向改造工具集与工程记录。

本仓库**不包含任何 APK、原始二进制或账号数据**，只包含：

- `tools/` —— ART 运行时校验脚手架（Java，配合 `app_process` 在真机/模拟器上强制校验 dex）与 dex 二进制补丁脚本（Python）
- `patches/` —— 小组件改造涉及的 4 个 smali/布局文件（改造后的完整版本）
- `docs/` —— 两份工程审计记录（闪退根因定位、双栏组件改造）
- `screenshots/` —— 合成数据下的渲染验证图

## 背景

对 v2.6.10（versionCode 163）的一个社区修改版做二次修复与功能扩展：

1. **闪退根因**：`WidgetCountdownHelper.isWithinEveningBlock(JII)Z` 的 smali 寄存器错位（把 long 高半区当 int 传参），ART 类加载即 `VerifyError`，表现为「登录后返回桌面就退出」。修复 = 改 2 个操作数字节。
2. **双栏小组件**：把 4×2 组件从 7 列周视图重绘为「左：实时时钟 + 当前课倒计时 + 老师 + 教室；右：接下来的课程」，并新增课前主动震动。

## 关键方法论（详见 docs/）

- **APK 条目 diff 必须用 Python `zipfile` 的 `i.CRC`**。.NET Framework 的 `ZipArchiveEntry` 没有 `Crc32` 属性，取到的是 null，会把全部条目误判为「相同」。
- **ART 是懒校验**：`Class.forName(n, false, loader)` 不触发 verifier，全包扫描必须 `initialize=true`。
- **`app_process` 裸跑的四类假阳性**：无主线程 Looper（Snackbar 连坐拒绝）、无 Typeface 单例（TextView inflate NPE）、懒校验、`dex2oat --compiler-filter=verify` 失败仍 exit 0。运行期验证是唯一可靠手段。
- **dex 内改字节后必须重算 header**：checksum(adler32)@0x08 覆盖 `[0x0C, end)`，signature(sha1)@0x0C 覆盖 `[0x20, end)`。
- **`.locals N` 撞寄存器**是 smali 手改最常见的隐性 bug 来源，`dexdump` 的 `registers:` 字段是唯一可靠的核对手段。

## 使用

```bash
# 全包校验（设备需已连接 adb）
javac -bootclasspath $ANDROID_HOME/platforms/android-34/android.jar tools/VAll4.java
# d8 打包成 jar 后 push，再：
adb shell "export CLASSPATH=/data/local/tmp/vall4.jar:/data/local/tmp/target.apk; \
  app_process /data/local/tmp VAll4 /data/local/tmp/classes_all.txt"
```

## 法律与边界声明

- 本项目是对**已安装应用**的逆向工程记录，仅用于个人设备上的功能修复与互操作性研究。
- 不包含、也不提供原始 App 的任何二进制分发。
- 改造涉及签名证书变更；覆盖安装行为由使用者自行判断。
- 所有文档中的账号、课表、教师信息均已脱敏或为合成数据。

## License

MIT
