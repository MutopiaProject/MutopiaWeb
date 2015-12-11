SELECT composer, title, cc.name
  FROM muPiece
  JOIN muLicense AS cc
    ON muPiece.license_id=cc._id
  WHERE muPiece._id=1720;
