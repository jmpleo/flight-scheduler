CREATE OR REPLACE FUNCTION search_city_by_text (
  cur_city REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_city FOR
    SELECT id, name FROM city
    WHERE name ILIKE '%' || search_text || '%';
  RETURN cur_city;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_airline_by_text (
  cur_airline REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_airline FOR
    SELECT a.iata_code, a.name, a.website FROM airline a
    WHERE a.name ILIKE '%' || search_text || '%'
      OR a.website ILIKE '%' || search_text || '%'
      OR a.iata_code ILIKE '%' || search_text || '%';
  RETURN cur_airline;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_airport_by_text (
  cur_airport REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_airport FOR
    SELECT a.iata_code, a.name, c.name
    FROM airport a
      JOIN city c ON a.city_id = c.id
    WHERE a.name ILIKE '%' || search_text || '%'
      OR c.name ILIKE '%' || search_text || '%';
  RETURN cur_airport;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_aircraft_by_text (
  cur_aircraft REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_aircraft FOR
    SELECT a.id, a.model, a.manufacturer FROM aircraft a
    WHERE a.model ILIKE '%' || search_text || '%'
      OR a.manufacturer ILIKE '%' || search_text || '%';
  RETURN cur_aircraft;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_flight_by_text (
  cur_flight REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_flight FOR
    SELECT
      f.id,
      f.flight_number,
      f.airline_code,
      ac.model AS aircraft_model,
      f.from_airport,
      f.to_airport
    FROM flight f
      JOIN aircraft ac ON f.aircraft_id = ac.id
    WHERE
      f.flight_number::text ILIKE '%' || search_text || '%'
      OR ac.model ILIKE '%' || search_text || '%'
      OR from_airport ILIKE '%' || search_text || '%'
      OR to_airport ILIKE '%' || search_text || '%';
  RETURN cur_flight;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_schedule_by_text (
  cur_schedule REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_schedule FOR
    SELECT
      s.id,
      f.airline_code || '-' || f.flight_number::text,
      s.departure
    FROM schedule s
      JOIN flight f ON f.id = s.flight
    WHERE
      f.airline_code || '-' || f.flight_number::text ILIKE '%' || search_text || '%';
  RETURN cur_schedule;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_schedule_by_date (
  cur_schedule REFCURSOR,
  departure_from TIMESTAMP,
  departure_to TIMESTAMP
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_schedule FOR
    SELECT
      s.id,
      f.airline_code || '-' || f.flight_number::text,
      s.departure
    FROM schedule s
      JOIN flight f ON f.id = s.flight
    WHERE
      s.departure >= departure_from AND s.departure <= departure_to;
  RETURN cur_schedule;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_status_by_text (
  cur_status REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_status FOR
    SELECT
      st.id,
      f.airline_code || '-' || f.flight_number::text,
      s.departure,
      st.gate,
      st.check_in,
      st.takeoff,
      st.arrival
    FROM status st
      JOIN schedule s ON s.id = st.id
      JOIN flight f ON f.id = s.flight
    WHERE
      f.airline_code || '-' || f.flight_number::text ILIKE '%' || search_text || '%'
      OR st.gate::text ILIKE '%' || search_text || '%'
      OR st.check_in ILIKE '%' || search_text || '%';
  RETURN cur_status;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_status_by_date (
  cur_status REFCURSOR,
  departure_from TIMESTAMP,
  departure_to TIMESTAMP
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_status FOR
    SELECT
      st.id,
      f.airline_code || '-' || f.flight_number::text,
      s.departure,
      st.gate,
      st.check_in,
      st.takeoff,
      st.arrival
    FROM status st
      JOIN schedule s ON s.id = st.id
      JOIN flight f ON f.id = s.flight
    WHERE
      s.departure >= departure_from AND s.departure <= departure_to;
    RETURN cur_status;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_flight_status_summary (
  cur_status_summary REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_status_summary FOR
    SELECT
      f.id,
      f.flight_number,
      f.airline_code,
      f.airline_code || '-' || f.flight_number::text AS flight_fullname,
      ac.manufacturer || ' ' || ac.model AS aircraft_fullname,
      st.gate,
      st.check_in,
      st.takeoff,
      st.arrival,
      f.from_airport,
      f.to_airport
    FROM flight f
      JOIN airline a ON f.airline_code = a.iata_code
      JOIN aircraft ac ON f.aircraft_id = ac.id
      JOIN schedule s ON f.id = s.flight
      JOIN status st ON s.id = st.id
      JOIN airport from_a ON f.from_airport = from_a.iata_code
      JOIN airport to_a ON f.to_airport = to_a.iata_code
      JOIN city from_c ON from_a.city_id = from_c.id
      JOIN city to_c ON to_a.city_id = to_c.id
    WHERE
      f.flight_number::text ILIKE '%' || search_text || '%'
      OR a.name ILIKE '%' || search_text || '%'
      OR a.iata_code ILIKE '%' || search_text || '%'
      OR ac.model ILIKE '%' || search_text || '%'
      OR from_a.name ILIKE '%' || search_text || '%'
      OR to_a.name ILIKE '%' || search_text || '%'
      OR from_a.iata_code ILIKE '%' || search_text || '%'
      OR to_a.iata_code ILIKE '%' || search_text || '%'
      OR from_c.name ILIKE '%' || search_text || '%'
      OR to_c.name ILIKE '%' || search_text || '%'
      OR st.gate::text ILIKE '%' || search_text || '%'
      OR st.check_in ILIKE '%' || search_text || '%';
  RETURN cur_status_summary;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_flight_status_summary (
  cur_status_summary REFCURSOR,
  departure_from TIMESTAMP,
  departure_to TIMESTAMP
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_status_summary FOR
    SELECT
      f.id,
      f.flight_number,
      f.airline_code,
      f.airline_code || '-' || f.flight_number::text AS flight_fullname,
      ac.manufacturer || ' ' || ac.model AS aircraft_fullname,
      st.gate,
      st.check_in,
      st.takeoff,
      st.arrival,
      f.from_airport,
      f.to_airport
    FROM flight f
      JOIN aircraft ac ON f.aircraft_id = ac.id
      JOIN schedule s ON f.id = s.flight
      JOIN status st ON s.id = st.id
    WHERE
      s.departure >= departure_from AND s.departure <= departure_to;
  RETURN cur_status_summary;
END;
$$ LANGUAGE plpgsql;
