package mutopia.mudb.tables;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.io.IOException;

/** Define and populate the {@code License} table. */
public class License extends DBTable {

    public License() {
        super("License");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muLicense (",
            "   _id INTEGER PRIMARY KEY AUTOINCREMENT,",
            "   name TEXT NOT NULL UNIQUE,",
            "   url TEXT",
            ") ;"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }
    
    @Override
    public boolean populateTable(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(License.class);
        boolean status = true;
        try {
            status = populateFromDDL(conn);
        }
        catch (IOException ioe) {
            log.warn(ioe.toString());
            status = false;
        }
        return status;
    }

}
