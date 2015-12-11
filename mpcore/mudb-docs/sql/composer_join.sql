SELECT comp.description, piece.title, cc.name
  FROM muPiece AS piece
  JOIN muLicense AS cc
     ON piece.license_id=cc._id
  JOIN muComposer AS comp
     ON piece.composer_id=comp._id
  WHERE piece._id=1720;
