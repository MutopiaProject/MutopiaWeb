SELECT title FROM muPiece
  WHERE composer = 'MozartWA' AND _id IN (
      SELECT piece_id FROM muPieceInstrument
	WHERE instrument='Violin'
    INTERSECT
      SELECT piece_id FROM muPieceInstrument
	WHERE instrument='Cello'
  ) LIMIT 6
;
