package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.io.IOException;
import mutopia.core.MutopiaMaps;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/** Define and populate the {@code Style} table. */
public class Style extends DBTable {

    public Style() {
        super("Style");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muStyle (",
            "   style TEXT PRIMARY KEY,",
            "   in_mutopia INTEGER DEFAULT(0)",
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
        final String addStyle =
            "INSERT INTO muStyle (style,in_mutopia) values(?,1)";
        PreparedStatement ps = conn.prepareStatement(addStyle);
        try {
            Map<String, String> stylemap = MutopiaMaps.readDataFile("styles.dat");
            Set<String> styleset = stylemap.keySet();
            for (Iterator<String> iter = styleset.iterator(); iter.hasNext() ; ) {
                ps.clearParameters();
                ps.setString(1, iter.next());
                ps.execute();
            }
        }
        catch (IOException | RuntimeException e) {
            log.warn("During datafile read: ", e.getMessage());
            return false;
        }
        return true;
    }

}
