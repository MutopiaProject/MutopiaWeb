CREATE TABLE muPiece (
    _id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    composer TEXT,
    style TEXT REFERENCES muStyle(style),
    raw_instrument TEXT,
    license_id INTEGER,
    maintainer_id INTEGER REFERENCES muContributor(_id),
    version_id INTEGER,
    opus TEXT,
    lyricist TEXT,
    date_composed TEXT,    -- Loose
    date_published TEXT,   -- Precise ISO8601 date (YYYY-MM-DD)
    source TEXT,
    moreinfo TEXT,
    FOREIGN KEY(composer) REFERENCES muComposer(composer),
    FOREIGN KEY(license_id) REFERENCES muLicense(_id),
    FOREIGN KEY(version_id)  REFERENCES muVersion (_id)
);
