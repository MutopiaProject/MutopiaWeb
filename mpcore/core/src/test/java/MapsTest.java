import org.junit.Test;
import static org.junit.Assert.*;
import mutopia.core.MutopiaMaps;
import java.util.Map;


/* Test LicenseMap
 * @author glenl
 */

public class MapsTest {
    @Test
    public void canLoadMaps() {

        // Some tests require a priori knowledge
        assertTrue(MutopiaMaps.composerMap.get("AguadoD").indexOf("Aguado") > 0);
        assertFalse(MutopiaMaps.composerMap.containsKey("Aguado"));

        // The composer and style maps are just paired lines so
        // getting one from the end of the file is a reasonable test.
        assertTrue(MutopiaMaps.composerMap.get("ZanoniM").indexOf("Zanoni") > 0);

        // Style "maps" are really hashes, so we don't care about this test:
        // assertTrue("Classical".equals(MutopiaMaps.styleMap["Classical"]));
        // We care more about this,
        assertTrue(MutopiaMaps.styleMap.containsKey("Classical"));

        // At a minimum all license maps should have this key.
        assertTrue(MutopiaMaps.licenceMapVOld.containsKey("Public Domain"));
        assertTrue(MutopiaMaps.licenceMapOld.containsKey("Public Domain"));
        assertTrue(MutopiaMaps.licenceMapNew.containsKey("Public Domain"));
    }

    @Test
    public void lastKeyTest() {
        // Lookup final keys in both maps
        assertEquals("Traditional", MutopiaMaps.composerMap.get("Traditional"));
        assertEquals("Technique", MutopiaMaps.styleMap.get("Technique"));
    }
}
