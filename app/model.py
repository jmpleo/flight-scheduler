import psycopg2
from config import db_cred


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(**db_cred)
        self.cur = self.conn.cursor()

    def

