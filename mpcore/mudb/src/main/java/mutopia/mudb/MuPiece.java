package mutopia.mudb;

import java.util.Hashtable;
import java.util.HashSet;
import java.net.URL;
import java.io.IOException;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.jena.rdf.model.SimpleSelector;
import org.apache.jena.rdf.model.StmtIterator;
import org.apache.jena.rdf.model.ModelFactory;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

/**
 * Represent a mutopia piece in the database.
 * 
 * <p>Pieces are currently constructed from the RDF files created during the
 * publication process. There are historical reasons for this but it
 * has the advantage of allowing a database to be updated separately
 * from the core publication process.</p>
 *
 * <p>Internally, this is simple a holder for a hashed set of
 * attributes that are loaded either from a {@code jena.Model} or
 * a {@code MuRDFMap} object. When the {@link MuPiece#save(Connection
 * conn)} is called the set of properties is translated into various
 * rows of database tables.
 * </p>
 */
public class MuPiece {
    /**
     * A regular expression pattern for deailing with Mutopia ID's
     */
    private static final Pattern idPattern;
    /**
     * A hash table to hold the known properties of the piece
     */
    private final Hashtable<String, String> props;
    /**
     * A set of valid keywords that make up a complete piece. These
     * are tags we expect to find in the RDF.
     */
    private static final HashSet<String> vocab = new HashSet<>();

    static {
        idPattern = Pattern.compile("Mutopia-([0-9/]+)-([0-9]+)");
        vocab.add("id");
        vocab.add("title");
        vocab.add("composer");        // composer
        vocab.add("style");
        vocab.add("for");             // raw_instrument
        vocab.add("licence");         // license_id
        vocab.add("maintainer");      // maintainer_id
        vocab.add("maintainerEmail");
        vocab.add("maintainerWeb");
        vocab.add("lilypondVersion"); // version_id
        vocab.add("opus");
        vocab.add("lyricist");
        vocab.add("date");            // date_composed
        vocab.add("source");
        vocab.add("moreInfo");
    }

    /**
     * Default constructor is private
     */
    private MuPiece() {
        props = new Hashtable<>();
    }

    /**
     * Predicate for key containment
     *
     * @param k the key to check for containment
     * @return True if this piece contains the give key.
     */
    protected boolean containsKey(String k) {
        return props.containsKey(k);
    }

    /**
     * Build the piece attributes
     *
     * @param k key
     * @param v value to associate with key
     * @return The value associated with the given key.
     */
    private String put(String k, String v) {
        return props.put(k, v);
    }

    /**
     * Accessor to key value in property map
     *
     * @param k key to lookup
     * @return The value associated with the key.
     */
    public String get(String k) {
        return props.get(k);
    }

    public static MuPiece fromLoadedModel(Model model) throws IOException {
        MuPiece p = new MuPiece();
        SimpleSelector ss = new SimpleSelector(null, null, (RDFNode) null);
        for (StmtIterator iter = model.listStatements(ss); iter.hasNext(); ) {
            org.apache.jena.rdf.model.Statement s = iter.nextStatement();
            String k = s.getPredicate().getLocalName();
            if (vocab.contains(k)) {
                p.put(k, s.getLiteral().getString());
            }
        }
        return p;
        /*
        Resource mu_piece = model.getResource(muNS + ".");
        for (StmtIterator i = mu_piece.listProperties(); i.hasNext();) {
            org.apache.jena.rdf.model.Statement s = i.next();
            if (vocab.contains(s.getPredicate().getLocalName())) {
                p.put(s.getPredicate().getLocalName(), s.getObject().toString());
            }
        }
        */
    }

    private final static String muNS = "http://www.mutopiaproject.org/piece-data/0.1/";

    /**
     * Class method to create a piece from an RDF file.
     * <p>
     * Uses a jena model to parse the RDF file, then iterates the
     * model to find matches to the elements needed for the piece.
     *
     * @param p_rdfmap the MuRDFMap on which to build this piece.
     * @return An MuPiece instance representing the given MuRDFMap.
     * @throws IOException if the given RDF spec fails to load.
     */
    public static MuPiece fromRDF(MuRDFMap p_rdfmap) throws IOException {
        MuPiece p = null;

        Model model = ModelFactory.createDefaultModel();
        try {
            URL url = p_rdfmap.getURL();
            model.read(url.openStream(), url.toString());
            p = fromLoadedModel(model);
        } finally {
            model.close();
        }
        return p;
    }


    /**
     * Insertion SQL for contributor
     */
    private static final String X_INSMAINT = "INSERT INTO muContributor"
            + " (name, email, url)"
            + " VALUES(?, ?, ?)";

    private static final String Q_CONTRIB =
            "SELECT _id FROM muContributor WHERE name=?";

    /**
     * Get the reference for the maintainer of this piece.
     * <p>
     * If not found, create an entry and return the new reference.</p>
     *
     * @param conn SQL connection to use for transactions.
     * @return The row id found for the maintainer.
     * @throws SQLException on any database error.
     */
    private int maintainerId(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(MuPiece.class);
        int mid;
        try {
            PreparedStatement pst = conn.prepareStatement(Q_CONTRIB);
            pst.setString(1, get("maintainer"));
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                mid = rs.getInt(1);
                return mid;
            }
        } catch (SQLException ex) {
            // ignore checked exception
            log.info("state={}, message={}", ex.getSQLState(), ex.getMessage());
        }

