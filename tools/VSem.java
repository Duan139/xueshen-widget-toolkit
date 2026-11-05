import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.time.ZoneId;

/**
 * Semantic test for the patched WidgetCountdownHelper.isWithinEveningBlock.
 *
 * Mod9 spec (handover doc): periods 9-10 = 17:30-18:55, periods 11-12 = 19:05-20:30,
 * and the reminder window opens 10 minutes early (const-wide/32 = 600000 ms in the body).
 *
 * The method body is:
 *   start = startTimeForPeriod(a); end = endTimeForPeriod(b)
 *   return now >= (epoch(start) - 600000) && now <= epoch(end)
 *
 * After the register fix, a and b must be the two period numbers, so the
 * boundary probes below have exactly one answer each.
 */
public class VSem {
    static Method startM, endM, blockM;
    static int pass = 0, fail = 0;

    public static void main(String[] args) throws Exception {
        Class<?> c = Class.forName("com.szpu.nativeapp.widget.WidgetCountdownHelper");
        startM = c.getDeclaredMethod("startTimeForPeriod", int.class);
        endM = c.getDeclaredMethod("endTimeForPeriod", int.class);
        blockM = c.getDeclaredMethod("isWithinEveningBlock", long.class, int.class, int.class);
        startM.setAccessible(true); endM.setAccessible(true); blockM.setAccessible(true);

        System.out.println("period 9  start=" + startM.invoke(null, 9) + "  period 10 end=" + endM.invoke(null, 10));
        System.out.println("period 11 start=" + startM.invoke(null, 11) + "  period 12 end=" + endM.invoke(null, 12));

        // 9-10 block: 17:30-18:55, window opens 17:20
        probe("09-10 @17:19 (before window)", 9, 10, 2026, 11, 3, 17, 19, false);
        probe("09-10 @17:20 (window opens)", 9, 10, 2026, 11, 3, 17, 20, true);
        probe("09-10 @17:30 (start)", 9, 10, 2026, 11, 3, 17, 30, true);
        probe("09-10 @18:55 (end)", 9, 10, 2026, 11, 3, 18, 55, true);
        probe("09-10 @18:56 (after end)", 9, 10, 2026, 11, 3, 18, 56, false);

        // 11-12 block: 19:05-20:30, window opens 18:55
        probe("11-12 @18:54 (before window)", 11, 12, 2026, 11, 3, 18, 54, false);
        probe("11-12 @18:55 (window opens)", 11, 12, 2026, 11, 3, 18, 55, true);
        probe("11-12 @20:30 (end)", 11, 12, 2026, 11, 3, 20, 30, true);
        probe("11-12 @20:31 (after end)", 11, 12, 2026, 11, 3, 20, 31, false);

        // Cross-block: a 9-10 query must not be satisfied by 11-12's clock and vice versa
        probe("09-10 @20:00 (wrong block)", 9, 10, 2026, 11, 3, 20, 0, false);
        probe("11-12 @17:30 (wrong block)", 11, 12, 2026, 11, 3, 17, 30, false);

        System.out.println("SEM SUMMARY pass=" + pass + " fail=" + fail);
    }

    static void probe(String label, int a, int b, int y, int mo, int d, int h, int mi, boolean expect)
            throws Exception {
        long now = LocalDateTime.of(y, mo, d, h, mi).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
        boolean got = ((Boolean) blockM.invoke(null, now, a, b)).booleanValue();
        boolean ok = got == expect;
        if (ok) pass++; else fail++;
        System.out.println((ok ? "PASS " : "FAIL ") + label + " expect=" + expect + " got=" + got);
    }
}
