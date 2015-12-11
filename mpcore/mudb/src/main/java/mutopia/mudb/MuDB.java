package mutopia.mudb;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DatabaseMetaData;
import java.io.OutputStream;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;

/**
 * Common DB utilities for Mutopia applications.
 */
public class MuDB {

    /** Singleton, not intended to be constructed directly */
    private MuDB() { }

    public Connection getConnection() throws SQLException {
        String path = MuConfig.getInstance().getProperty("mutopia.dbpath");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + path);
        conn.setAutoCommit(false);
        return conn;
    }


    /** List properties of database on an output stream
     *  @param outs the output stream
     *  @throws SQLException on any database error
     *  @throws IOException on output errors to stream
     */
    public void listProperties(OutputStream outs) throws SQLException, IOException {
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(outs));
        Connection conn = getConnection();
        DatabaseMetaData dmd = conn.getMetaData();

        out.write(dmd.getDatabaseProductName() +
                  " v" + dmd.getDatabaseMajorVersion() +
                  "." + dmd.getDatabaseMinorVersion());
        out.write(" with driver " + dmd.getDriverName() +
                  " v" + dmd.getDriverMajorVersion() +
                  "."  + dmd.getDriverMinorVersion());
        out.newLine();

        ResultSet rs = dmd.getCatalogs();
        if (rs != null) {
            while (rs.next()) {
                out.write(rs.getString(1)); out.newLine();
            }
        }
            
        rs = dmd.getClientInfoProperties();
        if (rs != null) {
            while (rs.next()) {
                out.write(rs.getString(1));
                out.write(", " + rs.getInt(2));
                out.write(", " + rs.getString(3));
                out.write(", " + rs.getString(4));
                out.newLine();
            }
        }
        out.flush();
        conn.close();
    }

    /** Singleton implementation */
    private static class DBConnectionHolder {
        private static final MuDB INSTANCE = new MuDB();
    }
    /** Access to the singleton
     * @return the singleton MuDB instance from the holder
     */
    public static MuDB getInstance() {
        return DBConnectionHolder.INSTANCE;
    }

}
