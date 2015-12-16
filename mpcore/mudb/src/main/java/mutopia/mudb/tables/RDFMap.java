package mutopia.mudb.tables;
import mutopia.mudb.MuConfig;
import mutopia.core.RDFGuesser;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.FileSystems;
import java.util.Iterator;

/** Define and populate the {@code RDFMap} table. */
public class RDFMap extends DBTable {

    public RDFMap() {
        super("RDFMap");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muRDFMap (",
            "   _id INTEGER PRIMARY KEY AUTOINCREMENT,",
            "   rdfspec TEXT,",
            "   piece_id INTEGER REFERENCES muPiece(_id) DEFAULT NULL",
            ") ;"
        } ;
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }

    @Override
    public boolean populateTable(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(RDFMap.class);

        String mtop = MuConfig.getInstance().getProperty("mutopia.base");
        if (mtop == null) {
            log.warn("Need MUTOPIA_BASE set to populate RDFMap");
            return false;
        }
        else {
            log.info("Using {} for building RDFMap", mtop);
        }

        // Do a find from the top of our hierarchy, building possible
        // RDF file specs as we go.
        Path p = FileSystems.getDefault().getPath(mtop, "ftp");
        RDFGuesser sb = new RDFGuesser(p, false);
        try {
            Files.walkFileTree(p, sb);
        }
        catch (IOException ioe) {
            log.warn("While walking {}: {}", p.toString(), ioe.getMessage());
            return false;
        }

        int count = 0;
        PreparedStatement pst =
            conn.prepareStatement("INSERT INTO muRDFMap (rdfspec) VALUES(?)");
        for (Iterator<String> i = sb.iterator(); i.hasNext(); ) {
            count += 1;
            String rdfPath = i.next();
            pst.clearParameters();
            pst.setString(1, rdfPath);
            pst.execute();
        }

        return true;
    }

}
