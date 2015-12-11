DROP TABLE IF EXISTS muVComposer;
CREATE VIRTUAL TABLE muVComposer USING fts3(composer, description);
INSERT INTO muVComposer (composer, description)
    SELECT composer,description FROM muComposer
    ;
