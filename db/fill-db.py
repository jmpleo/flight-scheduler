import csv
import psycopg2
import random
from datetime import timedelta, datetime


def insert_airlines(cur):
    print('airlines: insterting...', end='')
    with open('data/airlines.csv', mode='r') as airlines:
        airlinesReader = csv.DictReader(airlines)
        for row in airlinesReader:
            cur.execute(
                "INSERT INTO airline (iata_code, name) VALUES (%s, %s)",
                (row['iata_code'], row['name'])
            )
    print('\r' + ' '*50, '\rairlines: comleted')


def insert_cities(cur):
    print('cities: insterting...', end='')
    with open('data/cities.csv', mode='r') as cities:
        citiesReader = csv.DictReader(cities)
        for row in citiesReader:
            cur.execute(
                "INSERT INTO city (name) VALUES (%s)",
                (row['name'],)
            )
    print('\r' + ' '*50, '\rcities: comleted')


def insert_airports(cur):
    print('airport: insterting...', end='')
    with open('data/airports.csv', mode='r') as airports:
        airportReader = csv.DictReader(airports)
        for row in airportReader:
            cur.execute(
                "INSERT INTO airport (iata_code, name, city_id) \
                VALUES (%s,%s,(SELECT id FROM city WHERE name=%s LIMIT 1))",
                (row['iata_code'], row['name'], row['city'])
            )
    print('\r' + ' '*50, '\rairport: comleted')


def insert_aircrafts(cur):
    print('aircraft: insterting...', end='')
    with open('data/aircraft.csv', mode='r') as aircraft:
        aircraftReader = csv.DictReader(aircraft)
        for row in aircraftReader:
            cur.execute(
                "INSERT INTO aircraft (model) VALUES (%s)",
                (row['model'],)
            )
    print('\r' + ' '*50, '\raircraft: comleted')


def generate_random_flight(cur, seed):
    flight = {}

    cur.execute("SELECT iata_code FROM airline ORDER BY RANDOM() LIMIT 1")
    flight['airline'] = cur.fetchone()[0]

    cur.execute("SELECT iata_code FROM airport ORDER BY RANDOM() LIMIT 1")
    flight['to_airport'] = cur.fetchone()[0]

    cur.execute(
        "SELECT iata_code FROM airport"
        " WHERE iata_code <> %s ORDER BY RANDOM() LIMIT 1",
        (flight['to_airport'],)
    )
    flight['from_airport'] = cur.fetchone()[0]

    cur.execute( "SELECT id FROM aircraft ORDER BY RANDOM() LIMIT 1")
    flight['aircraft'] = int(cur.fetchone()[0])

    random.seed(seed)
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
        print(f"\rflight: {i}/{count} insterting...", end='')
        insert_flight(cur, generate_random_flight(cur, seed=i))

    print(f"\rflight: completed {count} records")


def insert_schedule(cur, count):
    cur.execute("SELECT * FROM flight ORDER BY RANDOM() LIMIT %s", (count,))
    flights = cur.fetchall()
    departure = datetime(2023, 8, 1)
    for i in range(count):
        print(f"\rschedule: {i}/{count} insterting...", end='')
        departure += timedelta(minutes=random.randint(10, 60))
        cur.execute(
            "INSERT INTO schedule (flight, departure) VALUES (%s, %s)",
            (random.choice(flights)[0], departure)
        )
    print(f"\rschedule: completed {count} records")


conn = psycopg2.connect(
    host="localhost",
    database="flight_scheduler",
    user="j",
    password="41236214169"
)

cur = conn.cursor()

print("How many flights? : ", end='')
flights_count = int(input())

print("How many schedule recors? : ", end='')
schedules_count = int(input())

insert_aircrafts(cur)
insert_cities(cur)
insert_airports(cur)
insert_airlines(cur)
insert_random_flight(cur, flights_count)
insert_schedule(cur, schedules_count)

conn.commit()

cur.close()
conn.close()
