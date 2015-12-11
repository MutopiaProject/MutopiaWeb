package mutopia.mudb;

import java.net.URL;
import java.net.MalformedURLException;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

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

    /** Construct an MuRDFMap from a LilyPond filename.
     *  <p>An input file is scanned for various Mutopia-like bits from which to
     *  infer the location of an RDF file.</p>
     *
     * @param filename Input file from which to construct an RDF specification.
     * @throws MuException on invalid RDF specification in filename
     */
    MuRDFMap(String filename) throws MuException {
        final String LY = ".ly";
        final String ILY = ".ily";
        final String LYS = "-lys";
        final String FTP = "ftp";
        String[] partv = filename.split("/", 2);
        if (partv.length < 2 || !partv[0].equals(FTP) ) {
            throw new MuException("Invalid RDF spec - " + filename);
        }
        StringBuilder rdf = new StringBuilder();
        int lys = partv[1].indexOf(LYS);
        if (lys > 0) {
            rdf.append(partv[1].substring(0, lys));
        }
        else if (partv[1].endsWith(LY)) {
            rdf.append(partv[1].substring(0, partv[1].length() - LY.length()));
        }
        else if (partv[1].endsWith(ILY)) {
            rdf.append(partv[1].substring(0, partv[1].length() - ILY.length()));
        }
        else {
            throw new MuException("Invalid RDF spec - " + filename);
        }
        rdf.append(".rdf");
        rdfpart = rdf.toString();
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
     * @param conn the connection to use for database transactions.
     * @param muid the mutopia id as a string.
     * @throws SQLException on any database error.
     */
    public void saveWith(Connection conn,
                         String muid) throws SQLException {
        final String Q_RDFSPEC =
            "SELECT _id,rdfspec,piece_id FROM muRDFMap"
            + " WHERE piece_id=?";
        PreparedStatement pst = conn.prepareStatement(Q_RDFSPEC);
        pst.setString(1, muid);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            final String X_UPDRSPEC =
                "UPDATE muRDFMap SET rdfspec=? WHERE _id=?";
            long rowid = rs.getLong(1);
            String rspec = rs.getString(2);
            if (!rspec.equals(rdfpart)) {
                pst = conn.prepareStatement(X_UPDRSPEC);
                pst.setString(1, rdfpart);
                pst.setLong(2, rowid);
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
            pst.setString(2, muid);
            pst.execute();
        }
    }

    /**
     * Return a URL object that represents the location of the RDF
     * specified by the attributes of this class. The host is part of
     * the URL is determined by the property {@code mutopia.host}.
     * @return the assembled URL for this object
     * @throws MalformedURLException if the URL cannot be constructed
     */
    public URL getURL() throws MalformedURLException {
        String host = MuConfig.getInstance().getProperty("mutopia.host");
        return new URL("http", host, "/ftp/" + rdfpart);
    }


    /** Get the subject of this rdf.
     * (Usefulness is questionable.)
     * @return a string representing the subject.
     * @throws MalformedURLException if the URL can't be parsed.
     */
    public String getSubject() throws MalformedURLException {
        Path p = Paths.get(getURL().toString());
        return p.getParent().toString() + "/";
    }

}
