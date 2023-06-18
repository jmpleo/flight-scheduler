import psycopg2
from config import db_cred


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(**db_cred)
        self.cur = self.conn.cursor()

    def set_data(self, key, value):
        self.cur.execute(
            "SELECT * FROM data WHERE key = %s FOR UPDATE;", (key,)
        )
        result = self.cur.fetchone()
        if result is not None:
            self.cur.execute("UPDATE data SET value = %s WHERE key = %s;", (value, key))
        else:
            self.cur.execute("INSERT INTO data (key, value) VALUES (%s, %s);", (key, value))
        self.conn.commit()

    def set_schedule(self, flight_id, date):
        self.cur.execute(
            "INSERT INTO schedule(flight, departure) VALUES (%s,%s) "
            "ON CONFLICT (flight, departure) DO NOTHING",
            (flight_id, date)
        )

    def del_schedule(self, schedule_id):
        self.cur.execute(
            "SELECT * FROM schedule WHERE id=%s FOR UPDATE;", (schedule_id,)
        )
        result = self.cur.fetchone()
        return result.


    def get_schedule(self, schedule_id):
        self.cur.execute(
            "SELECT CONCAT(f.airline_code,'-',f.flight_number), s.departure \
             FROM schedule s    \
             LEFT JOIN flight f \
             ON s.flight = f.id \
             WHERE s.id = %s;",
            (schedule_id,)
        )
        result = self.cur.fetchone()
        return result


