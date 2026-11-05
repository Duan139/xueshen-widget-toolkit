import android.os.Looper;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

/**
 * Force-verify every class named in args[0] against the class loader whose path
 * already includes the target APK. Real ART verifier, on-device.
 *
 * Two artifacts this version removes, both of which produced false positives:
 *   1. initialize must be true -- ART verifies lazily, so Class.forName(n, false, ..)
 *      resolves without ever running the verifier.
 *   2. a main Looper must exist -- under bare app_process, any framework class whose
 *      static initializer builds a Handler NPEs, becomes erroneous, and every
 *      subclass is then rejected "by association" as a bogus VerifyError.
 *
 * Static-initializer failures that are genuinely environmental (no ActivityThread,
 * no display, etc.) are counted separately and are NOT reported as verification bugs.
 */
public class VAll4 {
    public static void main(String[] args) throws Exception {
        Looper.prepareMainLooper();

        ArrayList<String> names = new ArrayList<String>();
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (line.length() > 0) {
                names.add(line);
            }
        }
        br.close();
        System.out.println("CLASSES " + names.size());

        int verifyErr = 0;
        int otherLink = 0;
        int clinitErr = 0;
        int skipped = 0;
        int ok = 0;
        for (int i = 0; i < names.size(); i++) {
            String cn = names.get(i);
            try {
                Class.forName(cn, true, VAll4.class.getClassLoader());
                ok++;
            } catch (VerifyError ve) {
                verifyErr++;
                System.out.println("VERIFYERROR " + cn + " :: " + ve.getMessage());
            } catch (ClassNotFoundException cne) {
                skipped++;
            } catch (NoClassDefFoundError nd) {
                skipped++;
            } catch (ExceptionInInitializerError ei) {
                clinitErr++;
                Throwable c = ei.getCause();
                if (c instanceof VerifyError) {
                    verifyErr++;
                    System.out.println("VERIFYERROR(clinit) " + cn + " :: " + c.getMessage());
                }
            } catch (LinkageError le) {
                otherLink++;
                System.out.println("LINKAGE " + le.getClass().getSimpleName() + " " + cn + " :: " + le.getMessage());
            } catch (Throwable t) {
                skipped++;
            }
        }
        System.out.println("SUMMARY ok=" + ok + " verifyErr=" + verifyErr + " otherLinkErr=" + otherLink
                + " clinitErr=" + clinitErr + " skipped=" + skipped);
    }
}
