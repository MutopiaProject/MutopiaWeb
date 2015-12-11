CREATE VIEW [piece_4n] as
    select * from muPiece
        where muPiece.version_id in
(SELECT muVersion._id FROM muVersion
    where major = 2
    and minor = 2);
