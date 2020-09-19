#!/usr/bin/env python

from __future__ import print_function

import warnings
import sys


def main(argv):
    if len(argv) != 2:
        exit(64)

    with open(argv[1]) as fp:
        contents = fp.read()

    exitcode = 0
    syntax_err = None
    with warnings.catch_warnings(record=True) as wc:
        try:
            compile(contents, argv[1], "exec", 0, 1)
        except SyntaxError as exc:
            syntax_err = exc

    # Output any warnings (caught during `compile`).
    # This could/should maybe only handle SyntaxWarnings?
    for wm in wc:
        print(
            "%s:%s: W: %s (%s)"
            % (wm.filename, wm.lineno, wm.message, wm.category.__name__)
        )
        exitcode |= 2

    # Output any SyntaxError.
    if syntax_err:
        print(
            "%s:%s:%s: E: %s"
            % (
                syntax_err.filename,
                syntax_err.lineno,
                syntax_err.offset,
                syntax_err.msg,
            )
        )
        exitcode |= 1
    return exitcode


if __name__ == "__main__":
    sys.exit(main(sys.argv))
