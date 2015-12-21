CREATE TABLE muPiece (
    _id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    composer TEXT REFERENCES muComposer(composer),
    style TEXT REFERENCES muStyle(style),
    raw_instrument TEXT,
    license_id INTEGER REFERENCES muLicense(_id),
    maintainer_id INTEGER REFERENCES muContributor(_id),
    version_id INTEGER REFERENCES muVersion (_id),
    opus TEXT,
    lyricist TEXT,
    date_composed TEXT,
    date_published TEXT,
    source TEXT,
    moreinfo TEXT
);
