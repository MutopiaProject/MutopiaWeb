SELECT piece.composer, count(piece.composer) as ccount
    FROM muPiece AS piece
    WHERE piece._id IN (
        SELECT piece_id
        FROM muPieceInstrument
        WHERE instrument='Violin')
    GROUP BY piece.composer
    ORDER BY ccount DESC
    LIMIT 6
;
