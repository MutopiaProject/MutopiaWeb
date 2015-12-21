CREATE TABLE muPieceInstrument (
    piece_id INTEGER REFERENCES muPiece(_id),
    instrument TEXT REFERENCES muInstrument(instrument),
    PRIMARY KEY (piece_id, instrument)
) WITHOUT ROWID ;
