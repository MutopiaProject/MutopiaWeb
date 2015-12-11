CREATE TABLE muInstrument (
    instrument TEXT PRIMARY KEY,
    in_mutopia INTEGER DEFAULT(0) -- true if in instruments.dat
) WITHOUT ROWID;
