import mutopia.mudb.*;

import java.io.IOException;
import java.util.HashSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.OptionException;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/** A utility application for the mudb library
 *
 */
class MuTool {
    /** Not meant to be publicly instantiated */
    private MuTool() {}

    /** Get a list of pending rdf files and print to stdout.
     * @param conn the SQLite connection object to use to construct the Marker object.
     * @throws SQLException on any database error.
     */
    private void listRDF(Connection conn) throws SQLException, IOException {
        Marker m = new Marker(conn);
        HashSet<MuRDFMap> rdf_set = m.rdfSince();
        for (MuRDFMap rdf : rdf_set) {
            System.out.println(rdf.getURL());
        }
    }


    /** Query to get all piece id's with missing instrument mappings. */
    private static final String Q_MISSING_INSTRUMENTS =
        "SELECT _id,raw_instrument FROM muPiece"
        + " WHERE _id NOT IN (SELECT piece_id FROM muPieceInstrument)";

    /** Process the muPiece.raw_instrument field if mapping is null
     * @param conn Connection to use for DB transactions
     * @throws SQLException for any database error
     */
    private void updateInstruments(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(MuTool.class);
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(Q_MISSING_INSTRUMENTS);
        while (rs.next()) {
            long piece_id = rs.getLong(1);
            String raw = rs.getString(2);
            MuInstrument instrument = new MuInstrument(raw);
            if (!instrument.saveWith(conn, piece_id)) {
                log.warn("Instrument: {} not saved for piece id={}", raw, piece_id);
            }
        }
    }

    /** Update the database with the latest changes in the archive.
     *
     * Find the latest git reference (using a Marker), then get a list
     * of RDF file references based on files changed since that git
     * reference. The list of RDF's is iterated and processed one by
     * one.
     *
     * @param conn Connection to use for DB transactions
     * @throws SQLException for any database error
     */
    private void updateByRDF(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(MuTool.class);
        Marker m = new Marker(conn);
        log.info("finding rdf references (git marker = {})", m);

        HashSet<MuRDFMap> rdf_set = m.rdfSince();
        if (rdf_set.isEmpty()) {
            log.info("No new rdf references found to process");
            return;
        }
        for (MuRDFMap rspec : rdf_set) {
            try {
                MuPiece piece = MuPiece.fromRDF(rspec);
                piece.save(conn);
                String[] muid = piece.getMuID();
                rspec.saveWith(conn, muid[1]);
            } catch (IOException ex) {
                log.warn("skipping {}", rspec);
            } catch (MuException mex) {
                log.warn("piece not saved - {}", mex.getMessage());
            }
        }
        if (m.setLastMark()) {
            m.save(conn);
        }
        else {
            log.warn("Unable to reset marker, still set to {}", m);
        }
    }


    //
    // MAIN - Setup application and run based on arguments
    //
    public static void main(String[] args) throws Exception {
        OptionParser parser = new OptionParser();
        parser.accepts("issues-for", "Create input for a GITHUB issue from a view")
            .withRequiredArg()
            .describedAs("view for input");
        parser.accepts("list-rdf", "List RDF files to scan for updates");
        parser.accepts("update-rdf", "Process RDF files to scan for updates");
        parser.accepts("instruments", "Process raw instruments into instrument-piece mappings");
        parser.accepts("list-properties", "List application properties");
        parser.accepts("help", "this help message");

        OptionSet options;
        try {
            options = parser.parse(args);
            if (options.has("help")) {
                parser.printHelpOn(System.out);
                return;
            }
        }
        catch (OptionException ex) {
            System.out.println(ex.getMessage());
            parser.printHelpOn(System.out);
            return;
        }

        final MuTool mu = new MuTool();
        if (options.has("list-properties")) {
            MuConfig.getInstance().dump();
            MuDB.getInstance().listProperties(System.out);
        }
        else {
            Connection conn = MuDB.getInstance().getConnection();
            if (options.has("list-rdf")) {
                mu.listRDF(conn);
            }
            else if (options.has("update-rdf")) {
                mu.updateByRDF(conn);
                conn.commit();
            }
            else if (options.has("instruments")) {
                mu.updateInstruments(conn);
                conn.commit();
            }
            else if (options.has("issues-for")) {
                String view = (String)options.valueOf("issues-for");
                IssueWriter issueWriter = new IssueWriter();
                issueWriter.viewIssues(conn, view);
            }
        }
    }
}
