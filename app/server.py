import socket
from socket import AF_INET, SOCK_STREAM

from threading import Thread

from controller import Controller


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
