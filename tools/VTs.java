import android.os.Looper;

/** Targeted: does TimetableSettingsActivity verify+link cleanly in each build? */
public class VTs {
    public static void main(String[] args) throws Exception {
        Looper.prepareMainLooper();
        String cn = "com.szpu.nativeapp.TimetableSettingsActivity";
        try {
            Class<?> c = Class.forName(cn, false, VTs.class.getClassLoader());
            java.lang.reflect.Method m = c.getDeclaredMethod("onCreate", android.os.Bundle.class);
            System.out.println("VERIFY+LINK OK  " + cn + "  onCreate=" + m);
        } catch (VerifyError ve) {
            System.out.println("VERIFYERROR " + cn + " :: " + ve.getMessage());
        } catch (Throwable t) {
            System.out.println(t.getClass().getName() + " " + cn + " :: " + t.getMessage());
        }
    }
}
