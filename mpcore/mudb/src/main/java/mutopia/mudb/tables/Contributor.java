package mutopia.mudb.tables;

/** Define and populate the {@code Contributor} table. */
public class Contributor extends DBTable {

    public Contributor() {
        super("Contributor");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muContributor (",
            "    _id INTEGER PRIMARY KEY AUTOINCREMENT,",
            "    name TEXT NOT NULL UNIQUE,",
            "    email TEXT,",
            "    url TEXT",
            ") ;"
        };

        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }

}
