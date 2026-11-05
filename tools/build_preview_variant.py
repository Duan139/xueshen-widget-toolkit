"""Build a temporary DEBUG variant that injects a preview Activity so the widget
layout can be rendered inside the real app process (app_process has no fonts).

Not for delivery: the final APK is built from the same tree WITHOUT this step.
"""
import os, re, shutil, subprocess, sys, zipfile

ROOT = r"<WORKSPACE>\archive\xueshen-mod9"
SRC = os.path.join(ROOT, "mod9_src")
SDK = r"<HOME>\.trae-cn\work\6a916ec1a5ed2ed019475b5b\android-sdk"
JDK = r"<HOME>\.trae-cn\work\6a916ec1a5ed2ed019475b5b\jdk17\jdk-17.0.20.1+1"
AJAR = os.path.join(SDK, "platforms", "android-34", "android.jar")
D8 = os.path.join(SDK, "build-tools", "34.0.0", "d8.bat")
APKTOOL = r"d:\antigravity project\szpu_phone_mod\tools\apktool.jar"
CLS = os.path.join(ROOT, "pvcls")
MANIFEST = os.path.join(SRC, "AndroidManifest.xml")
ACT = "com.szpu.nativeapp.debug.WidgetPreviewActivity"

def run(cmd, **kw):
    p = subprocess.run(cmd, capture_output=True, text=True, **kw)
    return p.returncode, (p.stdout or "") + (p.stderr or "")

def main():
    # 1. compile + dex
    shutil.rmtree(CLS, ignore_errors=True)
    os.makedirs(CLS, exist_ok=True)
    rc, out = run([os.path.join(JDK, "bin", "javac.exe"), "-encoding", "UTF-8", "-nowarn",
                   "-source", "8", "-target", "8", "-bootclasspath", AJAR,
                   "-d", CLS, os.path.join(ROOT, "WidgetPreviewActivity.java")])
    print("javac", rc, out[:800])
    if rc != 0:
        return 1
    cls = os.path.join(CLS, "com", "szpu", "nativeapp", "debug", "WidgetPreviewActivity.class")
    rc, out = run([D8, "--release", "--min-api", "26", "--lib", AJAR,
                   "--output", CLS, cls])
    print("d8", rc, out[:800])
    if rc != 0:
        return 1
    dex5 = os.path.join(CLS, "classes.dex")
    print("classes5 size", os.path.getsize(dex5))

    # 2. manifest: inject activity (idempotent)
    xml = open(MANIFEST, encoding="utf-8").read()
    if ACT not in xml:
        tag = ('        <activity android:exported="true" android:name="%s"/>' % ACT)
        # insert right after the MainActivity block closes
        anchor = "</activity>"
        i = xml.index(anchor)
        # find the activity start preceding this; insert after its closing tag
        xml = xml[: i + len(anchor)] + "\n" + tag + xml[i + len(anchor):]
        open(MANIFEST, "w", encoding="utf-8", newline="\n").write(xml)
        print("manifest: activity injected")
    else:
        print("manifest: activity already present")

    # 3. apktool build
    out_apk = os.path.join(ROOT, "mod9-preview-unsigned.apk")
    if os.path.exists(out_apk):
        os.remove(out_apk)
    env = dict(os.environ, JAVA_HOME=JDK)
    rc, out = run([os.path.join(JDK, "bin", "java.exe"), "-jar", APKTOOL, "b", SRC, "-o", out_apk], env=env)
    print("apktool", rc, out[-1500:])
    if rc != 0 or not os.path.exists(out_apk):
        return 1

    # 4. inject classes5.dex
    tmp = out_apk + ".tmp"
    with zipfile.ZipFile(out_apk) as zin, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            zi = zipfile.ZipInfo(item.filename, item.date_time)
            zi.compress_type = item.compress_type
            zi.external_attr = item.external_attr
            zout.writestr(zi, data)
        zi = zipfile.ZipInfo("classes5.dex", (2026, 11, 5, 0, 0, 0))
        zi.compress_type = zipfile.ZIP_DEFLATED
        zout.writestr(zi, open(dex5, "rb").read())
    os.replace(tmp, out_apk)
    with zipfile.ZipFile(out_apk) as z:
        names = [n for n in z.namelist() if n.endswith(".dex")]
        print("dex entries:", sorted(names))
    print("built", out_apk, os.path.getsize(out_apk))
    return 0

if __name__ == "__main__":
    sys.exit(main())
