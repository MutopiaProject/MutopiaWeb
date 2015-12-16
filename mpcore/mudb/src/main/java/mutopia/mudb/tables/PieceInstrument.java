package mutopia.mudb.tables;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/**
 * Define and populate the {@code PieceInstrument} table. Population must
 * occur after the {@code Piece} table has been populated.
 */
public class PieceInstrument extends DBTable {

    public PieceInstrument() {
        super("PieceInstrument");
    }

    /** Create an SQL string this table.
     * @return the SQL for create a PieceInstrument table.
     */
    @Override
    public String createTableSQL() {
        String sql_table[] = new String[] {
            "CREATE TABLE muPieceInstrument (",
            "    piece_id INTEGER REFERENCES muPiece(_id),",
            "    instrument TEXT REFERENCES muInstrument(instrument),",
            "    PRIMARY KEY (piece_id, instrument)",
            ") WITHOUT ROWID ;"
        };
        StringBuilder sb = new StringBuilder();
        for (String s : sql_table) {
            sb.append(s + "\n");
        }
        return sb.toString();
    }


    /** Populate the PieceInstrument table.
     *  Walk through all pieces, parse raw_instruments into
     *  instruments, create mapping from pieces to instruments.
     *  @param   conn The DB connection
     *  @return  true if table translated completely, false otherwise.
     *  @throws  SQLException on any database error
     */
    @Override
    public boolean populateTable(Connection conn) throws SQLException {
        Logger log = LoggerFactory.getLogger(PieceInstrument.class);
        log.info("Not yet implemented");
        return true;
    }

}
