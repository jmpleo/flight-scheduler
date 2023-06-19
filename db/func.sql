CREATE
OR REPLACE FUNCTION update_city(id INTEGER, name VARCHAR(50)) RETURNS VOID AS $$  BEGIN
UPDATE
    city
SET
    name = $2
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_city(name VARCHAR(50)) RETURNS VOID AS $$  BEGIN
INSERT INTO
    city (name)
VALUES
    (name);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_city(id INTEGER) RETURNS VOID AS $$  BEGIN
DELETE FROM
    city
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_airport(iata_code CHAR(3), name VARCHAR(50), city_id INT) RETURNS VOID AS $$ BEGIN
UPDATE
    airport
SET
    name = $2,
    city_id = $3
WHERE
    iata_code = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_airport(iata_code CHAR(3), name VARCHAR(50), city_id INT) RETURNS VOID AS $$ BEGIN
INSERT INTO
    airport (iata_code, name, city_id)
VALUES
    (iata_code, name, city_id);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_airport(iata_code CHAR(3)) RETURNS VOID AS $$ BEGIN
DELETE FROM
    airport
WHERE
    iata_code = iata_code;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_airline(
  iata_code CHAR(2),
  name VARCHAR(50),
  website VARCHAR(50)
) RETURNS VOID AS $$  BEGIN
UPDATE
    airline
SET
    name = $2,
    website = $3
WHERE
    iata_code = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_airline(
  iata_code CHAR(2),
  name VARCHAR(50),
  website VARCHAR(50)
) RETURNS VOID AS $$  BEGIN
INSERT INTO
    airline (iata_code, name, website)
VALUES
    (iata_code, name, website);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_airline(iata_code CHAR(2)) RETURNS VOID AS $$  BEGIN
DELETE FROM
    airline
WHERE
    iata_code = iata_code;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_aircraft(id INTEGER, model VARCHAR(50)) RETURNS VOID AS $$  BEGIN
UPDATE
    aircraft
SET
    model = $2
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_aircraft(model VARCHAR(50)) RETURNS VOID AS $$  BEGIN
INSERT INTO
    aircraft (model)
VALUES
    (model);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_aircraft(id INTEGER) RETURNS VOID AS $$  BEGIN
DELETE FROM
    aircraft
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_flight(
  id INTEGER,
  flight_number INT,
  aircraft_id INT,
  airline_code CHAR(2),
  to_airport CHAR(3),
  from_airport CHAR(3)
) RETURNS VOID AS $$  BEGIN
UPDATE
    flight
SET
    flight_number = $2,
    aircraft_id = $3,
    airline_code = $4,
    to_airport = $5,
    from_airport = $6
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_flight(
  flight_number INT,
  aircraft_id INT,
  airline_code CHAR(2),
  to_airport CHAR(3),
  from_airport CHAR(3)
) RETURNS VOID AS $$  BEGIN
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

CREATE
OR REPLACE FUNCTION delete_flight(id INTEGER) RETURNS VOID AS $$  BEGIN
DELETE FROM
    flight
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_schedule(id INTEGER, flight INT, departure TIMESTAMP) RETURNS VOID AS $$  BEGIN
UPDATE
    schedule
SET
    flight = $2,
    departure = $3
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_schedule(flight INT, departure TIMESTAMP) RETURNS VOID AS $$  BEGIN
INSERT INTO
    schedule (flight, departure)
VALUES
    (flight, departure);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_schedule(id INTEGER) RETURNS VOID AS $$  BEGIN
DELETE FROM
    schedule
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_status(
  id INT,
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) RETURNS VOID AS $$  BEGIN
UPDATE
    status
SET
    gate = $2,
    check_in = $3,
    takeoff = $4,
    arrival = $5
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_status(
  id INT,
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) RETURNS VOID AS $$  BEGIN
INSERT INTO
    status (id, gate, check_in, takeoff, arrival)
VALUES
    (id, gate, check_in, takeoff, arrival);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_status(id INT) RETURNS VOID AS $$ BEGIN
DELETE FROM
    status
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_city(id INTEGER, name VARCHAR(50)) RETURNS VOID AS $$ BEGIN
UPDATE
    city
SET
    name = $2
WHERE
    id = $1;
END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_city(name VARCHAR(50)) RETURNS VOID AS $$ BEGIN
INSERT INTO
    city (name)
VALUES
    (name);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_city(id INTEGER) RETURNS VOID AS $$ BEGIN
DELETE FROM
    city
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_airport(iata_code CHAR(3), name VARCHAR(50), city_id INT) RETURNS VOID AS $$ BEGIN
UPDATE
    airport
SET
    name = $2,
    city_id = $3
WHERE
    iata_code = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_airport(iata_code CHAR(3), name VARCHAR(50), city_id INT) RETURNS VOID AS $$ BEGIN
INSERT INTO
    airport (iata_code, name, city_id)
VALUES
    (iata_code, name, city_id);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_airport(iata_code CHAR(3)) RETURNS VOID AS $$ BEGIN
DELETE FROM
    airport
WHERE
    iata_code = iata_code;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_airline(
  iata_code CHAR(2),
  name VARCHAR(50),
  website VARCHAR(50)
) RETURNS VOID AS $$ BEGIN
UPDATE
    airline
SET
    name = $2,
    website = $3
WHERE
    iata_code = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_airline(
  iata_code CHAR(2),
  name VARCHAR(50),
  website VARCHAR(50)
) RETURNS VOID AS $$ BEGIN
INSERT INTO
    airline (iata_code, name, website)
