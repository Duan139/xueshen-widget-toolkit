import java.io.*;
import java.util.*;

/**
 * Force-verify every class named in classes.txt against the class loader that
 * already has the target APK on its path. Real ART verifier, on-device.
 *   args[0] = path to classes.txt
 */
public class VAll {
    public static void main(String[] args) throws Exception {
        ArrayList<String> names = new ArrayList<String>();
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (line.length() > 0) names.add(line);
        }
        br.close();
        System.out.println("CLASSES " + names.size());

        int verifyErr = 0, linkErr = 0, skipped = 0, ok = 0;
        for (String cn : names) {
            try {
                Class.forName(cn, false, VAll.class.getClassLoader());
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

