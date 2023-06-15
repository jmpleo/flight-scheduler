import csv

import mariadb
import sys
import random


def insert_contries(cur):
    with open('data/simple/simple-countries.csv', mode='r') as countries:
        countryReader = csv.DictReader(countries)
        for row in countryReader:
            cur.execute(
                "INSERT IGNORE INTO country"
                    "(name, iso2)"
                "VALUES (?,?)", (row['name'], row['iso2']))


def insert_airlines(cur):
    with open('data/simple/simple-airlines.csv', mode='r') as airlines:
        airlinesReader = csv.DictReader(airlines)
        for row in airlinesReader:
            cur.execute(
                "INSERT IGNORE INTO airline"
                    "(iata_code, name)"
                "VALUES (?,?)", (row['iata_code'], row['name']))


def insert_cities(cur):
    with open('data/simple/simple-cities.csv', mode='r') as cities:
        citiesReader = csv.DictReader(cities)
        for row in citiesReader:
            cur.execute(
                "INSERT IGNORE INTO city"
                    "(name, country_code)"
                "VALUES"
                    "(?,?)", (row['name'], row['country_code']))


def insert_airports(cur):
    with open('data/simple/simple-airports.csv', mode='r') as airports:
        airportReader = csv.DictReader(airports)
        for row in airportReader:
            cur.execute(
                "INSERT IGNORE INTO airport"
                    "(iata_code, name, city_id)"
                "VALUES"
                    "(?,?,(SELECT id FROM city WHERE name=? LIMIT 1))",
                    (row['iata_code'], row['name'], row['city']))


def insert_aircrafts(cur):
    with open('data/simple/simple-aircraft.csv', mode='r') as aircraft:
        aircraftReader = csv.DictReader(aircraft)
        for row in aircraftReader:
            cur.execute(
                "INSERT IGNORE INTO aircraft_manufacturer"
                    "(name)"
                " VALUE (?)", (row['manufacturer'],))
            cur.execute(
                "INSERT IGNORE INTO aircraft"
                    " (model, manufacturer_id)"
                " VALUES (?, (SELECT id"
                    " FROM aircraft_manufacturer"
                    " WHERE name=?))", (row['model'], row['manufacturer']))

def generate_random_flight(cur, seed):
    cur.execute(
        "SELECT iata_code FROM airline ORDER BY RAND() LIMIT 1"
    )
    flight = {}
    flight['airline'] = cur.fetchone()[0]
    cur.execute(
        "SELECT iata_code FROM airport ORDER BY RAND() LIMIT 1"
    )

    flight['from_airport'] = cur.fetchone()[0]
    flight['to_airport'] = "MVO"

    cur.execute(
        "SELECT id FROM aircraft ORDER BY RAND() LIMIT 1"
    )
    random.seed(seed)
    flight['aircraft'] = int(cur.fetchone()[0])
    flight['number']   = random.randint(1000,9999)
    flight['time']     = random.randint(60, 1000)
    return flight

def insert_details(cur, flight_details):
    cur.execute(
            "INSERT INTO flight_details"
                "(airline_code,"
                "flight_number,"
                "aircraft_id,"
                "to_airport_code,"
                "from_airport_code,"
                "flight_time)"
            "VALUES"
                "(?,?,?,?,?,?)",
                (flight_details['airline'],
                 flight_details['number'],
                 flight_details['aircraft'],
                 flight_details['to_airport'],
                 flight_details['from_airport'],
                 flight_details['time'])
        )

def insert_random_details(cur, count):
    for i in range(count):
        insert_details(cur, generate_random_flight(cur,seed=i))

def insert_flight_schedule(cur, count):
    for i in range(count):
        cur.execute("insert into flight\
                    (id, departure)\
                    value\
                    ((select id from flight_details order by rand() limit 1),\
                     date_add((select departure from flight f order by f.departure desc limit 1), interval 30 minute))")

try:
    conn = mariadb.connect(
        user="root",
        password="4169",
        host="127.0.0.1",
        port=3306,
        database="airport_schedule"
    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)

conn.autocommit = True
cur = conn.cursor()

try:
#    insert_contries (cur)
#    insert_cities   (cur)
#    insert_airlines (cur)
#    insert_aircrafts(cur)
#    insert_airports (cur)
#    insert_random_details(cur, 1000)
    insert_flight_schedule(cur, 1000)

except mariadb.Error as e:
    print(f"Error: {e}")
conn.close()
