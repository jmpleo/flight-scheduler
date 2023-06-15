import socket
from threading import Thread
from socket import AF_INET, SOCK_STREAM


class Model:
    def __init__(self):
        self.data = {}

    def set_data(self, key, value):
        self.data[key] = value

    def get_data(self, key):
        return self.data.get(key)


class View:
    def display(self, message):
        print(message)


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


class Server:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.controller = Controller()

    def start(self):
        self.sock = socket.socket(AF_INET, SOCK_STREAM)
        self.sock.bind((self.host, self.port))
        self.sock.listen(5)
        while True:
            client_sock, client_addr = self.sock.accept()
            t = Thread(target=self.handle_client, args=(client_sock,))
            t.start()

    def handle_client(self, sock):
        try:
            request = sock.recv(1024).decode('utf-8')
            self.controller.handle_request(request)
            sock.send(b'OK')
        except Exception as e:
            print(e)
        finally:
            sock.close()


if __name__ == '__main__':
    server = Server('localhost', 8888)
    server.start()
