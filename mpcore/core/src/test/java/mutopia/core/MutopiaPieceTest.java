package mutopia.core;

import static org.junit.Assert.*;

import java.beans.PropertyDescriptor;
import java.io.File;
import java.io.IOException;
import java.util.Map;

import org.junit.Test;
import org.junit.BeforeClass;

public class MutopiaPieceTest {
	private static final String VERSION_RE = "^\\d+\\.\\d+\\.\\d+$";

    @BeforeClass
    public static void initialize() {
        if (MutopiaMaps.composerMap == null) {
            fail("Is MUTOPIA_BASE in your environment?");
        }
    }

	@Test
	public void testMutopiaPiece() {
		MutopiaPiece mp = new MutopiaPiece("foo.ly");
		Map<String, PropertyDescriptor> piecePropertyMap = mp.getPiecePropertyMap();
		
		// Pick a random property to test
		assertTrue(piecePropertyMap.containsKey("composer"));
	}

	@Test
	public void testPopulateField() {
		MutopiaPiece mp = new MutopiaPiece("foo.ly");
		mp.populateField("mutopiacomposer", "BachJS");
		assertEquals("BachJS", mp.getComposer());
		mp.populateField("composer", "ChopinFF");
		
		// A "composer" should not overwrite a "mutopiacomposer"
		assertEquals("BachJS", mp.getComposer());
	}

	@Test
	public void testDeriveCompileStuff() {
		MutopiaPiece mp = doDeriveCompilerStuff();
		
		assertEquals("djinns", mp.getFilenameBase());
		assertFalse(mp.getMultipleLyFiles());
		assertTrue(mp.getMultipleMidFiles());
		assertFalse(mp.getMultiplePdfFiles());
		assertTrue(mp.getLilyVersion().matches(VERSION_RE));
	}

	@Test
	public void testGetLilyVersionString() {
		String lilyPondExe = System.getenv("LILYPOND_BIN");
		
		if (lilyPondExe == null) {
			fail("Can't find LILYPOND_BIN");
		}
		
		String version = "not found";
		try {
			version = MutopiaPiece.getLilyVersion(lilyPondExe);
		} catch (IOException e) {
			fail(e.getMessage());
		}
		
		assertTrue(version.matches(VERSION_RE)); 
	}

	@Test
	public void testCheckFieldConsistency() {
		MutopiaPiece mp = new MutopiaPiece("foo.ly");
		mp.populateField("mutopiacomposer", "ChopinFF");
		mp.populateField("title", "The Foo Bird Sings");
		mp.populateField("instrument", "Piano");
		mp.populateField("style", "Romantic");
		mp.populateField("source", "A little bird told me");
		
		// Haven't set license yet, so fail
		assertFalse("Environment is probably incorrect", 
                    mp.checkFieldConsistency(false));
		
		mp.populateField("license", "Public Domain");
		assertTrue(mp.checkFieldConsistency(false));
	}

	@Test
	public void testCheckCompileConsistency() {
		MutopiaPiece mp = doDeriveCompilerStuff();
		assertTrue(mp.checkCompileConsistency());
	}
	
	private MutopiaPiece doDeriveCompilerStuff() {
		char fs = File.separatorChar;
		MutopiaPiece mp = new MutopiaPiece("src" + fs + "test" + fs + "resources" + fs + "djinns.ly");
		String lilyPondExe = System.getenv("LILYPOND_BIN");
		
		if (lilyPondExe == null) {
			fail("Can't find LILYPOND_BIN");
		}
		
		try {
			mp.deriveCompileStuff(lilyPondExe);
		} catch (IOException e) {
			fail(e.getMessage());
		}
		
		return mp;
	}

}
