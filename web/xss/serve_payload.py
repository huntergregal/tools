#!/usr/bin/env python3
import http.server as SimpleHTTPServer
import socketserver as SocketServer
from base64 import b64decode
import sys

class GetHandler(
        SimpleHTTPServer.SimpleHTTPRequestHandler
        ):

    def do_GET(self):
        print('-------HEADERS----------')
        print(self.headers)
        print('---------PAYLOAD---------')
        try:
            print(b64decode(self.path[1:]))
        except:
            print('Bad base64')
        print('-------------------------')
        SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)


if __name__ == '__main__':
    if len(sys.argv) == 2:
        port = sys.argv[1]
    else:
        port = 8080
    Handler = GetHandler
    httpd = SocketServer.TCPServer(("", int(port)), Handler)
    print(f'[+] Server started on port {port}')
    httpd.serve_forever()


