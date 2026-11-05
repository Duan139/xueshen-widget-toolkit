import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Chronometer;
import android.widget.RemoteViews;
import java.io.FileOutputStream;
import java.lang.reflect.Method;

public class WInflate {
    public static void main(String[] args) {
        try {
            Looper.prepareMainLooper();

            Class<?> at = Class.forName("android.app.ActivityThread");
            Method systemMain = at.getMethod("systemMain");
            Object thread = systemMain.invoke(null);
            Context sys = (Context) at.getMethod("getSystemContext").invoke(thread);

            Context app = sys.createPackageContext("com.cloudslow.szpu",
                    Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);

            Class<?> rLayout = Class.forName("com.szpu.nativeapp.R$layout");
            int layoutId = rLayout.getField("widget_timetable_medium").getInt(null);
            System.out.println("layoutId=0x" + Integer.toHexString(layoutId));

            android.view.LayoutInflater inf = android.view.LayoutInflater.from(
                    new android.view.ContextThemeWrapper(app, 16974546));
            View root = inf.inflate(layoutId, null);
            System.out.println("inflated=" + root.getClass().getName());

            // show today_content, hide empty_content
            Class<?> rId = Class.forName("com.szpu.nativeapp.R$id");
            int idToday = rId.getField("today_content").getInt(null);
            int idEmpty = rId.getField("empty_content").getInt(null);
            View vToday = root.findViewById(idToday);
            View vEmpty = root.findViewById(idEmpty);
            if (vToday != null) vToday.setVisibility(View.VISIBLE);
            if (vEmpty != null) vEmpty.setVisibility(View.GONE);

            // course rows: make row 1..4 visible with sample text
            String[] titles = {"高等数学", "大学英语", "程序设计基础", "大学物理"};
            String[] periods = {"第 1 节", "第 3 节", "第 5 节", "第 7 节"};
            String[] places = {"留仙洞 3 号楼 405\n张老师", "明德楼 201\n李老师", "知行楼 502\n王老师", "博学楼 101\n赵老师"};
            for (int i = 1; i <= 6; i++) {
                int idRow = rId.getField("course_row_" + i).getInt(null);
                View row = root.findViewById(idRow);
                if (row == null) continue;
                if (i <= 4) {
                    row.setVisibility(View.VISIBLE);
                    int idT = rId.getField("course_title_" + i).getInt(null);
                    int idP = rId.getField("course_period_" + i).getInt(null);
                    int idPl = rId.getField("course_place_" + i).getInt(null);
                    TextView t = (TextView) root.findViewById(idT);
                    TextView p = (TextView) root.findViewById(idP);
                    TextView pl = (TextView) root.findViewById(idPl);
                    if (t != null) t.setText(titles[i - 1]);
                    if (p != null) {
                        if (p instanceof Chronometer) {
                            p.setText("距上课 08:42");
                            System.out.println("period_" + i + " is Chronometer (countdown slot)");
                        } else {
                            p.setText(periods[i - 1]);
                        }
                    }
                    if (pl != null) { pl.setText(places[i - 1]); pl.setVisibility(View.VISIBLE); }
                } else {
                    row.setVisibility(View.GONE);
                }
            }

            // check TextClock present
            boolean hasTextClock = false;
            if (root instanceof ViewGroup) {
                hasTextClock = findTextClock((ViewGroup) root);
            }
            System.out.println("hasTextClock=" + hasTextClock);

            int w = 1000, h = 440;
            root.measure(View.MeasureSpec.makeMeasureSpec(w, View.MeasureSpec.EXACTLY),
                         View.MeasureSpec.makeMeasureSpec(h, View.MeasureSpec.EXACTLY));
            root.layout(0, 0, w, h);
            System.out.println("measured=" + root.getMeasuredWidth() + "x" + root.getMeasuredHeight());

            Bitmap bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
            Canvas c = new Canvas(bmp);
            c.drawColor(0xFF202830);
            root.draw(c);

            String out = args.length > 0 ? args[0] : "/data/local/tmp/widget.png";
            FileOutputStream fos = new FileOutputStream(out);
            bmp.compress(Bitmap.CompressFormat.PNG, 100, fos);
            fos.close();
            System.out.println("WROTE " + out + " " + w + "x" + h);

        } catch (Throwable t) {
            System.out.println("RESULT FAILED " + t);
            t.printStackTrace(System.out);
        }
    }

    static boolean findTextClock(ViewGroup g) {
        for (int i = 0; i < g.getChildCount(); i++) {
            View v = g.getChildAt(i);
            if (v.getClass().getName().equals("android.widget.TextClock")) return true;
            if (v instanceof ViewGroup && findTextClock((ViewGroup) v)) return true;
        }
        return false;
    }
}
