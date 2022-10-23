#! /usr/bin/env python
"""
This is a convenience script to test the speed and memory usage of Jedi with
large libraries.

Each library is preloaded by jedi, recording the time and memory consumed by
each operation.

You can provide additional libraries via command line arguments.

Note: This requires the psutil library, available on PyPI.
"""
import time
import sys
import os
import psutil
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__) + '/..'))
import jedi


def used_memory():
    """Return the total MB of System Memory in use."""
    return psutil.virtual_memory().used / 2 ** 20


def profile_preload(mod):
    """Preload a module into Jedi, recording time and memory used."""
    base = used_memory()
    t0 = time.time()
    jedi.preload_module(mod)
    elapsed = time.time() - t0
    used = used_memory() - base
    return elapsed, used


def main(mods):
    """Preload the modules, and print the time and memory used."""
    t0 = time.time()
    baseline = used_memory()
    print('Time (s) | Mem (MB) | Package')
    print('------------------------------')
    for mod in mods:
        elapsed, used = profile_preload(mod)
        if used > 0:
            print('%8.2f | %8d | %s' % (elapsed, used, mod))
    print('------------------------------')
    elapsed = time.time() - t0
    used = used_memory() - baseline
    print('%8.2f | %8d | %s' % (elapsed, used, 'Total'))


if __name__ == '__main__':
    if sys.argv[1:]:
        mods = sys.argv[1:]
    else:
        mods = ['re', 'numpy', 'scipy', 'scipy.sparse', 'scipy.stats',
                'wx', 'decimal', 'PyQt4.QtGui', 'PySide.QtGui', 'Tkinter']
    main(mods)
