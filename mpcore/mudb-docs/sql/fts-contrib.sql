DROP TABLE IF EXISTS muVContributor;
CREATE VIRTUAL TABLE muVContributor USING fts3(name, email, url);
INSERT INTO muVContributor (name, email, url)
    SELECT name,email,url FROM muContributor
    ;
