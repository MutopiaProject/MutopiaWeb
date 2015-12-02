package mutopia.core;

import org.junit.Test;
import org.junit.Rule;
import static org.junit.Assert.*;
import org.junit.rules.ExpectedException;

import mutopia.core.MutopiaMaps;
import java.io.*;
import java.util.*;

import java.nio.file.FileSystems;
import java.nio.file.FileSystem;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;


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

        // Style "maps" are really hashes, so we don't care about values of styles.
        // We mostly care that the key exists:
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

    @Rule
    public ExpectedException thrown = ExpectedException.none();

    @Test
    public void throwsOnBadFilename() throws IOException
    {
        Path p = FileSystems.getDefault().getPath("src", "nofile.dat");
        thrown.expect(IOException.class);
        Map<String, String> m = MutopiaMaps.readPairFile(p);
    }

    @Test(expected=RuntimeException.class)
    public void throwsOnBadDataInput() {
        Path p = FileSystems.getDefault().getPath("src", "test", "resources", "badpairs.dat");
        try {
            Map<String, String> m = MutopiaMaps.readPairFile(p);
        }
        catch (IOException ioe) {
            fail("Unexpected IO exception" + ioe.getMessage());
        }
    }
}
