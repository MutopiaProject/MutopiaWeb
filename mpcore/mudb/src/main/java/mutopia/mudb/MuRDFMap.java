package mutopia.mudb;

import java.net.URL;
import java.net.MalformedURLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * For locating RDF files on the server.
 * <p>
 * An MuRDFMap associates an address of an RDF file to a particular
 * Mutopia piece. Typically, the address is inferred from the local
 * archive hierarchy. The constructor is designed such that a path to
 * a lilypond file in the archive can be supplied.
 */
public class MuRDFMap {
    private String rdfpart;

    /** Basic constructor */
    public MuRDFMap(String p_rdfpart) {
        rdfpart = this.resolveToRDF(Paths.get(p_rdfpart)).toString();
    }

    /** Resolve the RDF file name.
     *  Given a path to a LilyPond file, determine and return the RDF
     *  file name. This uses a similar algorithm to {@link
     *  #core.RDFGuesser} without the benefit of the tree walk.
     *  @param lypath The path of a LilyPond file.
     *  @return String path relative to the top of the ftp archive.
     */
    Path resolveToRDF(Path lypath) {
        if (lypath.startsWith("ftp")) {
            lypath = lypath.subpath(1, lypath.getNameCount());
        }

        String n_string = lypath.getFileName().toString();
        if (n_string.endsWith(".rdf")) {
            // All done if the caller provided us with the rdf name
            return lypath;
        }

        if (n_string.endsWith(".ly") || n_string.endsWith(".ily")) {
            // We want the parent of the source container
            lypath = lypath.getParent();
            // If the parent container is an LYS folder, we need its parent.
            n_string = lypath.getFileName().toString();
            if (n_string.endsWith("-lys")) {
                lypath = lypath.getParent();
            }
        }
        // else the caller passed us a folder.

        return lypath.resolve(lypath.getFileName().toString() + ".rdf");
    }


    @Override
    /** Output a string representation of this object */
    public String toString() {
        return rdfpart;
    }

    @Override
    /** Override hashCode to properly support a HashSet */
    public int hashCode() {
        return rdfpart.hashCode();
    }

    @Override
    /** Override equals to properly support a HashSet */
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj == null) { return false; }
        if (getClass() != obj.getClass()) { return false; }
        MuRDFMap other = (MuRDFMap) obj;

        return rdfpart.equals(other.rdfpart);
    }


    /** Save an rdfref, associating it with a mutopia id.
     * @param conn     the connection to use for database transactions.
     * @param piece_id the mutopia id as a string.
     * @throws SQLException on any database error.
     */
    public void saveWith(Connection conn,
                         MuPiece piece) throws SQLException
    {
        Integer id = new Integer(piece.get("id"));
        int piece_id = id.intValue();

        final String Q_RDFSPEC =
            "SELECT rdfspec,piece_id FROM muRDFMap"
            + " WHERE rdfspec=?";
        PreparedStatement pst = conn.prepareStatement(Q_RDFSPEC);
        pst.setString(1, rdfpart);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            String rspec = rs.getString(1);
            int pid = rs.getInt(2);
            if (pid != piece_id) {
                final String X_UPDRSPEC =
                    "UPDATE muRDFMap SET piece_id=? WHERE rdfspec=?";
                pst = conn.prepareStatement(X_UPDRSPEC);
                pst.setInt(1, piece_id);
                pst.setString(2, rdfpart.toString());
                pst.execute();
            }
            // else no update necessary
        }
        else {
            // piece representation doesn't exist
            final String X_INSRSPEC =
                "INSERT INTO muRDFMap (rdfspec, piece_id) VALUES (?, ?)";
            pst = conn.prepareStatement(X_INSRSPEC);
            pst.setString(1, rdfpart);
            pst.setInt(2, piece_id);
            pst.execute();
        }
    }

    /**
     * Return a URL object that represents the location of the RDF
     * specified by the attributes of this class. The host is part of
     * the URL and is determined by the property {@code mutopia.host}.
     * @return the assembled URL for this object
     * @throws MalformedURLException if the URL cannot be constructed
     */
    public URL getURL() throws MalformedURLException {
        String host = MuConfig.getInstance().getProperty("mutopia.host");
        return new URL("http", host, "/ftp/" + rdfpart);
    }

}
