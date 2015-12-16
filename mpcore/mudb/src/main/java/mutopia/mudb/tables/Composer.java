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

public class Composer extends DBTable {

    public Composer() {
        super("Composer");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muComposer (",
            "   composer TEXT PRIMARY KEY,",
            "   description TEXT NOT NULL",
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
        Logger log = LoggerFactory.getLogger(Composer.class);
        final String addComposer =
            "INSERT INTO muComposer (composer,description) values(?,?)";
        PreparedStatement ps = conn.prepareStatement(addComposer);
        try {
            Map<String, String> stylemap = MutopiaMaps.readDataFile("composers.dat");
            Set<Map.Entry<String,String>> entryset = stylemap.entrySet();
            for (Iterator<Map.Entry<String,String>> iter = entryset.iterator(); iter.hasNext() ; ) {
                Map.Entry<String,String> entry = iter.next();
                ps.clearParameters();
                ps.setString(1, entry.getKey());
                ps.setString(2, entry.getValue());
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
