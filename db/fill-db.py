import csv
import argparse
import psycopg2
import random
from datetime import timedelta, datetime

def insert_airlines(cur):
    print('airlines: insterting...', end='')
    with open('data/airlines.csv', mode='r') as airlines:
        airlinesReader = csv.DictReader(airlines)
        for row in airlinesReader:
            cur.callproc('insert_airline', (row['iata_code'], row['name']))
#            cur.execute(
#                "INSERT INTO airline (iata_code, name) VALUES (%s, %s)",
#                (row['iata_code'], row['name'])
#            )
    print('comleted')


def insert_cities(cur):
    print('cities: insterting...', end='')
    with open('data/cities.csv', mode='r') as cities:
        citiesReader = csv.DictReader(cities)
        for row in citiesReader:
            cur.callproc('insert_city', (row['name'],))
#            cur.execute(
#                "INSERT INTO city (name) VALUES (%s)",
#                (row['name'],)
#            )
    print('comleted')


def insert_airports(cur):
    print('airport: insterting...', end='')
    with open('data/airports.csv', mode='r') as airports:
        airportReader = csv.DictReader(airports)
        for row in airportReader:
            cur.callproc('insert_airport', (row['iata_code'], row['name'], row['city']))
#            cur.execute(
#                "INSERT INTO airport (iata_code, name, city_id) \
#                VALUES (%s,%s,(SELECT id FROM city WHERE name=%s LIMIT 1))",
#                (row['iata_code'], row['name'], row['city'])
#            )
    print('comleted')


def insert_aircrafts(cur):
    print('aircraft: insterting...', end='')
    with open('data/aircraft.csv', mode='r') as aircraft:
        aircraftReader = csv.DictReader(aircraft)
        for row in aircraftReader:
            cur.callproc('insert_aircraft', (row['model'], row['manufacturer']))
#            cur.execute(
#                "INSERT INTO aircraft (model, manufacturer) VALUES (%s,%s)",
#                (row['model'], row['manufacturer'])
#            )
    print('comleted')


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
    cur.callproc('insert_flight_quiet', (
            flight['number'],
            flight['aircraft'],
            flight['airline'],
            flight['to_airport'],
            flight['from_airport']
        )
    )
#    cur.execute(
#        "INSERT INTO flight (\
#            airline_code, \
#            flight_number,\
#            aircraft_id,  \
#            to_airport,   \
#            from_airport  \
#        ) VALUES (%s,%s,%s,%s,%s)\
#        ON CONFLICT (airline_code, flight_number) DO NOTHING", (
#            flight['airline'],
#            flight['number'],
#            flight['aircraft'],
#            flight['to_airport'],
#            flight['from_airport']
#        )
#    )


def insert_random_flight(cur, count):
    for i in range(count):
        print(f"\rflight: {i}/{count} insterting...", end='')
        insert_flight(cur, generate_random_flight(cur, seed=i))

    print("completed")


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
    print("completed")


parser = argparse.ArgumentParser(description='filling data into db')
parser.add_argument('flights', nargs='?', type=int, help='Number of flights to insert')
parser.add_argument('schedules', nargs='?', type=int, help='Number of schedule records to insert')
parser.add_argument('--flights', dest='flights_named', type=int, help='Number of flights to insert')
parser.add_argument('--schedules', dest='schedules_named', type=int, help='Number of schedule records to insert')
args = parser.parse_args()

flights_count = args.flights or args.flights_named
schedules_count = args.schedules or args.schedules_named

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
insert_random_flight(cur, flights_count)
insert_schedule(cur, schedules_count)

conn.commit()

cur.close()
conn.close()
