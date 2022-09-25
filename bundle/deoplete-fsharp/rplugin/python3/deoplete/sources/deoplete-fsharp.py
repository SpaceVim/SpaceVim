# ===========================================================================
#  FILE    : deoplete-fsharp.py
#  AUTHOR  : callmekohei <callmekohei at gmail.com>
#  License : MIT license
# ===========================================================================

import atexit
import base64
import functools
import os
import queue
import re
import subprocess
import threading
import time

try:
    import ujson as json
except ImportError:
    import json

from deoplete.source.base import Base
from deoplete.util import getlines, expand
from deoplete.util import debug


class Source(Base):

    def __init__(self, vim):
        super().__init__(vim)
        self.name      = 'fs'
        self.mark      = '[fs]'
        self.filetypes = ['fsharp']
        self.rank      = 900


    def on_init(self, context):

        ### input pattern
        dotHints           = [ r"(\(|<|[a-zA-Z]|\"|\[)*(?<=(\)|>|[a-zA-Z0-9]|\"|\]))\." ]
        oneWordHints       = [ r"^[a-zA-Z]$", "\s*[a-zA-Z]$", "typeof\<[a-zA-Z]$", "(\(\))[a-zA-Z]$", "(\<|\>)[a-zA-Z]$", "(\[|\])[a-zA-Z]$"  ]
        attributeHints     = [ r"\[<[a-zA-Z]*" ]
        self.input_pattern = '|'.join( dotHints + oneWordHints + attributeHints )

        ### initialize of deopletefs
        self.standby  = False
        self.filePath = expand( self.vim.eval( "substitute( expand('%:p') , '\#', '\\#' , 'g' )" ) )
        fsc_path      = expand( re.split('rplugin', __file__)[0] + expand('bin/deopletefs.exe') )

        post_data = {
              "Row"      : -9999 # dummy row
            , "Col"      : 1
            , "Line"     : ''
            , "FilePath" : self.filePath
            , "Source"   : '\n'.join( getlines( self.vim ) )
            , "Init"     : 'true'
        }

        self.util = Util(fsc_path, 20)
        self.util.send(json.dumps(post_data))

        start = time.time()
        self.vim.command("echo '*** deopletefs initializing... ***'")

        if str(self.util.read()) != '':
            self.standby = True
            elapsed_time = time.time() - start
            self.vim.command("echo '*** finish initialize! *** ( time : " + str(round(elapsed_time,6)) + " s )'")
        else:
            elapsed_time = time.time() - start
            self.vim.command("echo '*** Sorry! Please Re-open file! *** ( time : " + str(round(elapsed_time,6)) + " s )'")


    def get_complete_position(self, context):
        m = re.search( r'\w*$', context['input'] )
        return m.start() if m else -1


    def gather_candidates(self, context):

        try:

            if self.standby == False:
                return [ '=== can not initialize deopletefs ===' ]
            else:
                post_data = {
                      "Row"      : context['position'][1]
                    , "Col"      : context['complete_position'] - 1
                    , "Line"     : context['input']
                    , "FilePath" : self.filePath
                    , "Source"   : '\n'.join( getlines( self.vim ) )
                    , "Init"     : 'false'
                }

                self.util.send(json.dumps(post_data))
                s = (self.util.read())[0]
                s = base64.b64decode(s)
                s = s.decode(encoding='utf-8')
                lst = s.split("\n")

                return [
                    {
                          "word": json_data['word']
                        , "info": '\n'.join( functools.reduce ( lambda a , b : a + b , json_data['info'] ) )
                    }
                    for json_data in [ json.loads(s) for s in lst ]
                ]

        except Exception as e:
            return [ str(e) ]


class Util():

    def __init__(self, exe_path, timeOut_s):
        self.exe_path  = exe_path
        self.timeOut_s = timeOut_s
        self.event     = threading.Event()
        self.lines     = queue.Queue()

        ### launch deopletefs
        if os.name == 'nt':
            command = [ self.exe_path ]
        elif os.name == 'posix':
            command = [ 'mono', self.exe_path ]
        opts         = { 'stdin': subprocess.PIPE, 'stdout': subprocess.PIPE, 'stderr': subprocess.PIPE, 'universal_newlines': True }
        self.process = subprocess.Popen( command , **opts )
        atexit.register(lambda: self.process.kill())

        ### create worker thread
        self.worker        = threading.Thread(target=self.work, args=(self,))
        self.worker.daemon = True
        self.worker.start()


    def work(self,_):
        while True:
            data = self.process.stdout.readline()
            self.lines.put(data, True)
            self.event.set()


    def send(self,txt):
        self.event.clear()
        self.process.stdin.write(txt + '\n')
        self.process.stdin.flush()


    def read(self):
        self.event.wait(self.timeOut_s)

        list = []
        while True:
            if self.lines.empty():
                break
            else:
                list.append( self.lines.get_nowait() )

        return list
