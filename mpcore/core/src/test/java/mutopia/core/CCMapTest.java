package mutopia.core;

import org.junit.Test;
import static org.junit.Assert.*;
import mutopia.core.LicenseMap;

/* Test LicenseMap
 * @author glenl, @date 11/26/15 1:54 PM
 */

public class CCMapTest {
    @Test
    public void testMap() {
        LicenseMap lm = LicenseMap.getInstance();

        // Basic access to known existing copyright
        assertTrue(lm.hasCopyright("Public Domain"));

        // The following should not throw an exception
        assertFalse(lm.hasCopyright("Nobody"));
    }

    @Test
    public void testMapSameness() {
        LicenseMap lm = LicenseMap.getInstance();

        // Accessing this way, the copyright is rewritten each time so
        // they should not be the same. This is mostly for library
        // regression.
        String cc_a = lm.getCopyright("Public Domain");
        String cc_b = lm.getCopyright("Public Domain");
        assertNotSame(cc_a, cc_b);
    }

    @Test(expected=RuntimeException.class)
    public void testMapException() {
    	LicenseMap.getInstance().getCopyright("Goof Domain");
     }
}
