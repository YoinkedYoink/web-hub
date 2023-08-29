#Much better than websocket, doesn't crash game :D

from http.server import BaseHTTPRequestHandler, HTTPServer
import hashlib
import win32api
import win32con
import threading
import time
import random


def mouseclick(other, wait):
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP,0,0,0,0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN,0,0,0,0)
    time.sleep(wait)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP,0,0,0,0)
    other[0] = True


class handler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass
    def do_GET(self):
        if self.path == "/getsettings/":
            self.send_response(200)
            message4md5 = open("Aimblox-HTTP\settings.json","r+b").read()
            message = open("Aimblox-HTTP\settings.json","r+t").read()
            md5hash = str(hashlib.md5(message4md5).hexdigest())

            self.send_header('MD5-Hash', md5hash)
            self.send_header('Content-type','application/json')
            self.end_headers()

            print(str(hashlib.md5(message4md5).hexdigest()))

            self.wfile.write(bytes(message, "utf8"))
        elif self.path == "/status/":
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()

            message = "Yes, we are live!"
            self.wfile.write(bytes(message, "utf8"))
        else:
            self.send_response(404)
            self.send_header('Content-type','text/html')
            self.end_headers()

            message = "Wrong method buddy!"
            self.wfile.write(bytes(message, "utf8"))
    def do_POST(self):
        if "mousemove" in self.path:
            try:
                XandY = self.path.split("/")
                #print("Got move mouse: "+ str(XandY[2]) +" "+ str(XandY[3]))
                X = float(XandY[2])
                Y = float(XandY[3])
                win32api.mouse_event(win32con.MOUSEEVENTF_MOVE, int(X),int(Y),0,0)

                self.send_response(200)
                self.send_header('Content-type','text/html')
                self.end_headers()
                message = "Got the request!"+ str(random.getrandbits(10))
                self.wfile.write(bytes(message, "utf8"))
            except:
                self.send_response(400)
                self.send_header('Content-type','text/html')
                self.end_headers()
                print("!!!SOMETHING WENT WRONG!!!")
                message = "!!!Something went wrong!!!"
                self.wfile.write(bytes(message, "utf8"))
        elif "/mouseclick/" in self.path:
            idk = [False]
            thread = threading.Thread(target=mouseclick, args=(idk, 0.01))
            thread.start()
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()
            message = "Clicked mouse!"
            self.wfile.write(bytes(message, "utf8"))
        else:
            self.send_response(404)
            self.send_header('Content-type','text/html')
            self.end_headers()
            message = "Post with no directory???"
            self.wfile.write(bytes(message, "utf8"))

with HTTPServer(('127.0.0.1', 6969), handler) as server:
    print("##Started Server##")
    server.serve_forever()