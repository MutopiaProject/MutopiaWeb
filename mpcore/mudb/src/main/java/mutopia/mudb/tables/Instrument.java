package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.io.IOException;
import mutopia.core.MutopiaMaps;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;


/** Define and populate the {@code Instrument} table. */
public class Instrument extends DBTable {

    public Instrument() {
        super("Instrument");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muInstrument (",
            "    instrument TEXT PRIMARY KEY,",
            "    in_mutopia INTEGER DEFAULT(0)",
            ") WITHOUT ROWID ;"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }

    @Override
    public boolean populateTable(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(Style.class);
        final String addInstrument =
            "INSERT INTO muInstrument (instrument,in_mutopia) values(?,1)";
        PreparedStatement ps = conn.prepareStatement(addInstrument);
        try {
            Map<String, String> instrmap = MutopiaMaps.readDataFile("instruments.dat");
            Set<String> instrset = instrmap.keySet();
            for (Iterator<String> iter = instrset.iterator(); iter.hasNext() ; ) {
                ps.clearParameters();
                ps.setString(1, iter.next());
                ps.execute();
            }
            populateFromDDL(conn);
        }
        catch (IOException | RuntimeException e) {
            log.warn("During datafile read: ", e.getMessage());
            return false;
        }
        return true;
    }

}
