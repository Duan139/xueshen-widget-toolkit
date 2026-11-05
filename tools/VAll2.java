import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

/**
 * Force-verify every class named in classes.txt against the class loader whose
 * path already includes the target APK. Real ART verifier, on-device.
 *
 * initialize=false: we want verification + linking, not static initializers.
 *
 *   args[0] = path to classes.txt
 */
public class VAll2 {
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
        int linkErr = 0;
        int skipped = 0;
        int ok = 0;
        for (int i = 0; i < names.size(); i++) {
            String cn = names.get(i);
            try {
                Class.forName(cn, false, VAll2.class.getClassLoader());
                ok++;
            } catch (VerifyError ve) {
                verifyErr++;
                System.out.println("VERIFYERROR " + cn + " :: " + ve.getMessage());
            } catch (ClassNotFoundException cne) {
                skipped++;
            } catch (NoClassDefFoundError nd) {
                skipped++;
            } catch (LinkageError le) {
                linkErr++;
                System.out.println("LINKAGE " + le.getClass().getSimpleName() + " " + cn + " :: " + le.getMessage());
            } catch (Throwable t) {
                skipped++;
            }
        }
        System.out.println("SUMMARY ok=" + ok + " verifyErr=" + verifyErr
                + " linkErr=" + linkErr + " skipped=" + skipped);
    }
}
