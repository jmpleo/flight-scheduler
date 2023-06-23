import socket
from socket import AF_INET, SOCK_STREAM
from threading import Thread
from model import Model


class Server:
    def __init__(self, host: str, port: int) -> None:
        self.host = host
        self.port = port
        self.model = Model()

    def start(self) -> None:
        self.sock = socket.socket(AF_INET, SOCK_STREAM)
        self.sock.bind((self.host, self.port))
        self.sock.listen(5)
        while True:
            client_sock, client_addr = self.sock.accept()
            t = Thread(target=self.handle_client, args=(client_sock,))
            t.start()

    def handle_client(self, sock: socket.socket) -> None:
        try:
            request = sock.recv(1024).decode('utf-8')
            sock.send(self.model.response(request).encode('utf-8'))
        except Exception as e:
            print(e)
        finally:
            sock.close()

if __name__ == '__main__':
    server = Server('localhost', 8889)
    server.start()
