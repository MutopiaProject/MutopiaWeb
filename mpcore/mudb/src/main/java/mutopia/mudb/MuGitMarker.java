package mutopia.mudb;

import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.List;
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.HashSet;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.lang.ProcessBuilder;
import java.lang.Process;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.nio.file.Path;
import java.nio.file.FileSystems;

/**
 * Mark a time in git history.
 *
 * <p>A Marker stores a value notable to git commit (SHA) that can
 * represent a mark in history within the repository.</p>
 *
 * <p>In our world, we only care about a single mark --- the commit of
 * the last time the git log was scanned for the purpose of updating
 * pieces in the database. In addition, a timestamp is set that
 * denotes the time this mark was set. The process works something
 * like this,</p>
 * <ul>
 *   <li>The {@code Marker} that was last used is read from the database
 *       during construction.</li>
 *   <li>This marker object is then used as a base to find what has
 *       changed in the git history since this mark.</li>
 *   <li>Changed files are used to determine changes in pieces and,
 *       consequently, updates to {@code muPiece} and other tables.</li>
 *   <li>The last git SHA is then stored for later use.</li>
 * </ul>
 *
 * <p>Since this is accomplished by looking in the git archive history
 * the assumption is that,
 * <ul>
 *  <li>Your current working directory is in the git workspace
 *      containing the archive.</li>
 *  <li>You are in the correct branch, usually {@code master}
 * </ul>
 */
public class MuGitMarker {
    /** Git commit SHA for this marker */
    private String commit_sha;

    private static final Pattern SHAPattern = Pattern.compile("^([0-9a-f]{7})\\s.*$");

    /**
     * Construct an empty marker
     *
     * @param conn the Connection to the database
     * @throws SQLException on database errors
     */
    public MuGitMarker(Connection conn) throws SQLException {
        String q_RESOLVE = "SELECT commit_sha FROM muGitMarker WHERE _id=1";
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(q_RESOLVE);
        if (rs.next()) {
            commit_sha = rs.getString(1);
        }
    }

    /**
     * Return a string representation of the marker
     */
    public String toString() {
        return commit_sha;
    }

    /**
     * Set the mark's attributes to prepare for a save.
     *
     * @param p_mark the git commit SHA string
     */
    public void setMark(String p_mark) {
        commit_sha = p_mark;
    }

    /**
     * Save the current mark
     *
     * @param conn the connection to use for the transaction
     * @throws SQLException on any database error
     */
    public void save(Connection conn) throws SQLException {
        String x_UPDATESHA = "INSERT OR REPLACE INTO muGitMarker"
                + " (_id,commit_sha) VALUES(1, ?)";
        PreparedStatement pst = conn.prepareStatement(x_UPDATESHA);
        pst.setString(1, commit_sha);
        pst.executeUpdate();
    }


    Path getWorkspace() {
        String gitmaster = MuConfig.getInstance().getProperty("mutopia.base");
        return FileSystems.getDefault().getPath(gitmaster, "ftp");
    }


    /**
     * Set a marker representing the latest commit in the git history
     * of our repository.
     *
     * @return true if the history was read and the object updated
     */
    public boolean setLastMark() {
        Path top = getWorkspace();

        List<String> commands = new ArrayList<>();
        commands.add("git");
        commands.add("log");
        commands.add("--oneline");
        commands.add("--max-count=1"); // only want latest entry
        ProcessBuilder pb = new ProcessBuilder(commands);
        try {
            pb.directory(top.toFile());
            final Process process = pb.start();
            BufferedReader br =
                    new BufferedReader(new InputStreamReader(process.getInputStream()));

            String line = br.readLine();
            if (line != null) {
                Matcher m = SHAPattern.matcher(line);
                if (m.matches()) {
                    setMark(m.group(1));
                }
            }
            // else marker is probably already at last mark
            return true;
        } catch (IOException ex) {
            // ignore checked exception
        }
        return false;
    }


    /**
     * Find the files changed since the commit represented by
     * this marker.
     *
     * @return list of String filenames
     * @throws IOException on stream processing errors
     */
    private List<String> changedFiles() throws IOException {
        Path workspace = getWorkspace();
        LinkedList<String> changes = new LinkedList<>();
        List<String> commands = new ArrayList<>();
        commands.add("git");
        commands.add("diff-tree");
        commands.add("--no-commit-id");
        commands.add("--name-only");
        commands.add("-r");
        commands.add(this.commit_sha + "..");

        ProcessBuilder pb = new ProcessBuilder(commands);
        pb.directory(workspace.toFile());
        final Process process = pb.start();
        BufferedReader br =
                new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = br.readLine()) != null) {
            changes.add(line);
        }

        return changes;
    }


    /**
     * Create a set of MuRDFMap's affected since the last mark
     *
     * @return a set of MuRDFMap instances, may be null if an io
     *         exception occurred while getting the list of changed
     *         files.
     */
    public HashSet<MuRDFMap> rdfSince() {
        HashSet<MuRDFMap> rdf_set = new HashSet<>();
        try {
            List<String> flist = changedFiles();
            for (String aFlist : flist) {
                if (aFlist.endsWith(".ly") || aFlist.endsWith(".ily")) {
                    rdf_set.add(new MuRDFMap(aFlist));
                }
            }
        }
        catch (IOException ex) {
            // ignore checked exception
        }
        return rdf_set;
    }

}