        // Here if there was an exception: assume that this maintainer
        // does not yet exist in our database.
        PreparedStatement pst =
                conn.prepareStatement(X_INSMAINT, Statement.RETURN_GENERATED_KEYS);
        pst.setString(1, get("maintainer"));
        pst.setString(2, get("maintainerEmail"));
        pst.setString(3, get("maintainerWeb"));
        pst.executeUpdate();
        ResultSet rs = pst.getGeneratedKeys();
        rs.next();
        mid = rs.getInt(1);

        log.info("Added maintainer {}, id = {}", get("maintainer"), mid);

        return mid;
    }


    /**
     * Get the license id for this piece.
     *
     * @param conn the SQL connection to use for transactions.
     * @return The row id for this license.
     * @throws SQLException on any database error.
     */
    private int licenseId(Connection conn) throws SQLException {
        String q_LICENSEID = "SELECT _id FROM muLicense WHERE name=?";
        PreparedStatement pst =
                conn.prepareStatement(q_LICENSEID, Statement.RETURN_GENERATED_KEYS);
        pst.setString(1, get("licence"));
        ResultSet rs = pst.executeQuery();
        rs.next();
        return rs.getInt(1);
    }


    /**
     * LilyPond version query
     */
    private static final String Q_VERSION =
            "SELECT _id FROM muVersion WHERE version=?";

    /**
     * Insertion SQL for LilyPond version
     */
    private static final String X_INSLPVERS = "INSERT INTO muVersion"
            + " (version, major, minor, edit)"
            + " VALUES(?,?,?,?)";

    /**
     * Return the reference of the LilyPond version for this piece. If
     * not found, an entry is created.
     *
     * @param conn the SQL connection to use for transactions.
     * @return The row id for this LilyPond version.
     * @throws SQLException on any database error.
     */
    private int lpVersionId(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(MuPiece.class);
        String lpversion = get("lilypondVersion");
        try {
            PreparedStatement vstmt = conn.prepareStatement(Q_VERSION);
            vstmt.setString(1, lpversion);
            ResultSet rs = vstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            // ignore checked exception
            log.info(ex.getMessage());
        }

        PreparedStatement pst =
                conn.prepareStatement(X_INSLPVERS, Statement.RETURN_GENERATED_KEYS);
        pst.setString(1, lpversion);
        String[] vv = lpversion.split("\\.", 3);
        pst.setString(2, vv[0]);
        pst.setString(3, vv[1]);
        if (vv.length > 2) {
            pst.setString(4, vv[2]);
        } else {
            pst.setString(4, "");
        }
        pst.executeUpdate();
        ResultSet rs = pst.getGeneratedKeys();
        if (rs.next()) {
            int vid = rs.getInt(1);
            log.info("Added LilyPond version {} _id={}", lpversion, vid);
            return vid;
        } else {
            log.warn("Failed to get generated id for muVersion");
            return -1;
        }
    }

    /**
     * Retrieve the Mutopia ID.
     * <p>
     * This is expected to be a string of the form,
     * <p>
     * <code>Mutopia-YYYY/MM/DD-digit</code><br>
     *
     * @return The parsed result as a 2-element String vector, v, such that,
     * <ul>
     * <li>v[0] is the publication date</li>
     * <li>v[1] is the Mutopia id</li>
     * </ul>
     * @throws MuException if the regex parse fails to match
     */
    public String[] getMuID() throws MuException {
        Logger log = LoggerFactory.getLogger(MuPiece.class);
        // Mutopia-2014/12/14-1994
        Matcher muID = idPattern.matcher(props.get("id"));
        if (!muID.matches()) {
            log.error("Failed format is {}", props.get("id"));
            throw new MuException("Bad Mutopia ID format");
        }
        String[] midparts = new String[2];
        midparts[0] = muID.group(1).replaceAll("/", "-");
        midparts[1] = muID.group(2);
        return midparts;
    }


    /**
     * Insertion SQL for a piece
     */
    private static final String X_INSPIECE =
            "INSERT OR REPLACE INTO muPiece ("
                    + "_id, title, composer, style, raw_instrument,"
                    + " license_id, maintainer_id, version_id, opus,"
                    + " lyricist, date_composed, date_published, source, moreinfo)"
                    + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    /**
     * Save this piece in the database.
     * <p>
     * Saves a new piece or updates if the piece exists in the
     * database. Every attempt attempt is made to create associated
     * database elements that are referenced by this piece if they
     * don't exist. For example, if version of LilyPond that is specified
     * by the LilyPondVersion tag does not exist in the database, a
     * table element is first created for that version.</p>
     *
     * @param conn the SQL connection to use for transactions.
     * @throws SQLException on any database error.
     * @throws MuException  if piece is not sufficiently populated with
     *                      the appropriate properties.
     */
    public void save(Connection conn) throws SQLException,
            MuException {
        Logger log = LoggerFactory.getLogger(MuPiece.class);

        // Pre-requisite: a complete set of properties
        if (props.size() != vocab.size()) {
            throw new MuException("Insufficient properties available to save piece");
        }

        String[] muid = getMuID();

        PreparedStatement pst = conn.prepareStatement(X_INSPIECE);
        pst.setString(1,  muid[1]);
        pst.setString(2,  props.get("title"));
        pst.setString(3,  props.get("composer"));
        pst.setString(4,  props.get("style"));
        pst.setString(5,  props.get("for"));
        pst.setInt(6,     licenseId(conn));
        pst.setInt(7,     maintainerId(conn));
        pst.setInt(8,     lpVersionId(conn));
        pst.setString(9,  props.get("opus"));
        pst.setString(10, props.get("lyricist"));
        pst.setString(11, props.get("date"));
        pst.setString(12, muid[0]);
        pst.setString(13, props.get("source"));
        pst.setString(14, props.get("moreInfo"));
        pst.executeUpdate();

        log.info("Saved piece {}", props.get("id"));
    }

}
