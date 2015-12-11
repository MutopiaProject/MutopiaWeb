package mutopia.core;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.Test;
import org.junit.Ignore;

public class MutopiaRDFTest {
	private static final String OUTPUT_RDF_NAME = "src/test/resources/testOutput.rdf";
	private static final String INPUT_RDF_NAME = "src/test/resources/testInput.rdf";
	
	private MutopiaPiece piece = buildPiece();
	
	@Ignore("fails if lilypond compiler version mismatch") @Test
	public void testOutputRDF() throws IOException {
		File file = new File(OUTPUT_RDF_NAME);
		file.createNewFile();
		BufferedWriter wr = new BufferedWriter(new FileWriter(file));
		
		try {
			MutopiaRDF.outputRDF(piece, wr);
		} catch (IOException e) {
			fail(e.toString());
		}
		
		wr.close();
		
		List<String> theseLines = loadFile(OUTPUT_RDF_NAME);
		List<String> testLines = loadFile(INPUT_RDF_NAME);
        Files.delete(file.toPath());
		assertEquals(testLines, theseLines);
	}

	@Test
	public void testInputRDF() {
		MutopiaPiece thisPiece = MutopiaRDF.inputRDF(INPUT_RDF_NAME);
		assertEquals(piece.getTitle(), thisPiece.getTitle());
		assertEquals(piece.getComposer(), thisPiece.getComposer());
		assertEquals(piece.getOpus(), thisPiece.getOpus());
		assertEquals(piece.getInstrument(), thisPiece.getInstrument());
		assertEquals(piece.getStyle(), thisPiece.getStyle());
	}
	
	private MutopiaPiece buildPiece() {
		String lilyPondExe = System.getenv("LILYPOND_BIN");
		if (lilyPondExe == null) {
			lilyPondExe = "lilypond";
		}
		
		MutopiaPiece piece = new MutopiaPiece("djinns.ly");
		try {
			piece.deriveCompileStuff(lilyPondExe);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		piece.setTitle("The Foo Bird Sings");
		piece.setComposer("ChopinFF");
		piece.setOpus("O13");
		piece.setInstrument("Piano");
		piece.setStyle("Romantic");
		piece.setSource("A little bird told me");
		piece.setFooter("Footer");
		
		return piece;
	}

	private List<String> loadFile(String fileName) {
		List<String> lines = new ArrayList<>();
		try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
			String line;
			while ((line = br.readLine()) != null) {
				lines.add(line);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} 
		
		return lines;
	}
}
