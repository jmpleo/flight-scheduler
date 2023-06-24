import psycopg2

import json

from config import db_cred
from validator import Validator
from datetime import datetime


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(**db_cred)
        self.vald = Validator()

    def response(self, request: str):
        if self.vald.validate_json(request, "request") == False:
            raise Exception('bad request fromat')

    def search_records(self,
                       search_text: str = None,
                       date_interval: tuple = None,
                       count: int = None) -> dict:
        with conn.cursor() as cur:
            cur.callproc(,)

    def set_data(self, key, value):
        self.data[key] = value

    def get_data(self):
        return json.dumps(self.data).encode()



