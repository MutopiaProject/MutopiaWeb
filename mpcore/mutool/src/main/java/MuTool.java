import mutopia.mudb.*;
import mutopia.core.RDFGuesser;

import java.io.IOException;
import java.util.HashSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.OptionException;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.FileSystems;
import java.util.Iterator;

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

    /**
     * Check the RDF guessing algorithm.
     * <p>When writing the {@link #mutopia.core.RDFGuesser() RDF guesser}
     * I noticed that there were several anomalies and I compensated
     * for them in the builder itself so I could continue to build the
     * database from scratch. This is simply a check against any
     * improvement in that file naming. The scan is requested without
     * the use of the anomalie fix and then each possible RDF file
     * name is checked against a good database.</p>
     * <p>
     * Caveat: It requires a good database. In previous DB iterations
     * these errant rows were corrected manually.</p>
     */
    private void rdfCheck(Connection conn) throws SQLException, IOException {
        Logger log = LoggerFactory.getLogger(MuTool.class);
        String mtop = MuConfig.getInstance().getProperty("mutopia.base");
        if (mtop == null) {
            System.out.println("Need MUTOPIA_BASE set to continue");
            return;
        }
        else {
            log.info("Using {} for search", mtop);
        }

        // Do a find from the top of our hierarchy, building possible
        // RDF file specs as we go.
        Path p = FileSystems.getDefault().getPath(mtop, "ftp");
        RDFGuesser sb = new RDFGuesser(p, false);
        Files.walkFileTree(p, sb);

        log.info("FTP archive scanned, {} anomalies were fixed.", sb.getAnomalies());

        // A prepared statement we can use throughout the iteration
        PreparedStatement pst =
            conn.prepareStatement("SELECT _id FROM muRDFMap WHERE rdfspec=?");

        // Iterate the rdf set, counting and printing out missed rdf guesses
        int misses = 0;
        int count = 0;
        for (Iterator<String> i = sb.iterator(); i.hasNext(); ) {
            count += 1;
            String rdfPath = i.next();
            pst.clearParameters();
            pst.setString(1, rdfPath);
            ResultSet rs = pst.executeQuery();
            if (!rs.next()) {
                misses += 1;
                System.out.println("  " + rdfPath);
            }
        }

        if (misses > 0) {
            System.out.println("You have " + misses + " out of " + count + " pieces mis-named.");
        }
    }


    /**
     *  MAIN
     */
    public static void main(String[] args) throws Exception {
        OptionParser parser = new OptionParser();
        parser.accepts("issues-for", "Create input for a GITHUB issue from a view")
            .withRequiredArg()
            .describedAs("view for input");
        parser.accepts("check-rdf",       "Check RDF scanner against the database");
        parser.accepts("list-rdf",        "List RDF files to scan for updates");
        parser.accepts("update-rdf",      "Process RDF files to scan for updates");
        parser.accepts("instruments",     "Process raw instruments into instrument-piece mappings");
        parser.accepts("list-properties", "List application properties");
        parser.accepts("help",            "this help message");

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
            if (options.has("check-rdf")) {
                mu.rdfCheck(conn);
            }
            else if (options.has("list-rdf")) {
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
