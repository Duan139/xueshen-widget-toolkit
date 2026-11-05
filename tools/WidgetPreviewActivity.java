package com.szpu.nativeapp.debug;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/**
 * DEBUG-ONLY harness: builds the real RemoteViews through TimetableWidgetRenderer.build()
 * with synthetic data, applies it, and rasterises the result so the widget layout can be
 * inspected without a launcher drag. Never shipped.
 */
public class WidgetPreviewActivity extends Activity {

    @Override
    protected void onCreate(Bundle b) {
        super.onCreate(b);
        FrameLayout host = new FrameLayout(this);
        host.setBackgroundColor(0xFF1B2430);

        final TextView status = new TextView(this);
        status.setTextColor(0xFFFFFFFF);
        status.setTextSize(10f);
        FrameLayout.LayoutParams slp = new FrameLayout.LayoutParams(-2, -2);
        slp.topMargin = 8;
        slp.leftMargin = 8;
        host.addView(status, slp);
        setContentView(host);

        try {
            Object entry = buildEntry();
            Object remoteViews = buildRemoteViews(entry);

            // apply RemoteViews into a real view tree
            View root = null;
            try {
                // RemoteViews.apply(Context, ViewGroup)
                java.lang.reflect.Method m = remoteViews.getClass()
                        .getMethod("apply", android.content.Context.class, ViewGroup.class);
                root = (View) m.invoke(remoteViews, this, null);
            } catch (Throwable t) {
                status.setText("apply failed: " + t);
                return;
            }

            int w = 640, h = 300;
            root.measure(View.MeasureSpec.makeMeasureSpec(w, View.MeasureSpec.EXACTLY),
                         View.MeasureSpec.makeMeasureSpec(h, View.MeasureSpec.EXACTLY));
            root.layout(0, 0, w, h);

            FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(w, h);
            lp.topMargin = 380;
            host.addView(root, lp);

            Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
            Canvas c = new Canvas(bmp);
            c.drawColor(0xFF202830);
            root.draw(c);

            File dir = getExternalFilesDir(null);
            if (dir == null) dir = getFilesDir();
            File out = new File(dir, "widget_remoteviews.png");
            FileOutputStream fos = new FileOutputStream(out);
            bmp.compress(Bitmap.CompressFormat.PNG, 100, fos);
            fos.close();

            status.setText("OK " + out.getAbsolutePath() + "  root=" + root.getClass().getSimpleName()
                    + "  clock=" + hasClass((ViewGroup) root, "android.widget.TextClock")
                    + "  chrono=" + hasClass((ViewGroup) root, "android.widget.Chronometer"));
            dumpTexts((ViewGroup) root);
            probeDetailLines();
            fixWidgetSizes();
        } catch (Throwable t) {
            status.setText("FAILED " + t);
            t.printStackTrace(System.out);
        }
    }

