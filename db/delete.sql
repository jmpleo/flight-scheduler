CREATE OR REPLACE FUNCTION delete_city(city_id INT) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM city WHERE id = city_id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM city WHERE id = city_id) THEN
    RAISE EXCEPTION 'Город не существует (id = %)', city_id;
  END IF;
  BEGIN
    DELETE FROM city WHERE id = city_id;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Город используется в других таблицах (id = %)', city_id;
  END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_airline(airline_code CHAR(2))
RETURNS VOID AS $$
BEGIN
  PERFORM * FROM airline WHERE iata_code = airline_code FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = airline_code) THEN
    RAISE EXCEPTION 'Авиалиния не существует (iata_code = %)', airline_code;
  END IF;
  BEGIN
    DELETE FROM airline WHERE iata_code = airline_code;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Авиалиния используется в других таблицах (iata_code = %)', airline_code;
  END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_airport(airport_code CHAR(3)) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM airport WHERE iata_code = airport_code FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = airport_code) THEN
    RAISE EXCEPTION 'Aэропорт не существует (iata_code = %)', airport_code;
  END IF;
  BEGIN
    DELETE FROM airport WHERE iata_code = airport_code;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Аэропорт используется в других таблицах (iata_code = %)', airport_code;
  END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_aircraft(aircraft_id INT) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM aircraft WHERE id = aircraft_id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = aircraft_id) THEN
    RAISE EXCEPTION 'Cудно не существует (id = %)', aircraft_id;
  END IF;
  BEGIN
    DELETE FROM aircraft WHERE id = aircraft_id;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Судно используется в других таблицах (id = %)', aircraft_code;
  END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_flight(flight_id INT) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM flight WHERE id = flight_id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM flight WHERE id = flight_id) THEN
    RAISE EXCEPTION 'Рейс не существует (id = %)', flight_id;
  END IF;
  BEGIN
    DELETE FROM flight WHERE id = flight_id;
  EXCEPTION
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Рейс используется в других таблицах (id = %)', flight_id;
  END;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_schedule(schedule_id INT) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM schedule WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM schedule WHERE id = schedule_id) THEN
    RAISE EXCEPTION 'Запись не существует в расписании (id = %)', schedule_id;
  END IF;
  DELETE FROM schedule WHERE id = schedule_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_status(schedule_id INT) RETURNS VOID AS $$
BEGIN
  PERFORM * FROM status WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM status WHERE id = schedule_id) THEN
    RAISE EXCEPTION 'Запись не существует в расписании (id = %)', schedule_id;
  END IF;
  DELETE FROM status WHERE id = schedule_id;
END;
$$ LANGUAGE plpgsql;