VALUES
    (iata_code, name, website);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_airline(iata_code CHAR(2)) RETURNS VOID AS $$ BEGIN
DELETE FROM
    airline
WHERE
    iata_code = iata_code;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_aircraft(id INTEGER, model VARCHAR(50)) RETURNS VOID AS $$ BEGIN
UPDATE
    aircraft
SET
    model = $2
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_aircraft(model VARCHAR(50)) RETURNS VOID AS $$ BEGIN
INSERT INTO
    aircraft (model)
VALUES
    (model);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_aircraft(id INTEGER) RETURNS VOID AS $$ BEGIN
DELETE FROM
    aircraft
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_flight(
  id INTEGER,
  flight_number INT,
  aircraft_id INT,
  airline_code CHAR(2),
  to_airport CHAR(3),
  from_airport CHAR(3)
) RETURNS VOID AS $$ BEGIN
UPDATE
    flight
SET
    flight_number = $2,
    aircraft_id = $3,
    airline_code = $4,
    to_airport = $5,
    from_airport = $6
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_flight(
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

CREATE
OR REPLACE FUNCTION delete_flight(id INTEGER) RETURNS VOID AS $$ BEGIN
DELETE FROM
    flight
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_schedule(id INTEGER, flight INT, departure TIMESTAMP) RETURNS VOID AS $$ BEGIN
UPDATE
    schedule
SET
    flight = $2,
    departure = $3
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_schedule(flight INT, departure TIMESTAMP) RETURNS VOID AS $$ BEGIN
INSERT INTO
    schedule (flight, departure)
VALUES
    (flight, departure);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_schedule(id INTEGER) RETURNS VOID AS $$ BEGIN
DELETE FROM
    schedule
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION update_status(
  id INT,
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) RETURNS VOID AS $$ BEGIN
UPDATE
    status
SET
    gate = $2,
    check_in = $3,
    takeoff = $4,
    arrival = $5
WHERE
    id = $1;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION add_status(
  id INT,
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) RETURNS VOID AS $$ BEGIN
INSERT INTO
    status (id, gate, check_in, takeoff, arrival)
VALUES
    (id, gate, check_in, takeoff, arrival);

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION delete_status(id INT) RETURNS VOID AS $$ BEGIN
DELETE FROM
    status
WHERE
    id = id;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION get_flight_info(
  start_time TIMESTAMP DEFAULT NULL,
  end_time TIMESTAMP DEFAULT NULL,
  airline_code CHAR(2) DEFAULT NULL,
  aircraft VARCHAR(50) DEFAULT NULL,
  from_city VARCHAR(50) DEFAULT NULL,
  to_city VARCHAR(50) DEFAULT NULL,
  to_airport_code CHAR(3) DEFAULT NULL,
  from_airport_code CHAR(3) DEFAULT NULL,
  check_in INT DEFAULT NULL,
  gate_number INT DEFAULT NULL
) RETURNS TABLE(
  flight_number INT,
  airline_name VARCHAR(50),
  airline_iata_code VARCHAR(2),
  aircraft_model VARCHAR(50),
  from_city_name VARCHAR(50),
  to_city_name VARCHAR(50),
  from_airport VARCHAR(3),
  to_airport VARCHAR(3),
  departure TIMESTAMP,
  gate INT,
  check_in_number INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) AS $$
BEGIN
RETURN QUERY
SELECT
  f.flight_number,
  al.name AS airline_name,
  al.iata_code AS airline_code,
  ac.model AS aircraft_model,
  cf.name AS from_city_name,
  ct.name AS to_city_name,
  f.from_airport,
  f.to_airport,
  s.departure,
  st.gate AS gate_number,
  st.check_in AS check_in_number,
  st.takeoff,
  st.arrival
FROM
  flight f
JOIN airline al ON f.airline_code = al.iata_code
JOIN aircraft ac ON f.aircraft_id = ac.id
JOIN airport af ON f.from_airport = af.iata_code
JOIN airport at ON f.to_airport = at.iata_code
JOIN city cf ON af.city_id = cf.id
JOIN city ct ON at.city_id = ct.id
JOIN schedule s ON f.id = s.flight
JOIN status st ON s.id = st.id
WHERE
  ($1 IS NULL OR s.departure BETWEEN $1 AND $2) AND
  ($3 IS NULL OR al.iata_code = $3) AND
  ($4 IS NULL OR ac.model = $4) AND
  ($5 IS NULL OR cf.name = $5) AND
  ($6 IS NULL OR ct.name = $6) AND
  ($7 IS NULL OR f.to_airport = $7) AND
  ($8 IS NULL OR f.from_airport = $8) AND
  ($9 IS NULL OR st.check_in = $9) AND
  ($10 IS NULL OR st.gate = $10);
END;

$$ LANGUAGE PLPGSQL;

CREATE
OR REPLACE FUNCTION cancel_flight(flight_id INT) RETURNS VOID AS $$ DECLARE flight_status RECORD;

BEGIN
SELECT * INTO flight_status
FROM
    status
WHERE
    id = flight_id;
IF flight_status.arrival IS NOT NULL THEN RAISE EXCEPTION 'Flight has already landed.';

END IF;

UPDATE
  status
SET
  gate = NULL,
  check_in = NULL,
  takeoff = NULL,
  arrival = CAST(
    (
      CAST(
        (
          SELECT
              s.departure
          FROM
              schedule s
          WHERE
              s.flight = flight_id
        ) AS DATE
      ) + INTERVAL '1 day'
    ) AS TIMESTAMP
  )
WHERE
    id = flight_id;

END;

$$ LANGUAGE plpgsql;
