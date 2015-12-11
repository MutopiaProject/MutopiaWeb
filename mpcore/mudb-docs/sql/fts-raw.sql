DROP TABLE IF EXISTS muVRawInstrument;
CREATE VIRTUAL TABLE muVRawInstrument USING fts3(_id, raw_instrument);
INSERT INTO muVRawInstrument (_id, raw_instrument)
    SELECT _id, raw_instrument FROM muPiece
    ;