    /** Directly invoke detailLines on each sample line and print the codepoints. */
    void probeDetailLines() {
        try {
            Class<?> renderer = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetRenderer");
            java.lang.reflect.Method m = renderer.getDeclaredMethod("detailLines",
                    Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry$Line"));
            m.setAccessible(true);
            Class<?> lineCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry$Line");
            java.lang.reflect.Constructor<?> ctor =
                    lineCls.getConstructor(String.class, String.class, String.class, int.class);
            String[] samples = {
                    "张伟 \u00b7 留仙洞3号楼405",
                    "李娜 \u00b7 明德楼201",
                    "only-teacher-no-place",
                    null,
            };
            for (String s : samples) {
                Object line = ctor.newInstance("x", "y", s, 0);
                try {
                    Object r = m.invoke(null, line);
                    System.out.println("PROBE in=" + esc(s) + " jidx=" + (s == null ? -99 : s.indexOf(" \u00b7 "))
                            + " out=" + esc(String.valueOf(r)));
                } catch (java.lang.reflect.InvocationTargetException ite) {
                    System.out.println("PROBE in=" + esc(s) + " jidx=" + (s == null ? -99 : s.indexOf(" \u00b7 "))
                            + " THREW " + ite.getCause());
                }
            }
        } catch (Throwable t) {
            System.out.println("PROBE FAILED " + t);
        }
    }

    static String esc(String s) {
        StringBuilder sb = new StringBuilder();
        for (char ch : s.toCharArray()) {
            if (ch < 0x20 || ch > 0x7e) sb.append(String.format("<%04x>", (int) ch));
            else sb.append(ch);
        }
        return sb.toString();
    }

    static void dumpTexts(ViewGroup g) {
        for (int i = 0; i < g.getChildCount(); i++) {
            View v = g.getChildAt(i);
            if (v instanceof TextView) {
                TextView t = (TextView) v;
                CharSequence cs = t.getText();
                String s = cs == null ? "null" : cs.toString();
                StringBuilder sb = new StringBuilder();
                for (char ch : s.toCharArray()) {
                    if (ch < 0x20 || ch > 0x7e) sb.append(String.format("<%04x>", (int) ch));
                    else sb.append(ch);
                }
                System.out.println("TXT id=" + v.getId() + " vis=" + v.getVisibility() + " = " + sb);
            }
            if (v instanceof ViewGroup) dumpTexts((ViewGroup) v);
        }
    }

    static boolean hasClass(ViewGroup g, String cn) {        for (int i = 0; i < g.getChildCount(); i++) {
            View v = g.getChildAt(i);
            if (v.getClass().getName().equals(cn)) return true;
            if (v instanceof ViewGroup && hasClass((ViewGroup) v, cn)) return true;
        }
        return false;
    }

    /** Build TimetableWidgetEntry from the REAL saved snapshot; synthetic only as fallback. */
    Object buildEntry() throws Exception {
        Class<?> payload = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetPayload");
        java.lang.reflect.Method load = payload.getMethod("loadSnapshot", android.content.Context.class);
        Object snap = load.invoke(null, this);
        System.out.println("SNAP loaded=" + (snap != null));

        if (snap != null) {
            Class<?> snapCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetPayload$Snapshot");
            Class<?> entryCls0 = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry");
            Class<?> builderCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntryBuilder");
            java.lang.reflect.Method bm = builderCls.getDeclaredMethod("build", snapCls);
            bm.setAccessible(true);
            Object entry = bm.invoke(null, snap);
            Object rows = snapCls.getField("rows").get(snap);
            int week = snapCls.getField("teachingWeekIndex").getInt(snap);
            System.out.println("SNAP rows=" + ((java.util.List<?>) rows).size() + " week=" + week
                    + " entryNull=" + (entry == null));
            if (entry != null) return entry;
        }

        Class<?> lineCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry$Line");
        java.lang.reflect.Constructor<?> lineCtor =
                lineCls.getConstructor(String.class, String.class, String.class, int.class);

        String[][] data = {
                // title, periodText, detailText (teacher · place（floor）), start, end, color
                {"高等数学", "第 9–10 节", "张伟 \u00b7 留仙洞3号楼405", "9", "10", "-16711936"},
                {"大学英语", "第 11–12 节", "李娜 \u00b7 明德楼201", "11", "12", "-16776961"},
                {"程序设计基础", "第 5–6 节", "王强 \u00b7 知行楼502", "5", "6", "-23296"},
                {"数据结构", "第 7–8 节", "赵敏 \u00b7 信息楼301", "7", "8", "-65281"},
                {"线性代数", "第 3–4 节", "陈刚 \u00b7 厚德楼102", "3", "4", "-16744320"},
        };

        List<Object> lines = new ArrayList<Object>();
        Field fStart = lineCls.getField("startPeriod");
        Field fEnd = lineCls.getField("endPeriod");
        for (String[] d : data) {
            Object line = lineCtor.newInstance(d[0], d[1], d[2], (int) Long.parseLong(d[5]));
            fStart.setInt(line, Integer.parseInt(d[3]));
            fEnd.setInt(line, Integer.parseInt(d[4]));
            lines.add(line);
        }

        Class<?> entryCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry");
        java.lang.reflect.Method content = entryCls.getMethod("content",
                String.class, int.class, String.class, String.class,
                List.class, List.class, String.class);
        return content.invoke(null,
                "2026-2027 学年第一学期",   // term
                11,                          // week
                "周三",                      // weekdayLabel
                "2026-11-05",                // todayDateLine
                lines,                       // todayLines
                new ArrayList<Object>(),     // weekColumns
                "数据更新于 14:02");          // footer
    }

    /** Push 4x2 size options onto any bound instance of ours so detectSize() picks MEDIUM. */
    void fixWidgetSizes() {
        try {
            android.appwidget.AppWidgetManager awm =
                    (android.appwidget.AppWidgetManager) getSystemService(android.content.Context.APPWIDGET_SERVICE);
            int[] ids = awm.getAppWidgetIds(new android.content.ComponentName(
                    "com.cloudslow.szpu",
                    "com.szpu.nativeapp.widget.TimetableWidgetTodayProvider"));
            System.out.println("SIZE ids=" + (ids == null ? -1 : ids.length));
            if (ids == null) return;
            for (int id : ids) {
                android.os.Bundle o = new android.os.Bundle();
                o.putInt("appWidgetMinWidth", 250);
                o.putInt("appWidgetMinHeight", 110);
                o.putInt("appWidgetMaxWidth", 530);
                o.putInt("appWidgetMaxHeight", 300);
                awm.updateAppWidgetOptions(id, o);
                System.out.println("SIZE set on id=" + id);
            }
            Class<?> p = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetProvider");
            java.lang.reflect.Method m = p.getMethod("requestUpdateAll", android.content.Context.class);
            m.invoke(null, this);
            System.out.println("SIZE update requested");
        } catch (Throwable t) {
            System.out.println("SIZE FAILED " + t);
        }
    }

    /** Ask the system pin dialog to place the real 4x2 widget on the launcher. */
    void requestPinTotals() {
        try {
            android.appwidget.AppWidgetManager awm =
                    (android.appwidget.AppWidgetManager) getSystemService(android.content.Context.APPWIDGET_SERVICE);
            Class<?> pc = Class.forName("android.appwidget.AppWidgetProviderInfo");
            System.out.println("PIN isRequestPinSupported=" + awm.isRequestPinAppWidgetSupported());
            android.content.ComponentName cn = new android.content.ComponentName(
                    "com.cloudslow.szpu",
                    "com.szpu.nativeapp.widget.TimetableWidgetTodayProvider");
            java.lang.reflect.Method m = awm.getClass().getMethod("requestPinAppWidget",
                    android.content.ComponentName.class, android.os.Bundle.class, android.app.PendingIntent.class);
            Object r = m.invoke(awm, cn, null, null);
            System.out.println("PIN requestPinAppWidget -> " + r);
        } catch (Throwable t) {
            System.out.println("PIN FAILED " + t);
        }
    }

    /** Call TimetableWidgetRenderer.build(Context, Size, Entry) -> RemoteViews. */
    Object buildRemoteViews(Object entry) throws Exception {
        Class<?> sizeCls = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetRenderer$Size");
        Object medium = null;
        for (Object o : sizeCls.getEnumConstants()) {
            if (((Enum<?>) o).name().equals("MEDIUM")) medium = o;
        }
        Class<?> renderer = Class.forName("com.szpu.nativeapp.widget.TimetableWidgetRenderer");
        java.lang.reflect.Method build = renderer.getDeclaredMethod("build",
                android.content.Context.class, sizeCls,
                Class.forName("com.szpu.nativeapp.widget.TimetableWidgetEntry"));
        build.setAccessible(true);
        return build.invoke(null, this, medium, entry);
    }
}
