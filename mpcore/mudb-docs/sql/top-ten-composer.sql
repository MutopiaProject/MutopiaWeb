SELECT composer, COUNT(composer) AS c_count
    FROM muPiece AS piece
    GROUP BY composer
    ORDER BY c_count DESC
    LIMIT 10
    ;
