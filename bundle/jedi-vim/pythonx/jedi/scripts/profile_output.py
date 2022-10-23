#!/usr/bin/env python3.6
"""
Profile a piece of Python code with ``profile``. Tries a completion on a
certain piece of code.

Usage:
  profile.py [<code>] [-n <number>] [-d] [-o] [-s <sort>] [-i] [--precision]
  profile.py -h | --help

Options:
  -h --help     Show this screen.
  -n <number>   Number of passes before profiling [default: 1].
  -d --debug    Enable Jedi internal debugging.
  -o --omit     Omit profiler, just do a normal run.
  -i --infer    Infer types instead of completions.
  -s <sort>     Sort the profile results, e.g. cum, name [default: time].
  --precision   Makes profile time formatting more precise (nanoseconds)
"""

import time
import profile
import pstats

from docopt import docopt
import jedi


# Monkeypatch the time formatting function of profiling to make it easier to
# understand small time differences.
def f8(x):
    ret = "%7.3f " % x
    if ret == '  0.000 ':
        return "%6dµs" % (x * 1e6)
    if ret.startswith('  0.00'):
        return "%8.4f" % x
    return ret


def run(code, index, infer=False):
    start = time.time()
    script = jedi.Script(code)
    if infer:
        result = script.infer()
    else:
        result = script.complete()
    print('Used %ss for the %sth run.' % (time.time() - start, index + 1))
    return result


def main(args):
    code = args['<code>']
    infer = args['--infer']
    n = int(args['-n'])

    for i in range(n):
        run(code, i, infer=infer)

    if args['--precision']:
        pstats.f8 = f8

    jedi.set_debug_function(notices=args['--debug'])
    if args['--omit']:
        run(code, n, infer=infer)
    else:
        profile.runctx('run(code, n, infer=infer)', globals(), locals(), sort=args['-s'])


if __name__ == '__main__':
    args = docopt(__doc__)
    if args['<code>'] is None:
        args['<code>'] = 'import numpy; numpy.array([0]).'
    main(args)
