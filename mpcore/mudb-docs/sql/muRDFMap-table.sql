CREATE TABLE muRDFMap (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    rdfspec TEXT,
    piece_id INTEGER UNIQUE,
    FOREIGN KEY(piece_id) REFERENCES muPiece(_id)
 );
