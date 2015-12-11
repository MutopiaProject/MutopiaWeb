SELECT piece.composer, piece.title
    FROM muPiece AS piece
    WHERE piece._id IN (
        SELECT piece_id
        FROM muPieceInstrument
        WHERE instrument='Violin')
;
