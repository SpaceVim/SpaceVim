"""
These tests test Jedi's Parso usage. Basically there's not a lot of tests here,
because we're just checking if the API works. Bugfixes should be done in parso,
mostly.
"""

from textwrap import dedent

import pytest


@pytest.mark.parametrize(
    'code, line, column, until_line, until_column, message', [
        ('?\n', 1, 0, 1, 1, 'SyntaxError: invalid syntax'),
        ('x %% y', 1, 3, 1, 4, 'SyntaxError: invalid syntax'),
        ('"""\n\n', 1, 0, 3, 0, 'SyntaxError: EOF while scanning triple-quoted string literal'),
        ('(1, 2\n', 2, 0, 2, 0, 'SyntaxError: invalid syntax'),
        ('foo(1, 2\ndef x(): pass', 2, 0, 2, 3, 'SyntaxError: invalid syntax'),
    ]
)
def test_simple_syntax_errors(Script, code, line, column, until_line, until_column, message):
    e, = Script(code).get_syntax_errors()
    assert e.line == line
    assert e.column == column
    assert e.until_line == until_line
    assert e.until_column == until_column
    assert e.get_message() == message


@pytest.mark.parametrize(
    'code', [
        'x % y',
        'def x(x): pass',
        'def x(x):\n pass',
    ]
)
def test_no_syntax_errors(Script, code):
    assert not Script(code).get_syntax_errors()


def test_multi_syntax_error(Script):
    code = dedent('''\
        def x():
        1
        def y()
        1 + 1
        1 *** 3
        ''')
    x, y, power = Script(code).get_syntax_errors()
    assert x.line == 2
    assert x.column == 0
    assert y.line == 3
    assert y.column == 7
    assert power.line == 5
    assert power.column == 4
