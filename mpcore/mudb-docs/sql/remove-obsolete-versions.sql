DELETE FROM muVersion
    WHERE muVersion._id NOT IN (SELECT version_id FROM muPiece);
