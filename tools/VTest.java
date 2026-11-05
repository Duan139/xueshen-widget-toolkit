public class VTest {
    public static void main(String[] args) throws Exception {
        try {
            Class<?> c = Class.forName("com.szpu.nativeapp.widget.WidgetCountdownHelper");
            java.lang.reflect.Method m =
                c.getDeclaredMethod("isWithinEveningBlock", long.class, int.class, int.class);
            m.setAccessible(true);
            // 2026-11-03 20:30 local, inside the 19-20 (period 9-10) evening block
            long now = java.time.LocalDateTime.of(2026, 11, 3, 20, 30)
                             .atZone(java.time.ZoneId.systemDefault()).toInstant().toEpochMilli();
            Object r = m.invoke(null, now, 9, 10);
            System.out.println("RESULT verify=OK invoke=" + r);
        } catch (Throwable t) {
            System.out.println("RESULT FAILED " + t.getClass().getName() + ": " + t.getMessage());
        }
    }
}
