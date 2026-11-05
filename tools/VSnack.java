import java.util.ArrayList;

/**
 * Isolate the Snackbar/BaseTransientBottomBar verifier complaint.
 * Load the parent first, then the child, and print each outcome separately.
 */
public class VSnack {
    public static void main(String[] args) {
        String[] chain = {
            "com.google.android.material.bottomtransientview.BaseTransientBottomBar",
            "com.google.android.material.snackbar.BaseTransientBottomBar",
            "com.google.android.material.snackbar.Snackbar",
            "com.google.android.material.snackbar.SnackbarContentLayout",
        };
        for (String cn : chain) {
            try {
                Class<?> c = Class.forName(cn, true, VSnack.class.getClassLoader());
                System.out.println("OK       " + cn + "  clinit ran");
            } catch (VerifyError ve) {
                System.out.println("VERIFYERR " + cn + " :: " + ve.getMessage());
            } catch (ClassNotFoundException e) {
                System.out.println("ABSENT    " + cn);
            } catch (Throwable t) {
                System.out.println(t.getClass().getSimpleName() + " " + cn + " :: " + t.getMessage());
                Throwable c = t.getCause();
                while (c != null) {
                    System.out.println("   caused by " + c.getClass().getName() + ": " + c.getMessage());
                    c = c.getCause();
                }
            }
        }
    }
}
