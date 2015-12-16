package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

abstract public class DBTable {

    /** The name of the table */
    private String tableName;

    /** Abstract, not directly instantiable */
    protected DBTable(String p_tableName) {
        tableName = p_tableName;
    }

    /** Access to table name. */
    public String getTableName() {
        return tableName;
    }

    /** Child classes must generate the sql to create their table.
     *  @returns A string containing the CREATE TABLE sql statement.
     */
    abstract public String createTableSQL() ;

    public boolean populateTable(Connection conn) throws SQLException {
        return true;
    }

    /** Makes a table based on the childs SQL.
     *  @throws SQLException on any database error.
     */
    public void makeTable(Connection conn) throws SQLException {
        Statement st = conn.createStatement();
        st.execute(createTableSQL());
    }

    protected boolean populateFromDDL(Connection conn) throws SQLException,
                                                              IOException {
        InputStream is =
            getClass().getResourceAsStream("/" + getTableName() + ".ddl");
        BufferedReader sql_in =
            new BufferedReader(new InputStreamReader(is));

        Statement st = conn.createStatement();
        String line;
        while ((line = sql_in.readLine()) != null) {
            st.execute(line);
        }
        sql_in.close();

        return true;
    }

}
