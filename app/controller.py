from model import Model
from view import View


class Controller:
    def __init__(self):
        self.model = Model()
        self.view = View()

    def handle_request(self, request):
        parts = request.split()
        if len(parts) == 3 and parts[0] == 'SET':
            key, value = parts[1], parts[2]
            self.model.set_data(key, value)
            self.view.display('OK')
        elif len(parts) == 2 and parts[0] == 'GET':
            key = parts[1]
            value = self.model.get_data(key)
            if value is not None:
                self.view.display(value)
            else:
                self.view.display('NOT FOUND')
        else:
            self.view.display('INVALID REQUEST')
