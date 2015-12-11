SELECT version FROM muVersion AS v
    WHERE v._id NOT IN (SELECT version_id FROM muPiece);
