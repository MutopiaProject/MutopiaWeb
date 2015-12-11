SELECT composer || ': ' || count(_id) as cnt FROM muPiece as p
  WHERE _id IN (
      SELECT piece_id FROM muPieceInstrument
	WHERE instrument='Violin'
    INTERSECT
      SELECT piece_id FROM muPieceInstrument
	WHERE instrument='Cello'
  ) GROUP BY p.composer ORDER BY count(_id) DESC
    LIMIT 6
;
