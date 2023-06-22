CREATE OR REPLACE FUNCTION update_city (
  city_id INT, new_name VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM city WHERE id = city_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM city WHERE id = city_id) THEN
    RAISE EXCEPTION 'Город не существует (id = %)', city_id;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE city SET name = new_name WHERE id = city_id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_airline(
  airline_code CHAR(2),
  new_name VARCHAR(50) DEFAULT NULL,
  new_website VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airline WHERE iata_code = airline_code FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = airline_code) THEN
    RAISE EXCEPTION 'Авиалиния не существует (iata_code = %)', airline_code;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE airline SET name = new_name WHERE iata_code = airline_code;
  END IF;

  IF new_website IS NOT NULL THEN
    UPDATE airline SET website = new_website WHERE iata_code = airline_code;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_airport(
  airport_code CHAR(3),
  new_name VARCHAR(50) DEFAULT NULL,
  new_city_id INT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airport WHERE iata_code = airport_code FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = airport_code) THEN
    RAISE EXCEPTION 'Aэропорт не существует (iata_code = %)', airport_code;
  END IF;

  SELECT * FROM city WHERE name = new_city_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM city WHERE id = new_city_id) THEN
    RAISE EXCEPTION 'Город не существует (id = %)', new_city_id;
  END IF;

  IF new_name IS NOT NULL THEN
    UPDATE airport SET name = new_name WHERE iata_code = airport_code;
  END IF;

  IF new_city_id IS NOT NULL THEN
    UPDATE airport SET city_id = new_city_id WHERE iata_code = airport_code;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_aircraft(
  aircraft_id INT,
  new_model VARCHAR(50) DEFAULT NULL,
  new_manufacturer VARCHAR(50) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM aircraft WHERE id = aircraft_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = aircraft_id) THEN
    RAISE EXCEPTION 'Cудно не существует (id = %)', aircraft_id;
  END IF;

  IF new_model IS NOT NULL THEN
    UPDATE aircraft SET model = new_model WHERE id = aircraft_id;
  END IF;

  IF new_manufacturer IS NOT NULL THEN
    UPDATE aircraft SET manufacturer = new_manufacturer WHERE id = aircraft_id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_flight(
  flight_id INT,
  new_flight_number INT DEFAULT NULL,
  new_aircraft_id INT DEFAULT NULL,
  new_airline_code CHAR(2) DEFAULT NULL,
  new_to_airport CHAR(3) DEFAULT NULL,
  new_from_airport CHAR(3) DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM flight WHERE id = flight_id FOR UPDATE;

  IF NOT EXISTS(SELECT 1 FROM flight WHERE id = flight_id) THEN
    RAISE EXCEPTION 'Рейс не существует (id = %)', flight_id;
  END IF;

  IF new_flight_number IS NOT NULL THEN
    UPDATE flight SET flight_number = new_flight_number WHERE id = flight_id;
  END IF;

  IF new_aircraft_id IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = new_aircraft_id) THEN
      RAISE EXCEPTION 'Cудно не существует (id = %)', new_aircraft_id;
    END IF;
    UPDATE flight SET aircraft_id = new_aircraft_id WHERE id = flight_id;
  END IF;

  IF new_airline_code IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = new_airline_code) THEN
      RAISE EXCEPTION 'Авиалиния не существует (iata_code = %)', new_airline_code;
    END IF;
    UPDATE flight SET airline_code = new_airline_code WHERE id = flight_id;
  END IF;

  IF new_to_airport IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = new_to_airport) THEN
      RAISE EXCEPTION 'Aэропорт не существует (iata_code = %)', new_to_airport;
    END IF;
    UPDATE flight SET to_airport = new_to_airport WHERE id = flight_id;
  END IF;

  IF new_from_airport IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = new_from_airport) THEN
      RAISE EXCEPTION 'Aэропорт не существует (iata_code = %)', new_from_airport;
    END IF;
    UPDATE flight SET from_airport = new_from_airport WHERE id = flight_id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_schedule(
  schedule_id INT,
  new_flight INT DEFAULT NULL,
  new_departure TIMESTAMP DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM schedule WHERE id = schedule_id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM schedule WHERE id = schedule_id) THEN
    RAISE EXCEPTION 'Запись не существует в расписании (id = %)', schedule_id;
  END IF;

  IF new_flight IS NOT NULL THEN
    IF NOT EXISTS(SELECT 1 FROM flight WHERE id = new_flight) THEN
      RAISE EXCEPTION 'Рейс не существует (id = %)', new_flight;
    END IF;
    UPDATE schedule SET flight = new_flight WHERE id = schedule_id;
  END IF;

  IF new_departure IS NOT NULL THEN
    UPDATE schedule SET departure = new_departure WHERE id = schedule_id;
  END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_status(
  schedule_id INT,
  new_gate INT DEFAULT NULL,
  new_check_in INT DEFAULT NULL,
  new_takeoff TIMESTAMP DEFAULT NULL,
  new_arrival TIMESTAMP DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  SELECT * FROM status WHERE id = schedule_id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM status WHERE id = schedule_id) THEN
    RAISE EXCEPTION 'Запись не существует в расписании (id = %)', schedule_id;
  END IF;

  IF new_gate IS NOT NULL THEN
    UPDATE status SET gate = new_gate WHERE id = schedule_id;
  END IF;

  IF new_check_in IS NOT NULL THEN
    UPDATE status SET check_in = new_check_in WHERE id = schedule_id;
  END IF;

  IF new_takeoff IS NOT NULL THEN
    UPDATE status SET takeoff = new_takeoff WHERE id = schedule_id;
  END IF;

  IF new_arrival IS NOT NULL THEN
    UPDATE status SET arrival = new_arrival WHERE id = schedule_id;
  END IF;
END;
$$ LANGUAGE plpgsql;

