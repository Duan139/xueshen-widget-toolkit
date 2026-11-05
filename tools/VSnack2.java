import android.os.Looper;

/**
 * The earlier Snackbar "VERIFYERROR" is an artifact of app_process having no main
 * Looper: BaseTransientBottomBar's static initializer builds a Handler, NPEs on the
 * null Looper, the parent becomes erroneous, and the child Snackbar is rejected by
 * association. Prepare a main looper first and retest.
 */
public class VSnack2 {
    public static void main(String[] args) {
        Looper.prepareMainLooper();
        System.out.println("mainLooper=" + Looper.getMainLooper());
        String[] chain = {
            "com.google.android.material.snackbar.BaseTransientBottomBar",
            "com.google.android.material.snackbar.Snackbar",
        };
        for (String cn : chain) {
            try {
                Class.forName(cn, true, VSnack2.class.getClassLoader());
                System.out.println("OK        " + cn);
            } catch (VerifyError ve) {
                System.out.println("VERIFYERR " + cn + " :: " + ve.getMessage());
            } catch (Throwable t) {
                System.out.println(t.getClass().getSimpleName() + " " + cn + " :: " + t.getMessage());
                Throwable c = t.getCause();
                while (c != null) {
                    System.out.println("   caused by " + c.getClass().getName() + ": " + c.getMessage());
                    c = c.getCause();
                }
            }
        }
        System.out.println("DONE");
    }
}
