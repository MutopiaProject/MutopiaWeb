package mutopia.mudb.tables;

/** Define and populate the {@code Version} table. */
public class GitMarker extends DBTable {
    public GitMarker() {
        super("GitMarker");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muGitMarker (",
            "   _id INTEGER PRIMARY KEY,",
            "   commit_sha TEXT,",
            "   updated_on TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL",
            ") ;"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }

}

