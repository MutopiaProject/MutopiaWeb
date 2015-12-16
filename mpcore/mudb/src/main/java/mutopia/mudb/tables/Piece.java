package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/** Define and populate the {@code Piece} table. */
public class Piece extends DBTable {

    public Piece() {
        super("Piece");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muPiece (",
            "    _id INTEGER PRIMARY KEY,",
            "    title TEXT NOT NULL,",
            "    composer TEXT REFERENCES muComposer(composer),",
            "    style TEXT REFERENCES muStyle(style),",
            "    raw_instrument TEXT,",
            "    license_id INTEGER REFERENCES muLicense(_id),",
            "    maintainer_id INTEGER REFERENCES muContributor(_id),",
            "    version_id INTEGER REFERENCES muVersion (_id),",
            "    opus TEXT,",
            "    lyricist TEXT,",
            "    date_composed TEXT,",
            "    date_published TEXT,",
            "    source TEXT,",
            "    moreinfo TEXT",
            ");"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }


    @Override
    public boolean populateTable(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(Piece.class);
        log.info("Not yet implemented");
        return true;
    }

}
