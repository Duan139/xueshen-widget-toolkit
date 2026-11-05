import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

/**
 * Force-verify every class named in args[0] against the class loader whose path
 * already includes the target APK. Real ART verifier, on-device.
 *
 * initialize=true is REQUIRED: ART performs class verification lazily, so
 * Class.forName(n, false, ...) resolves without verifying and silently reports
 * zero failures. Static initializers will throw on many classes; those surface
 * as ExceptionInInitializerError and are counted separately from VerifyError.
 */
public class VAll3 {
    public static void main(String[] args) throws Exception {
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
                Class.forName(cn, true, VAll3.class.getClassLoader());
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
                } else if (c != null && c.getClass().getName().contains("MissingResource")) {
                    skipped++;
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
