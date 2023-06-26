import psycopg2

import json

from config import db_cred
from validator import Validator
from datetime import datetime


class Model:
    def __init__(self):
        self.conn = psycopg2.connect(**db_cred)
        self.vald = Validator()

    def response(self,
        request: str
    ) -> str:
        if self.vald.validate_json(request, "request") == False:
            raise Exception('bad request fromat')


    def search_records(self,
        func_name: str,
        param: list,
        count: int
    ):
        with self.conn.cursor() as cur:
            cur.callproc(func_name, ['cur'] + param)
            while True:
                cur.execute("fetch %s from cur", (count,))
                if cur.rowcount == 0:
                    break
                yield cur.fetchall()

    def set_data(self, key, value):
        self.data[key] = value

    def get_data(self):
        return json.dumps(self.data).encode()



