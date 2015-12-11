package mutopia.mudb;

import org.junit.*;

import java.sql.Connection;
import java.sql.SQLException;

public class MarkerTest {

    @Test
    public void testCurrentMarker() throws SQLException {
        Connection conn = MuDB.getInstance().getConnection();
        @SuppressWarnings("UnusedAssignment") Marker m = new Marker(conn);
    }
}
