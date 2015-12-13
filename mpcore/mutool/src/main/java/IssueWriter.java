//import mutopia.mudb.*;

import java.io.File;
import java.io.Writer;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.HashMap;
import java.util.Map;

import freemarker.template.*;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * An object for writing issues to an output stream via template translation.
 */
class IssueWriter {

    private static final Configuration t_config;

    static {
        Logger log = LoggerFactory.getLogger(IssueWriter.class);
        t_config = new Configuration(Configuration.VERSION_2_3_23);
        try {
            t_config.setDefaultEncoding("UTF-8");
            t_config.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
            t_config.setDirectoryForTemplateLoading(new File("src/resources"));
        } catch (IOException ioe) {
            log.warn("At configuration: {}", ioe.getMessage());
            // ignore checked exception
        }
    }

    public IssueWriter() {
    }

    /**
     * IssueDetail contains data model details for template translation.
     * <p>
     * For the IssueWriter to perform against a template, a data model must
     * be provided in the form of a java Map. This class is used to collect
     * the necessary details from the database to build a data model for a
     * single piece.</p>
     */
    @SuppressWarnings("unchecked")
    class IssueDetail {
        private final Map root = new HashMap();

        public IssueDetail(int p_id, String p_title, String p_composer) {
            root.put("id", String.valueOf(p_id));
            root.put("title", p_title);
            root.put("composer", p_composer);
        }

        public void put(String key, String value) {
            root.put(key, value);
        }

        public String get(String key) {
            return (String) root.get(key);
        }

        public Map getRoot() {
            return root;
        }
    }

    /**
     * Write the given issue to an output stream.
     *
     * @param issue the issue detail to give to the template engine.
     */
    private void writeIssue(IssueDetail issue) {
        Logger log = LoggerFactory.getLogger(IssueWriter.class);
        try {
            Template t = t_config.getTemplate("issue.ftl");
            Writer out = new OutputStreamWriter(System.out);
            t.process(issue.getRoot(), out);
        } catch (TemplateNotFoundException | TemplateException tnf) {
            log.warn(tnf.getMessage());
            // ignore checked exception
        } catch (IOException e) {
            log.warn("During template writing: ", e.getMessage());
            // ignore checked exception
        }
    }

    public void viewIssues(Connection conn,
                           String viewName) throws SQLException {
        // from muPiece: title, composer, _id
        // from muRDFMap: rdfspec (with rdf filename stripped)
        Logger log = LoggerFactory.getLogger(IssueWriter.class);
        final String Q_BASE_DETAIL = "SELECT _id, title, composer FROM ";
        final String Q_RDF_DETAIL = "SELECT rdfspec from muRDFMap where piece_id=?";
        LinkedList<IssueDetail> issues = new LinkedList<>();
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(Q_BASE_DETAIL + viewName);
        while (rs.next()) {
            issues.add(new IssueDetail(rs.getInt(1),
                    rs.getString(2),
                    rs.getString(3)));
        }
        // Add the repo strings and write out the issue
        PreparedStatement pst = conn.prepareStatement(Q_RDF_DETAIL);
        for (IssueDetail issue : issues) {
            pst.clearParameters();
            pst.setString(1, issue.get("id"));
            rs = pst.executeQuery();
            while (rs.next()) {
                String rdfspec = rs.getString(1);
                issue.put("repo",
                        rdfspec.substring(0, rdfspec.lastIndexOf('/')));
                writeIssue(issue);
            }
        }
    }
}
