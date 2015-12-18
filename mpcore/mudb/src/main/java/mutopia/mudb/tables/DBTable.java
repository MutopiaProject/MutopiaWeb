package mutopia.mudb.tables;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

/**
 * An abstract class to use as a base for all database tables.
 * Deriving classes must define the {@link #createTableSQL()} method.
 */
abstract public class DBTable {

    /** The name of the table */
    private String tableName;

    /** Abstract, not directly instantiable
     *  @param p_tableName the table name to construct
     */
    protected DBTable(String p_tableName) {
        tableName = p_tableName;
    }

    /** Access to table name.
     *  @return the name for this table
     */
    public String getTableName() {
        return tableName;
    }

    /** Child classes must generate the sql to create their table.
     *  @return A string containing the CREATE TABLE sql statement.
     */
    abstract public String createTableSQL() ;

    /** Populate the table.
     *  Many tables are updated during the population of other tables.
     *  For example, creating a row in the {@code Piece} table may create a
     *  new row in the {@code muVersion} and {@code muContributor}
     *  tables. These kinds of tables can choose to not implement this
     *  method.
     *
     *  @param conn the DB connection to use.
     *  @return true if the table was populated as defined.
     *  @throws SQLException on any database error.
     */
    public boolean populateTable(Connection conn) throws SQLException {
        return true;
    }

    /** Makes a table based on the childs SQL.
     *  @param conn the DB connection to use
     *  @throws SQLException on any database error.
     */
    public void makeTable(Connection conn) throws SQLException {
        Statement st = conn.createStatement();
        st.execute(createTableSQL());
    }

    /** Populate table from a file of sql insert statements in
     *  resources. This method will look for a file named
     *  {@code table-name + .sql} containing insert statements for the
     *  table. This is useful if you are loading something like a
     *  large symbol table.
     *
     *  @return true if populated successfully.
     *  @param conn the DB connection to use.
     *  @throws SQLException on any database error.
     *  @throws IOException on file read errors.
     */
    protected boolean populateFromDDL(Connection conn) throws SQLException,
                                                              IOException {
        InputStream is =
            getClass().getResourceAsStream("/" + getTableName() + ".sql");
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
