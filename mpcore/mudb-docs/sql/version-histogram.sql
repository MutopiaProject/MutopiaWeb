.mode column
.header on
.width 9 6
SELECT v.major||'.'||v.minor as version, count(1) AS count
    FROM muPiece AS p
    JOIN muVersion AS v ON p.version_id = v._id
    GROUP BY v.major||v.minor
    ORDER BY v.major,v.minor;
