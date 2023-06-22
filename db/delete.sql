CREATE OR REPLACE FUNCTION delete_city(id INT) RETURNS VOID AS $$
BEGIN
  SELECT * FROM city WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM city WHERE id = id) THEN
    RAISE EXCEPTION 'Город с id % не существует', id;
  END IF;
  DELETE FROM city WHERE id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_airline(iata_code CHAR(2)) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airline WHERE iata_code = iata_code FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM airline WHERE iata_code = iata_code) THEN
    RAISE EXCEPTION 'Авиалинии с кодом % не существует', iata_code;
  END IF;
  DELETE FROM airport WHERE iata_code = iata_code;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_airport(iata_code CHAR(3)) RETURNS VOID AS $$
BEGIN
  SELECT * FROM airport WHERE iata_code = iata_code FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM airport WHERE iata_code = iata_code) THEN
    RAISE EXCEPTION 'Aэропорт с кодом % не существует', iata_code;
  END IF;
  DELETE FROM airport WHERE iata_code = iata_code;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_aircraft(id INT) RETURNS VOID AS $$
BEGIN
  SELECT * FROM aircraft WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM aircraft WHERE id = id) THEN
    RAISE EXCEPTION 'Воздушного судна с id % не существует', id;
  END IF;
  DELETE FROM aircraft WHERE id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_flight(id INT) RETURNS VOID AS $$
BEGIN
  SELECT * FROM flight WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM flight WHERE id = id) THEN
    RAISE EXCEPTION 'Рейса с id % не существует', id;
  END IF;
  DELETE FROM flight WHERE id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_schedule(id INT) RETURNS VOID AS $$
BEGIN
  SELECT * FROM schedule WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM schedule WHERE id = id) THEN
    RAISE EXCEPTION 'Записи с id % не существует в расписании', id;
  END IF;
  DELETE FROM schedule WHERE id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_status(id INT) RETURNS VOID AS $$
BEGIN
  SELECT * FROM status WHERE id = id FOR UPDATE;
  IF NOT EXISTS(SELECT 1 FROM status WHERE id = id) THEN
    RAISE EXCEPTION 'Записи с id % не существует в расписании', id;
  END IF;
  DELETE FROM status WHERE id = id;
END;
$$ LANGUAGE plpgsql;
