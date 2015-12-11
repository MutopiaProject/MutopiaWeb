package mutopia.mudb;

import org.junit.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.List;

public class InstrumentTest {

    @Test
    public void testSingle() {
        MuInstrument guitar = new MuInstrument("Guitar");
        Assert.assertTrue(guitar.size() == 1);
        Assert.assertEquals("one instrument", "guitar", guitar.get(0));

        guitar = new MuInstrument("Classical guitar");
        Assert.assertTrue(guitar.size() == 1);
        Assert.assertEquals("one instrument with adjective", "guitar", guitar.get(0));
    }

    @Test
    public void canCountInstruments() {
        MuInstrument trio = new MuInstrument("piano, guitar, violin");
        Assert.assertTrue("3 good instruments", trio.size() == 3);

        trio = new MuInstrument("piano, 2 guitars");
        Assert.assertTrue("2 good, one bad", trio.size() == 2);
    }

    @Test
    public void canTranslate() throws SQLException {
        Connection conn = MuDB.getInstance().getConnection();
        MuInstrument xlate = new MuInstrument("piano, guitare, violon");
        List<String> translated = xlate.getTranslation(conn);
        Assert.assertEquals(3, translated.size());
        Assert.assertTrue("guitare ==> Guitar", translated.contains("Guitar"));
        Assert.assertTrue("violon ==> Violin", translated.contains("Violin"));
        Assert.assertFalse("artifacts", translated.contains("guitare"));
    }

    @Test
    public void findsTaggedLines() {
        MuInstrument instr = new MuInstrument("duet: guitar, harmonica");
        Assert.assertEquals("tagged with 2 instruments", "duet", instr.getTag());
        Assert.assertTrue("tagged instrument", instr.contains("harmonica"));
    }

    @Test
    public void unknownAdjective() throws SQLException {
        // Doesn't know what a "curmudgeon" is so it stores it as a
        // possible instrument that needs translation.
        MuInstrument instr = new MuInstrument("Curmudgeon harmonica");
        Assert.assertTrue(instr.size() == 2);

        // Translations will still be the same size
        Connection conn = MuDB.getInstance().getConnection();
        List<String> translated = instr.getTranslation(conn);
        Assert.assertEquals(2, translated.size());

        // Query for bad instrument shouldn't fail
        Statement stmt = conn.createStatement();
        ResultSet rs =
            stmt.executeQuery("SELECT COUNT(*) FROM muInstrument" +
                              " WHERE instrument=\"Curmudgeon\"");
        if (rs.next()) {
            Assert.assertEquals("unknown instrument", 0, rs.getInt(1));
        }
    }

}
