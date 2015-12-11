-- remove instrument:piece mapping when raw_instrument is updated
CREATE TRIGGER IF NOT EXISTS muPITrigger
    AFTER UPDATE OF raw_instrument on muPiece
    BEGIN
        DELETE FROM muPieceInstrument WHERE piece_id=muPiece._id;
        DELETE FROM muVPieceKeys WHERE piece_id=muPiece._id;
    END
;
