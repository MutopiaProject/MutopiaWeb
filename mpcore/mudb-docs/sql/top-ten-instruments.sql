SELECT instrument, count(instrument) AS t_count
   FROM muPieceInstrument
   GROUP BY instrument
   ORDER BY t_count DESC
   LIMIT 10
   ;
