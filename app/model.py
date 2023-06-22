import psycopg2
from config import db_cred
import json

class Model:
    def __init__(self):
        self.data = {}

    def set_data(self, key, value):
        self.data[key] = value

    def get_data(self):
        return json.dumps(self.data).encode()


