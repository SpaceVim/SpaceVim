#!/usr/bin/env python
"""
Profile a piece of Python code with ``cProfile`` that uses the diff parser.

Usage:
  profile.py <file> [-d] [-s <sort>]
  profile.py -h | --help

Options:
  -h --help     Show this screen.
  -d --debug    Enable Jedi internal debugging.
  -s <sort>     Sort the profile results, e.g. cumtime, name [default: time].
"""

import cProfile

from docopt import docopt
from jedi.parser.python import load_grammar
from jedi.parser.diff import DiffParser
from jedi.parser.python import ParserWithRecovery
from jedi.common import splitlines
import jedi


def run(parser, lines):
    diff_parser = DiffParser(parser)
    diff_parser.update(lines)
    # Make sure used_names is loaded
    parser.module.used_names


def main(args):
    if args['--debug']:
        jedi.set_debug_function(notices=True)

    with open(args['<file>']) as f:
        code = f.read()
    grammar = load_grammar()
    parser = ParserWithRecovery(grammar, code)
    # Make sure used_names is loaded
    parser.module.used_names

    code = code + '\na\n'  # Add something so the diff parser needs to run.
    lines = splitlines(code, keepends=True)
    cProfile.runctx('run(parser, lines)', globals(), locals(), sort=args['-s'])


if __name__ == '__main__':
    args = docopt(__doc__)
    main(args)
