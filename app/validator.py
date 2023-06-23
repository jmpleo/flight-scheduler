import re
import json
import jsonschema
from datetime import datetime


class Validator:
    def __init__(self):
        pass

    def validate_json_str(self, json_str, schema):
        try:
            json.loads(json_str)
            jsonschema.validate(instance=json.loads(json_str), schema=schema)
            return True
        except (json.JSONDecodeError, jsonschema.exceptions.ValidationError):
            return False

    def validate_username(self, username):
        if not re.match("^[a-zA-Z0-9]+$", username):
            return False
        return True

    def validate_password(self, password):
        if len(password) < 8:
            return False
        if not re.search("\d", password):
            return False
        if not re.search("[A-Z]", password):
            return False
        if not re.search("[a-z]", password):
            return False
        return True

    def validate_email(self, email):
        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            return False
        return True

    def validate_date(self, date_str, date_format='%Y-%m-%d'):
        try:
            datetime.strptime(date_str, date_format)
            return True
        except ValueError:
            return False

    def validate_list_item(self, item, valid_items):
        if item not in valid_items:
            return False
        return True
