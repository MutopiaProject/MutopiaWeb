package mutopia.mudb;

import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils; // capitalize
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

/**
 * MuInstrument provides support for parsing instrument tags in the header.
 *
 * <p>Mutopia defines a set of valid classes that are intended to be
 * specified by the piece and each piece can specify one or more
 * pieces. Thus, there is a many-to-many relationship between pieces
 * and instruments. In SQL, this is done using a separate table to map
 * between pieces and instruments.</p>
 *
 * <p>Instruments for a piece are stored in the database table
 * verbatim. This loose line of text defining the instrument(s) for
 * the piece can then be processed into individual instruments that
 * are considered known to Mutopia and hints can be used to determine
 * other characteristics of the music (duet, ensemble, symphony, etc.)</p>
 *
 * <p>There are a number of helpers in play here. Adjectives are
 * filtered out of the raw string via a {@link java.util.HashSet}.
 * This almost throws the baby out with the bathwater and will likely
 * change in the future.</p>
 *
 * <p>The instrument list is fairly small but users have been allowed to
 * be loose with plurals and languages so a translation table was
 * incorporated. This started out as a {@link java.util.HashMap} but grew to such an
 * extent that it seemed better to use an SQL table.</p>
 */
public class MuInstrument {
    /** Instrument list */
    private final List<String> instruments;

    /** A descriptive tag may be found at the beginning of the list */
    private final String tag;

    private static final Pattern tagpat = Pattern.compile("^(.*):(.*)");
    private static final Pattern decpat = Pattern.compile("[0-9]+");

    private static final HashSet<String> adjectives = new HashSet<>(42);

    static {
        // Adjectives
        adjectives.add("also");
        adjectives.add("band");
        adjectives.add("double");
        adjectives.add("dramatis");
        adjectives.add("duet");
        adjectives.add("english");
        adjectives.add("ensemble");
        adjectives.add("large");
        adjectives.add("soprano");
        adjectives.add("alti");
        adjectives.add("alto");
        adjectives.add("amore");
        adjectives.add("bass");
        adjectives.add("basse");
        adjectives.add("bassi");
        adjectives.add("basso");
        adjectives.add("brass");
        adjectives.add("castrato");
        adjectives.add("classical");
        adjectives.add("concert");
        adjectives.add("dolce");
        adjectives.add("duet");
        adjectives.add("flat");
        adjectives.add("french");
        adjectives.add("gamba");
        adjectives.add("grosso");
        adjectives.add("haute");
        adjectives.add("instruments");
        adjectives.add("mezzo");
        adjectives.add("mixed");
        adjectives.add("other");
        adjectives.add("personae");
        adjectives.add("quartet");
        adjectives.add("scottish");
        adjectives.add("solo");
        adjectives.add("string");
        adjectives.add("tenor");
        adjectives.add("trio");
        adjectives.add("three");
        adjectives.add("transcribed");
        adjectives.add("unfigured"); // bass, mmmph
        adjectives.add("women");
    }

    /**
     * Build the internal instrument list from the raw string.
     * <p>
     * Prepares the list for checking against the database
     * instruments (no db access until a save is requested).
     * <p>
     * The string is split on whitespace and commas, then the the
     * following words are filter.
     * <ul>
     * <li>words too short to be an instrument</li>
     * <li>words that contain all digits</li>
     * </ul>
     *
     * @param raw the list of instruments originally read from the
     *            piece's source.
     * @return a list of strings representing the instruments
     */
    private List<String> buildList(String raw) {
        ArrayList<String> instr = new ArrayList<>();

        // Use set operations to build list
        String[] rawv = raw.split("[\\W,]");
        for (String s : rawv) {
            if (s.length() >= 4
                    && !decpat.matcher(s).matches()
                    && !adjectives.contains(s)) {
                instr.add(s);
            }
        }
        return instr;
    }

    /**
     * Construct object using a raw instrument string.
     *
     * @param raw the raw string containing instruments to parse
     */
    public MuInstrument(String raw) {
        String raws = raw.toLowerCase();
        Matcher m = tagpat.matcher(raws);
        if (m.matches()) {
            tag = m.group(1).trim();
            // build list with remainder of string
            instruments = buildList(m.group(2).trim());
        } else {
            tag = null;
            instruments = buildList(raws);
        }
    }

    /**
     * Size of the instrument list.
     *
     * @return the number of elements in the instrument list
     */
    public int size() {
        return instruments.size();
    }

    /**
     * Access to the tag (may be null)
     *
     * @return the tag as a String
     */
    public String getTag() {
        return tag;
    }

    /**
     * Get an element of the instrument list
     *
     * @param index index of the element to retrieve from the list
     * @return the instrument at the given index
     */
    public String get(int index) {
        return instruments.get(index);
    }

    /**
     * Containment predicate
     *
     * @param s the instrument to check
     * @return true if the instrument list contains the given
     * instrument
     */
    public boolean contains(String s) {
        return instruments.contains(s);
    }

    public List<String> getTranslation(Connection conn) throws SQLException {
        List<String> xlate = new ArrayList<String>(12);
        for (String instr : instruments) {
            xlate.add(translateRaw(conn, instr));
        }
        return xlate;
    }

    /**
     * Translate a raw instrument into a "mutopia-approved" instrument.
     *
     * <p>This allows handling of plurals ("Trumpets" to "Trumpet"),
     * foreign languages ("Violon" to "Violin"), and nicknames and
     * other forms ("Hautboy" to "Oboe").</p>
     *
     * @param conn      - the SQL connection to use for table lookup
     * @param candidate - the candidate instrument to translate
     * @return a string translation or the original string on no
     * match.
     */
    private String translateRaw(Connection conn,
                                String candidate) {
        final String Q_XLATE_INSTR =
            "SELECT instrument FROM muRawInstrumentMap WHERE raw_instrument=?";
        try {
            PreparedStatement pst = conn.prepareStatement(Q_XLATE_INSTR);
            pst.setString(1, candidate);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                candidate = rs.getString(1);
            }
        } catch (SQLException e) {
            // ignore caught exception
        }
        return StringUtils.capitalize(candidate);
    }

    /**
     * Save an instrument list, associating the instruments with a
     * piece id.
     * <p>
     * This object just knows about an instrument string and has the
     * ability to parse that string into a list of instruments. Until
     * this call, this list of instruments is not associated with any piece.
     *
     * @param conn     the connection to use for database activity
     * @param piece_id the Mutopia integer id to associate with the
     *                 instruments
     * @return true if instruments are associated successfully with
     * the piece.
     * @throws SQLException on database error
     */
    public boolean saveWith(Connection conn,
                            long piece_id) throws SQLException {
        Logger log = LoggerFactory.getLogger(MuInstrument.class);
        final String X_INSERT_P_I =
            "INSERT OR IGNORE INTO muPieceInstrument" +
            " (piece_id, instrument) VALUES(?,?)";
        if (piece_id < 1) {
            log.warn("Illegal piece id ({}) while saving instrument", piece_id);
            return false;
        }
        int count = 0;
        PreparedStatement pst = conn.prepareStatement(X_INSERT_P_I);
        for (String instrument : instruments) {
            String candidate = "";
            try {
                candidate = translateRaw(conn, instrument);
                pst.setLong(1, piece_id);
                pst.setString(2, candidate);
                pst.execute();
                count = count + 1;
            } catch (SQLException e) {
                log.warn(e.getMessage());
                log.info("Manual fix: INSERT INTO MuRawInstrumentMap values({}, INSTRUMENT)", candidate);
            }
        }
        return (count > 0);
    }

}
