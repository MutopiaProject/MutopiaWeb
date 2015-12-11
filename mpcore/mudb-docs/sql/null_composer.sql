-- list mutopia id, composer, and relative path of
-- pieces with no composer in the header
select pieces_id, r.composer || "/" || r.relpath
  from pieces
  join filerefs as r
    on pieces.pieces_id = r.piece
  where pieces.composer is null ;
