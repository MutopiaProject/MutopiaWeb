package mutopia.mudb.tables;

public class Version extends DBTable {

    public Version() {
        super("Version");
    }

    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muVersion (",
            "    _id INTEGER NOT NULL PRIMARY KEY,",
            "    version TEXT NOT NULL UNIQUE,",
            "    major INTEGER,",
            "    minor INTEGER,",
            "    edit TEXT",
            ") ;"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }

}
