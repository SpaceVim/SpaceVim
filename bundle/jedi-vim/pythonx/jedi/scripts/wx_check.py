#! /usr/bin/env python
"""
Depends: ``objgraph`` (third party Python library)

``wx._core`` is a very nice module to test Jedi's speed and memory performance
on big Python modules. Its size is ~16kLOC (one file). It also seems to look
like a typical big Python modules. A mix between a lot of different Python
things.

You can view a markup version of it here:
https://github.com/wxWidgets/wxPython/blob/master/src/gtk/_core.py
"""

import resource
import time
import sys
try:
    import urllib.request as urllib2
except ImportError:
    import urllib2
import gc
from os.path import abspath, dirname

import objgraph

sys.path.insert(0, dirname(dirname(abspath(__file__))))
import jedi


def process_memory():
    """
    In kB according to
    https://stackoverflow.com/questions/938733/total-memory-used-by-python-process
    """
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss


uri = 'https://raw.githubusercontent.com/wxWidgets/wxPython/master/src/gtk/_core.py'

wx_core = urllib2.urlopen(uri).read()


def run():
    start = time.time()
    print('Process Memory before: %skB' % process_memory())
    # After this the module should be cached.
    # Need to invent a path so that it's really cached.
    jedi.Script(wx_core, path='foobar.py').complete()

    gc.collect()  # make sure that it's all fair and the gc did its job.
    print('Process Memory after: %skB' % process_memory())

    print(objgraph.most_common_types(limit=50))
    print('\nIt took %s seconds to parse the file.' % (time.time() - start))


print('First pass')
run()
print('\nSecond pass')
run()
print('\nThird pass')
run()
