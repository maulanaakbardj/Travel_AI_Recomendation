CREATE DATABASE maria_datasource
WITH
  engine = 'mariadb',
  parameters = {
    "host": "127.0.0.1",
    "port": 3306,
    "database": "Test",
    "user": "root",
    "password": "password"
  };

SELECT * FROM maria_datasource.flight_prices ORDER BY flightDate DESC;

CREATE MODEL mindsdb.flight_price_predictor_a
FROM maria_datasource (
  SELECT * FROM flight_prices
  )
PREDICT totalFare
ORDER BY flightDate
GROUP BY startingAirport, destinationAirport, isBasicEconomy, isRefundable, isNonStop, segmentsAirlineName
WINDOW 30
HORIZON 10;

DESCRIBE PREDICTOR mindsdb.flight_price_predictor_a;


SELECT * FROM mindsdb.flight_price_predictor_a AS m
JOIN maria_datasource.flight_prices  AS t
WHERE t.flightDate = "2022-04-21"
AND t.startingAirport = "SFO"
AND t.isNonStop = 1
AND t.destinationAirport = "BOS";

SELECT CONCAT(CAST(random() * 1000000 as INT)) as requestID, m.flightDate, m.totalFare, m.totalFare_confidence FROM mindsdb.flight_price_predictor_a AS m
    JOIN maria_datasource.flight_prices AS t
    WHERE t.flightDate = "2022-04-21"
    AND t.startingAirport = "JFK"
    AND t.isNonStop = 1
    AND t.isRefundable = 0
    AND t.isBasicEconomy = 0
    AND t.destinationAirport = "LAX";
