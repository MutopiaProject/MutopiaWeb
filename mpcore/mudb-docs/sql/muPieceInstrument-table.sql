CREATE TABLE muPieceInstrument (
    piece_id INTEGER,
    instrument TEXT,
    FOREIGN KEY(piece_id) REFERENCES muPiece(_id),
    FOREIGN KEY(instrument) REFERENCES muInstrument(instrument),
    PRIMARY KEY (piece_id, instrument)
);
