SELECT _id,composer,raw_instrument,title FROM muPiece
    WHERE _id IN (
        SELECT _id FROM muVRawInstrument
        WHERE raw_instrument MATCH '(violin AND cello) -viola'
    );
