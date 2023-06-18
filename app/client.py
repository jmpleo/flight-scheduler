import socket
from socket import AF_INET, SOCK_STREAM


class Client:
    def __init__(self, host, port):
        self.host = host
        self.port = port

    def send_request(self, request):
        sock = socket.socket(AF_INET, SOCK_STREAM)
        sock.connect((self.host, self.port))
        sock.send(request.encode('utf-8'))
        response = sock.recv(1024).decode('utf-8')
        sock.close()
        return response


if __name__ == '__main__':
    client = Client('localhost', 8888)
    while True:
        request = input('> ')
        if not request:
            break
        response = client.send_request(request)
        print(response)
