CREATE OR REPLACE FUNCTION search_flights_by_text (
  cur_flight_info REFCURSOR,
  search_text VARCHAR DEFAULT ''
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_flight_info FOR
    SELECT
--      f.airline_code || '-' || f.flight_number::text AS flight_name,
      f.flight_number,
      f.airline_code,
    --  a.name AS airline_name,
    --  a.website AS airline_website,
      ac.model AS aircraft_model,
      s.departure,
    --  st.gate,
    --  st.check_in,
    --  st.takeoff,
    --  st.arrival,
    --  from_a.name AS from_airport_name,
      from_a.iata_code AS from_airport_iata_code,
    --  to_a.name AS to_airport_name,
      to_a.iata_code AS to_airport_iata_code,
      from_c.name AS from_city_name,
      to_c.name AS to_city_name
    FROM flight f
      JOIN airline a ON f.airline_code = a.iata_code
      JOIN aircraft ac ON f.aircraft_id = ac.id
      JOIN schedule s ON f.id = s.flight
      --JOIN status st ON s.id = st.id
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
      OR to_c.name ILIKE '%' || search_text || '%';
  RETURN cur_flight_info;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_flights_by_date (
  cur_flight_info REFCURSOR,
  departure_from TIMESTAMP,
  departure_to TIMESTAMP
) RETURNS REFCURSOR AS $$
BEGIN
  OPEN cur_flight_info FOR
    SELECT
      f.flight_number,
      f.airline_code,
    --  a.name AS airline_name,
    --  a.website AS airline_website,
      ac.model AS aircraft_model,
      s.departure,
    --  st.gate,
    --  st.check_in,
    --  st.takeoff,
    --  st.arrival,
    --  from_a.name AS from_airport_name,
      from_a.iata_code AS from_airport_iata_code,
    --  to_a.name AS to_airport_name,
      to_a.iata_code AS to_airport_iata_code,
      from_c.name AS from_city_name,
      to_c.name AS to_city_name
    FROM
      flight f
      JOIN airline a ON f.airline_code = a.iata_code
      JOIN aircraft ac ON f.aircraft_id = ac.id
      JOIN schedule s ON f.id = s.flight
    --JOIN status st ON s.id = st.id
      JOIN airport from_a ON f.from_airport = from_a.iata_code
      JOIN airport to_a ON f.to_airport = to_a.iata_code
      JOIN city from_c ON from_a.city_id = from_c.id
      JOIN city to_c ON to_a.city_id = to_c.id
    WHERE
      f.departure >= departure_from AND f.departure <= departure_to;
  RETURN cur_flight_info;
END;
$$ LANGUAGE plpgsql;

