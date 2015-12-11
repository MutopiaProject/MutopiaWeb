select piece from instrument_piece_map
  where instrument='Violin'
intersect
select piece from instrument_piece_map
  where instrument='Cello' ;
