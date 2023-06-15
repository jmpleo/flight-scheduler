import csv
import psycopg2
import random
from datetime import timedelta, datetime


def insert_airlines(cur):
    with open('data/airlines.csv', mode='r') as airlines:
        airlinesReader = csv.DictReader(airlines)
        for row in airlinesReader:
            cur.execute(
                "INSERT INTO airline (iata_code, name) VALUES (%s, %s)",
                (row['iata_code'], row['name'])
            )


def insert_cities(cur):
    with open('data/cities.csv', mode='r') as cities:
        citiesReader = csv.DictReader(cities)
        for row in citiesReader:
            cur.execute(
                "INSERT INTO city (name) VALUES (%s)",
                (row['name'],)
            )


def insert_airports(cur):
    with open('data/airports.csv', mode='r') as airports:
        airportReader = csv.DictReader(airports)
        for row in airportReader:
            cur.execute(
                "INSERT INTO airport (iata_code, name, city_id) \
                VALUES (%s,%s,(SELECT id FROM city WHERE name=%s LIMIT 1))",
                (row['iata_code'], row['name'], row['city'])
            )


def insert_aircrafts(cur):
    with open('data/aircraft.csv', mode='r') as aircraft:
        aircraftReader = csv.DictReader(aircraft)
        for row in aircraftReader:
            cur.execute(
                "INSERT INTO aircraft (model) VALUES (%s)", (row['model'],)
            )


def generate_random_flight(cur, seed):
    cur.execute(
        "SELECT iata_code FROM airline ORDER BY RANDOM() LIMIT 1"
    )
    flight = {}
    flight['airline'] = cur.fetchone()[0]
    cur.execute(
        "SELECT iata_code FROM airport ORDER BY RANDOM() LIMIT 1"
    )
    flight['to_airport'] = cur.fetchone()[0]
    flight['from_airport'] = "MVO"
    cur.execute(
        "SELECT id FROM aircraft ORDER BY RANDOM() LIMIT 1"
    )
    random.seed(seed)
    flight['aircraft'] = int(cur.fetchone()[0])
    flight['number'] = random.randint(1000, 9999)
    return flight


def insert_flight(cur, flight):
    cur.execute(
        "INSERT INTO flight (\
            airline_code, \
            flight_number,\
            aircraft_id,  \
            to_airport,   \
            from_airport  \
        ) VALUES (%s,%s,%s,%s,%s)\
        ON CONFLICT (airline_code, flight_number) DO NOTHING", (
            flight['airline'],
            flight['number'],
            flight['aircraft'],
            flight['to_airport'],
            flight['from_airport']
        )
    )


def insert_random_flight(cur, count):
    for i in range(count):
        insert_flight(cur, generate_random_flight(cur, seed=i))


def insert_schedule(cur, count):
    cur.execute("SELECT * FROM flight ORDER BY RANDOM() LIMIT %s", (count,))
    flights = cur.fetchall()
    departure = datetime(2023, 8, 1)
    for _ in range(count):
        departure += timedelta(minutes=random.randint(10, 60))
        cur.execute(
            "INSERT INTO schedule (flight, departure) VALUES (%s, %s)",
            (random.choice(flights)[0], departure)
        )


conn = psycopg2.connect(
    host="localhost",
    database="flight_scheduler",
    user="j",
    password="41236214169"
)

cur = conn.cursor()

insert_aircrafts(cur)
insert_cities(cur)
insert_airports(cur)
insert_airlines(cur)
insert_random_flight(cur, 10000)
insert_schedule(cur, 50000)

conn.commit()

cur.close()
conn.close()
