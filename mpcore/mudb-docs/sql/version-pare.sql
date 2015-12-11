SELECT v.version, count(*)
    FROM muPiece AS p
    JOIN muVersion AS v ON p.version_id=v._id
    WHERE p.version_id IN (
        SELECT _id FROM muVersion WHERE major=2 AND minor=4
    )
    GROUP BY v.version
    ORDER BY v.version;
