package mutopia.mudb;

import org.junit.*;
import java.util.Hashtable;
import java.util.Enumeration;

public class RdfTest {

    // A table of test values and expected results
    private final Hashtable<String,String> testgroup;

    // ctor just populates the hashtable for tests
    public RdfTest() {
        testgroup = new Hashtable<>();
        testgroup.put("ftp/MozartWA/KV387/k387/k387-lys/cello-i.ily",
                      "MozartWA/KV387/k387/k387.rdf");
        testgroup.put("MozartWA/KV387/k387/k387-lys/cello-i.ily",
                      "MozartWA/KV387/k387/k387.rdf");
        // may fail in the future if we ever check for valid composer
        testgroup.put("ftp/MoooozartWA/KV387/k387/k387-lys/cello-i.ily",
                      "MoooozartWA/KV387/k387/k387.rdf");
    }

    @Test
    public void testFromName() {
        Enumeration<String> candidates = testgroup.keys();
        while (candidates.hasMoreElements()) {
            String candidate = candidates.nextElement();
            MuRDFMap spec = new MuRDFMap(candidate);
            Assert.assertTrue(spec.toString().compareTo(testgroup.get(candidate)) == 0);
        }
    }

}
