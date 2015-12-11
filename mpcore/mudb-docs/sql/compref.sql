    -- a query to find all titles by a given composer 
select title from mp_piece
    where mp_piece.composer_id in (
      select mp_composer._id from mp_composer where composer="BachJS"
    )
;
