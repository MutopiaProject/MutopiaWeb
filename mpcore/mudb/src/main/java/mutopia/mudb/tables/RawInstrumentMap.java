package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.file.FileSystems;
import java.nio.charset.StandardCharsets;
import java.io.BufferedReader;
import java.io.IOException;

/** Define and populate the {@code RawInstrumentMap} table. */
public class RawInstrumentMap extends DBTable {

    public RawInstrumentMap() {
        super("RawInstrumentMap");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muRawInstrumentMap (",
            "    raw_instrument TEXT PRIMARY KEY,",
            "    instrument TEXT REFERENCES muInstrument(instrument)",
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
        Logger log = LoggerFactory.getLogger(RawInstrumentMap.class);
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
