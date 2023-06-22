CREATE OR REPLACE FUNCTION update_city (
  city_id INT, new_name VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM city WHERE id = city_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM city WHERE id = city_id) THEN
    RAISE EXCEPTION 'Город с id % не существует', city_id;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE city SET name = new_name WHERE id = city_id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_airline(
  iata_code CHAR(2),
  new_name VARCHAR(50) DEFAULT NULL,
  new_website VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airline WHERE iata_code = iata_code FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = iata_code) THEN
    RAISE EXCEPTION 'Авиалинии с кодом % не существует', iata_code;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE airline SET name = new_name WHERE iata_code = iata_code;
  END IF;

  IF new_website IS NOT NULL THEN
    UPDATE airline SET website = new_website WHERE iata_code = iata_code;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_airport(
  iata_code CHAR(3),
  new_name VARCHAR(50) DEFAULT NULL,
  new_city_id INT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airport WHERE iata_code = iata_code FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = iata_code) THEN
    RAISE EXCEPTION 'Aэропорт с кодом % не существует', iata_code;
  END IF;

  SELECT * FROM city WHERE name = new_city_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM city WHERE id = new_city_id) THEN
    RAISE EXCEPTION 'Город с id % не существует', new_city_id;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE airport SET name = new_name WHERE iata_code = iata_code;
  END IF;

  IF new_city_id IS NOT NULL THEN
    UPDATE airport SET city_id = new_city_id WHERE iata_code = iata_code;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_aircraft(
  id INT,
  new_model VARCHAR(50) DEFAULT NULL,
  new_manufacturer VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM aircraft WHERE id = id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = id) THEN
    RAISE EXCEPTION 'Воздушного судна с id % не существует', id;
  END IF;

  IF new_model IS NOT NULL THEN
    UPDATE aircraft SET model = new_model WHERE id = id;
  END IF;

  IF new_manufacturer IS NOT NULL THEN
    UPDATE aircraft SET manufacturer = new_manufacturer WHERE id = id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_flight(
  id INT,
  new_flight_number INT DEFAULT NULL,
  new_aircraft_id INT DEFAULT NULL,
  new_airline_code CHAR(2) DEFAULT NULL,
  new_to_airport CHAR(3) DEFAULT NULL,
  new_from_airport CHAR(3) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM flight WHERE id = id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM flight WHERE id = id) THEN
    RAISE EXCEPTION 'Рейса с id % не существует', id;
  END IF;

  IF new_flight_number IS NOT NULL THEN
    UPDATE flight SET flight_number = new_flight_number WHERE id = id;
  END IF;

  IF new_aircraft_id IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = new_aircraft_id) THEN
      RAISE EXCEPTION 'Воздушного судна с id % не существует', new_aircraft_id;
    END IF;
    UPDATE flight SET aircraft_id = new_aircraft_id WHERE id = id;
  END IF;

  IF new_airline_code IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = new_airline_code) THEN
      RAISE EXCEPTION 'Авиалинии с id % не существует', new_airline_code;
    END IF;
    UPDATE flight SET airline_code = new_airline_code WHERE id = id;
  END IF;

  IF new_to_airport IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = new_to_airport) THEN
      RAISE EXCEPTION 'Аэропорта с id % не существует', new_to_airport;
    END IF;
    UPDATE flight SET to_airport = new_to_airport WHERE id = id;
  END IF;

  IF new_from_airport IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = new_from_airport) THEN
      RAISE EXCEPTION 'Аэропорта с id % не существует', new_from_airport;
    END IF;
    UPDATE flight SET from_airport = new_from_airport WHERE id = id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_schedule(
  id INT,
  new_flight INT DEFAULT NULL,
  new_departure TIMESTAMP DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM schedule WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM schedule WHERE id = id) THEN
    RAISE EXCEPTION 'Записи с id % не существует в расписании', id;
  END IF;

  IF new_flight IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM flight WHERE id = new_flight) THEN
      RAISE EXCEPTION 'Рейса с id % не существует', new_flight;
    END IF;
    UPDATE schedule SET flight = new_flight WHERE id = id;
  END IF;

  IF new_departure IS NOT NULL THEN
    UPDATE schedule SET departure = new_departure WHERE id = id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_status(
  id INT,
  new_gate INT DEFAULT NULL,
  new_check_in INT DEFAULT NULL,
  new_takeoff TIMESTAMP DEFAULT NULL,
  new_arrival TIMESTAMP DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM status WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM status WHERE id = id) THEN
    RAISE EXCEPTION 'Записи с id % не существует в расписании', id;
  END IF;

  IF new_gate IS NOT NULL THEN
    UPDATE status SET gate = new_gate WHERE id = id;
  END IF;

  IF new_check_in IS NOT NULL THEN
    UPDATE status SET check_in = new_check_in WHERE id = id;
  END IF;

  IF new_takeoff IS NOT NULL THEN
    UPDATE status SET takeoff = new_takeoff WHERE id = id;
  END IF;

  IF new_arrival IS NOT NULL THEN
    UPDATE status SET arrival = new_arrival WHERE id = id;
  END IF;
END;
$$ LANGUAGE plpgsql;

