import psycopg2

import json

from config import db_cred
from validator import Validator


class Model:
    def __init__(self):
        self.connector = psycopg2.connect(**db_cred)
        self.validator = Validator()

    def response(request: str):
        if self.validator.validate_json_str(request) == False:
            raise Exception('bad request fromat')
        action, data = json.loads(request).split()


    def set_data(self, key, value):
        self.data[key] = value

    def get_data(self):
        return json.dumps(self.data).encode()

