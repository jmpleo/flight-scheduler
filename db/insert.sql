CREATE OR REPLACE FUNCTION insert_city(name VARCHAR(50)) RETURNS VOID AS $$
BEGIN
  LOCK TABLE city IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO city (name) VALUES (name);
  EXCEPTION WHEN unique_violation THEN
    RAISE EXCEPTION 'Город с таким именем уже существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_airport(
  iata_code CHAR(3), airport_name VARCHAR(50), city_name VARCHAR(50)
) RETURNS VOID AS $$
DECLARE
  city_id INT;
BEGIN
  LOCK TABLE airport IN SHARE ROW EXCLUSIVE MODE;

  SELECT id INTO city_id FROM city WHERE name = city_name;

  BEGIN
    INSERT INTO airport (iata_code, name, city_id)
    VALUES (iata_code, airport_name, city_id);
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION 'Аэропорт с таким кодом уже существует';
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Город с таким id не существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_airline(
  iata_code CHAR(2), airline_name VARCHAR(50), website VARCHAR(50) DEFAULT ''
) RETURNS VOID AS $$
BEGIN
  LOCK TABLE airline IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO airline (iata_code, name, website)
    VALUES (iata_code, airline_name, website);
  EXCEPTION WHEN unique_violation THEN
    RAISE EXCEPTION 'Авиалиния уже существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_aircraft(model VARCHAR(50))
RETURNS VOID AS $$
BEGIN
  LOCK TABLE aircraft IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO aircraft (model) VALUES (model);
  EXCEPTION WHEN unique_violation THEN
    RAISE EXCEPTION 'Самолет с такой моделью уже существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_flight(
  flight_number INT,
  aircraft_id INT,
  airline_code CHAR(2),
  to_airport CHAR(3),
  from_airport CHAR(3)
) RETURNS VOID AS $$
BEGIN
  LOCK TABLE flight IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO flight (
      flight_number,
      aircraft_id,
      airline_code,
      to_airport,
      from_airport
    ) VALUES (
      flight_number,
      aircraft_id,
      airline_code,
      to_airport,
      from_airport
    );
  EXCEPTION
    WHEN unique_violation THEN
      RAISE EXCEPTION 'Рейс с таким номером для этой авиалинии уже существует';
    WHEN foreign_key_violation THEN
      RAISE EXCEPTION 'Авиалиния или аэропорт с таким кодом не существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_schedule(flight INT, departure TIMESTAMP)
RETURNS VOID AS $$
BEGIN
  LOCK TABLE schedule IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO schedule (flight, departure) VALUES (flight, departure);
  EXCEPTION WHEN foreign_key_violation THEN
    RAISE EXCEPTION 'Рейс с таким id не существует';
  END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_status(
  id INT,
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
) RETURNS VOID AS $$
BEGIN
  LOCK TABLE status IN SHARE ROW EXCLUSIVE MODE;
  BEGIN
    INSERT INTO status (id, gate, check_in, takeoff, arrival)
    VALUES (id, gate, check_in, takeoff, arrival);
  EXCEPTION WHEN foreign_key_violation THEN
    RAISE EXCEPTION 'Расписание с таким id не существует';
  END;
END;
$$ LANGUAGE plpgsql;
