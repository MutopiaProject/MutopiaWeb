package mutopia.core;

import org.junit.Test;
import static org.junit.Assert.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

/**
 * Test comment filter
 * @author glenl Tue Dec  8 09:43:13 2015
 */
public class CommentFilterTest {
    private static final String BASIC = "src/test/resources/lp-strip-basic.ly";
    private static final String MULTI = "src/test/resources/lp-strip-multi.ly";
    private static final String MULTI_EXPECTED = "src/test/resources/multi-expected.ly";

    @Test
    public void canStripLineComments() {
        try {
            BufferedReader in =
                new BufferedReader(new CommentFilter(new FileReader(BASIC)));
            String line;
            while ((line = in.readLine()) != null) {
                assertEquals(-1, line.indexOf('%'));
            }
            in.close();
        }
        catch (IOException ioe) {
            fail(ioe.toString());
        }
    }

    @Test
    public void canStripMultipleLines() {
        List<String> stripped = new ArrayList<String>();
        try {
            BufferedReader in =
                new BufferedReader(new CommentFilter(new FileReader(MULTI)));

            String line;
            while ((line = in.readLine()) != null) {
                stripped.add(line);
            }
            in.close();
        }
        catch (IOException ioe) {
            fail(ioe.toString());
        }

		List<String> expected = loadFile(MULTI_EXPECTED);
		assertEquals(expected, stripped);
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
