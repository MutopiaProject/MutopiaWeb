CREATE TABLE muVersion (
    _id INTEGER NOT NULL PRIMARY KEY,
    version TEXT NOT NULL UNIQUE,
    major INTEGER,
    minor INTEGER,
    edit TEXT
);
