#!/usr/bin/env python
# encoding: utf-8

import socket
import sys
import tempfile
import time
import subprocess
import os

# function to get free port from ycmd
def GetUnusedLocalhostPort():
  sock = socket.socket()
  # This tells the OS to give us any free port in the range [1024 - 65535]
  sock.bind(('', 0))
  port = sock.getsockname()[1]
  sock.close()
  return port

SERVER = ('127.0.0.1', GetUnusedLocalhostPort())

# A wrapper for subprocess.Popen that works around a Popen bug on Windows.
def SafePopen(args, **kwargs):
    if kwargs.get('stdin') is None:
        kwargs['stdin'] = subprocess.PIPE if sys.platform == 'win32' else None

    return subprocess.Popen(args, **kwargs)

class JavaviBridge():

    pythonVersion = sys.version_info.major
    sock = None
    popen = None
    logfile = None

    def setupServer(self, javabin, args, classpath):
        is_win = sys.platform == 'win32'
        separator = (';' if is_win else ':')
        fileSeparator = ('\\' if is_win else '/')

        classpathset = set(classpath.split(separator))

        environ = os.environ.copy()
        if 'CLASSPATH' in environ:
            classpathset.union(environ['CLASSPATH'].split(separator))

        environ['CLASSPATH'] = separator.join(classpathset)

        if vim.eval('get(g:, "JavaComplete_JavaviLogLevel", 0)') != 0:
            defaulttmp = tempfile.gettempdir() + fileSeparator + 'javavi_log'
            logdir = vim.eval(
                "empty(g:JavaComplete_JavaviLogDirectory) ? '%s' : g:JavaComplete_JavaviLogDirectory" 
                % defaulttmp)
            if not os.path.isdir(logdir):
                os.mkdir(logdir)
            self.logfile = open("%s%s%s" % (
                    logdir, fileSeparator, "javavi_stdout.log"), 
                "a")
            output = self.logfile
        else:
            output = subprocess.PIPE

        args = [javabin] + args + ['-D', str(SERVER[1])]
        if is_win and vim.eval('has("gui_running")'):
            info = subprocess.STARTUPINFO()
            info.dwFlags = 1
            info.wShowWindow = 0
            self.popen = SafePopen(args, env=environ, stdout = output, stderr = output, startupinfo = info)
        else:
            self.popen = SafePopen(args, env=environ, stdout = output, stderr = output)

    def pid(self):
        return self.popen.pid

    def port(self):
        return SERVER[1]

    def poll(self):
        if self.popen:
            return self.popen.poll() is None
        else:
            return 0

    def terminateServer(self):
        if self.popen:
            self.popen.terminate()
            self.popen.wait()

        if self.logfile:
            self.logfile.close()

    def makeSocket(self):
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        except socket.error as msg:
            self.sock = None

        try:
            self.sock.connect(SERVER)
            time.sleep(.1)
        except socket.error as msg:
            self.sock.close()
            self.sock = None

        if self.sock is None:
            print('could not open socket, try again')
            return

        self.sock.setblocking(0)


    def send(self, data):
        if self.sock is None:
            self.makeSocket()
            if self.sock is None:
                return ''

        if self.pythonVersion == 3:
            self.sock.sendall((str(data) + '\n').encode('UTF-8'))
        else:
            self.sock.sendall((data.decode('UTF-8') + '\n').encode('UTF-8'))

        totalData = []
        while 1:
            try:
                data = self.sock.recv(4096)
                if not data or len(data) == 0:
                    break

                totalData.append(data.decode('UTF-8'))
                time.sleep(0.0001)
            except:
                if totalData: break

        self.sock.close()
        self.sock = None
        return ''.join(totalData)
