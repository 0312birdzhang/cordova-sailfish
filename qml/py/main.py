import http.server
import pyotherside
import os
import socket
import time
import random


def randomport():
    port = 9527
    pflag = scan(port)
    while (pflag):
        port = random.randint(9000, 50000)
        pflag = scan(port)
    return port


def start_server(port, bind="", cgi=True):
    if cgi == True:
        http.server.test(
            HandlerClass=http.server.CGIHTTPRequestHandler, port=port, bind=bind)
    else:
        http.server.test(
            HandlerClass=http.server.SimpleHTTPRequestHandler, port=port, bind=bind)


def scan(port):
    sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sk.settimeout(3)
    flag = False
    try:
        sk.connect(('127.0.0.1', port))
        flag = True
    except Exception:
        flag = False
    sk.close()
    return flag


def start(wwwdir):
    if wwwdir.startswith("file://"):
        wwwdir = wwwdir[len("file://"):]
    os.chdir(wwwdir)
    startport = randomport()
    pyotherside.send("usedPort", startport)
    start_server(startport)


def scanPort(port):
    sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sk.settimeout(3)
    flag = False
    while(not flag):
        try:
            sk.connect(('127.0.0.1', int(port)))
            flag = True
        except Exception:
            flag = False
        time.sleep(1)
    sk.close()
    pyotherside.send("started")
