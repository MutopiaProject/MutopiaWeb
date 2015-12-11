select title from mp_piece
  where composer = 'BachJS'
     and pieces_id in (
      select piece from instrument_piece_map
	where instrument='Violin'
    intersect
      select piece from instrument_piece_map
	where instrument='Cello'
  )
;
