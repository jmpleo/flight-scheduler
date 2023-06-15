CREATE DATABASE flight_scheduler;

\c flight_scheduler;

CREATE TABLE city (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE airport (
  iata_code CHAR(3) PRIMARY KEY NOT NULL,
  name VARCHAR(50) NOT NULL,
  city_id INT NOT NULL REFERENCES city(id)
);

CREATE TABLE airline (
  iata_code CHAR(2) PRIMARY KEY NOT NULL,
  name VARCHAR(50) NOT NULL,
  website VARCHAR(50)
);

CREATE TABLE aircraft (
  id SERIAL PRIMARY KEY,
  model VARCHAR(50) NOT NULL
);

CREATE TABLE flight (
  id SERIAL PRIMARY KEY,
  flight_number INT NOT NULL,
  aircraft_id INT NOT NULL REFERENCES aircraft(id),
  airline_code CHAR(2) NOT NULL REFERENCES airline(iata_code),
  to_airport CHAR(3) NOT NULL REFERENCES airport(iata_code),
  from_airport CHAR(3) NOT NULL REFERENCES airport(iata_code)
);

CREATE TABLE schedule (
  id SERIAL PRIMARY KEY,
  flight INT NOT NULL REFERENCES flight(id),
  departure TIMESTAMP
);

CREATE TABLE status (
  id INT PRIMARY KEY NOT NULL REFERENCES schedule(id),
  gate INT,
  check_in INT,
  takeoff TIMESTAMP,
  arrival TIMESTAMP
);

CREATE UNIQUE INDEX ON city (name);
CREATE UNIQUE INDEX ON airport (name);
CREATE UNIQUE INDEX ON airline (name);
CREATE UNIQUE INDEX ON airline (website);
CREATE UNIQUE INDEX ON flight (airline_code, flight_number);
