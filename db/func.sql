CREATE FUNCTION add_city (NAME VARCHAR(50)) RETURNS VOID AS $$ BEGIN
INSERT INTO
  city (NAME)
VALUES
  (NAME);

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION update_airport_name (new_name VARCHAR(50)) RETURNS VOID AS $$ BEGIN
UPDATE
  airport
SET
  NAME = new_name
WHERE
  iata_code = 'SVO';

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION delete_airline () RETURNS VOID AS $$ BEGIN
DELETE FROM
  airline
WHERE
  iata_code = 'AA';

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION add_aircraft (model VARCHAR(50)) RETURNS VOID AS $$ BEGIN
INSERT INTO
  aircraft (model)
VALUES
  (model);

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION add_flight (
  flight_number INT,
  aircraft_id INT,
  airline_code CHAR(2),
  to_airport CHAR(3),
  from_airport CHAR(3)
) RETURNS VOID AS $$ BEGIN
INSERT INTO
  flight (
    flight_number,
    aircraft_id,
    airline_code,
    to_airport,
    from_airport
  )
VALUES
  (
    flight_number,
    aircraft_id,
    airline_code,
    to_airport,
    from_airport
  );

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION add_schedule (flight_id INT, departure TIMESTAMP) RETURNS VOID AS $$ BEGIN
INSERT INTO
  schedule (flight, departure)
VALUES
  (flight_id, departure);

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION update_takeoff_time (new_takeoff TIMESTAMP) RETURNS VOID AS $$ BEGIN
UPDATE
  STATUS
SET
  takeoff = new_takeoff
WHERE
  id = 1;

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION get_cities () RETURNS TABLE (id INT, NAME VARCHAR(50)) AS $$ BEGIN RETURN QUERY
SELECT
  *
FROM
  city;

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION get_flights_with_airports () RETURNS TABLE (
  flight_number INT,
  airline_code CHAR(2),
  from_airport CHAR(3),
  to_airport CHAR(3),
  from_airport_name VARCHAR(50),
  to_airport_name VARCHAR(50)
) AS $$ BEGIN RETURN QUERY
SELECT
  f.flight_number,
  f.airline_code,
  f.from_airport,
  f.to_airport,
  a1.NAME AS from_airport_name,
  a2.NAME AS to_airport_name
FROM
  flight f
  INNER JOIN airport a1 ON f.from_airport = a1.iata_code
  INNER JOIN airport a2 ON f.to_airport = a2.iata_code;

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION get_flights_with_schedule_and_status () RETURNS TABLE (
  flight_number INT,
  airline_code CHAR(2),
  departure TIMESTAMP,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) AS $$ BEGIN RETURN QUERY
SELECT
  f.flight_number,
  f.airline_code,
  s.departure,
  st.takeoff,
  st.arrival
FROM
  flight f
  INNER JOIN schedule s ON f.id = s.flight
  INNER JOIN STATUS st ON s.id = st.id;

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION get_flights_details (start_date TIMESTAMP, end_date TIMESTAMP) RETURNS TABLE (
  flight_number INT,
  airline_code CHAR(2),
  from_airport_name VARCHAR(50),
  to_airport_name VARCHAR(50),
  departure TIMESTAMP,
  takeoff TIMESTAMP,
  arrival TIMESTAMP,
  gate INT,
  check_in INT
) AS $$ BEGIN RETURN QUERY

SELECT
  f.flight_number,
  f.airline_code,
  a1.NAME AS from_airport_name,
  a2.NAME AS to_airport_name,
  s.departure,
  st.takeoff,
  st.arrival,
  st.gate,
  st.check_in
FROM
  flight f
  INNER JOIN airport a1 ON f.from_airport = a1.iata_code
  INNER JOIN airport a2 ON f.to_airport = a2.iata_code
  INNER JOIN schedule s ON f.id = s.flight
  INNER JOIN status st ON s.id = st.id
WHERE
  s.departure BETWEEN start_date AND end_date;

END;

$$ LANGUAGE plpgsql;

CREATE FUNCTION filter_flights (
  flight_number INT DEFAULT NULL,
  airline_code CHAR(2) DEFAULT NULL,
  from_airport_name VARCHAR(50) DEFAULT NULL,
  to_airport_name VARCHAR(50) DEFAULT NULL,
  start_date TIMESTAMP DEFAULT NULL,
  end_date TIMESTAMP DEFAULT NULL
) RETURNS TABLE (
  flight_number INT,
  airline_code CHAR(2),
  from_airport_name VARCHAR(50),
  to_airport_name VARCHAR(50),
  departure TIMESTAMP,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) AS $$ BEGIN RETURN QUERY
SELECT
  f.flight_number,
  f.airline_code,
  a1.NAME AS from_airport_name,
  a2.NAME AS to_airport_name,
  s.departure,
  st.takeoff,
  st.arrival
FROM
  flight f
  INNER JOIN airport a1 ON f.from_airport = a1.iata_code
  INNER JOIN airport a2 ON f.to_airport = a2.iata_code
  INNER JOIN schedule s ON f.id = s.flight
  INNER JOIN status st ON s.id = st.id
WHERE
      ( flight_number IS NULL OR f.flight_number = flight_number )
  AND ( airline_code IS NULL OR f.airline_code = airline_code )
  AND ( from_airport_name IS NULL OR a1.NAME = from_airport_name )
  AND ( to_airport_name IS NULL OR a2.NAME = to_airport_name )
  AND ( start_date IS NULL OR s.departure >= start_date )
  AND ( end_date IS NULL OR s.departure <= end_date );
END;

$$ LANGUAGE plpgsql;
