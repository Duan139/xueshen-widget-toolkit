import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.time.ZoneId;

/** Pin down the exact end-boundary convention of the patched isWithinEveningBlock. */
public class VBound {
    public static void main(String[] args) throws Exception {
        Class<?> c = Class.forName("com.szpu.nativeapp.widget.WidgetCountdownHelper");
        Method m = c.getDeclaredMethod("isWithinEveningBlock", long.class, int.class, int.class);
        m.setAccessible(true);

        // block 9-10 = 17:30 .. 18:55
        p(m, "18:54:59.999", 2026, 11, 3, 18, 54, 59, 999, 9, 10);
        p(m, "18:55:00.000", 2026, 11, 3, 18, 55, 0, 0, 9, 10);
        // start boundary
        p(m, "17:19:59.999", 2026, 11, 3, 17, 19, 59, 999, 9, 10);
        p(m, "17:20:00.000", 2026, 11, 3, 17, 20, 0, 0, 9, 10);
        p(m, "17:29:59.999", 2026, 11, 3, 17, 29, 59, 999, 9, 10);
        p(m, "17:30:00.000", 2026, 11, 3, 17, 30, 0, 0, 9, 10);
    }

    static void p(Method m, String label, int y, int mo, int d, int h, int mi, int s, int ms, int a, int b)
            throws Exception {
        long now = LocalDateTime.of(y, mo, d, h, mi, s).atZone(ZoneId.systemDefault())
                .toInstant().toEpochMilli() + ms;
        System.out.println(label + " -> " + m.invoke(null, now, a, b));
    }
}
