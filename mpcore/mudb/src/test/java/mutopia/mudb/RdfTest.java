package mutopia.mudb;

import org.junit.*;
import java.util.Hashtable;
import java.util.Enumeration;

public class RdfTest {

    // A table of test values and expected results
    private final Hashtable<String,Boolean> testgroup;

    // ctor just populates the hashtable for tests
    public RdfTest() {
        testgroup = new Hashtable<>();
        testgroup.put("ftp/MozartWA/KV387/k387/k387-lys/cello-i.ily", true);
        // The following spec is still good but the test will fail if
        // there is ever a check for valid composers.
        testgroup.put("ftp/MoooozartWA/KV387/k387/k387-lys/cello-i.ily", true);
        testgroup.put("ftp/DevienneF/O70", false);
        testgroup.put("ftp/WeckmannM/MWfan/MWfan.ly", true);
        testgroup.put("WeckmannM/MWfan/MWfan.ly", false);
    }

    @Test
    public void testFromName() {
        Enumeration<String> candidates = testgroup.keys();
        while (candidates.hasMoreElements()) {
            String candidate = candidates.nextElement();
            try {
                @SuppressWarnings("UnusedAssignment")
                    MuRDFMap spec = new MuRDFMap(candidate);
                Assert.assertTrue(testgroup.get(candidate));
            }
            catch (MuException ex) {
                // test fails when thrown from a true candidate
                Assert.assertFalse(testgroup.get(candidate));
            }
        }
    }
}
