CREATE VIEW [piece_5a] AS
    SELECT * from muPiece
        WHERE muPiece.version_id IN
            (SELECT muVersion._id FROM muVersion
                WHERE version = '2.4.1' OR version='2.4.5');
