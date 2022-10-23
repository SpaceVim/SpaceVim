"""
Testing if parso finds syntax errors and indentation errors.
"""
import sys
import warnings

import pytest

import parso

from textwrap import dedent
from parso._compatibility import is_pypy
from .failing_examples import FAILING_EXAMPLES, indent, build_nested


if is_pypy:
    # The errors in PyPy might be different. Just skip the module for now.
    pytestmark = pytest.mark.skip()


def _get_error_list(code, version=None):
    grammar = parso.load_grammar(version=version)
    tree = grammar.parse(code)
    return list(grammar.iter_errors(tree))


def assert_comparison(code, error_code, positions):
    errors = [(error.start_pos, error.code) for error in _get_error_list(code)]
    assert [(pos, error_code) for pos in positions] == errors


@pytest.mark.parametrize('code', FAILING_EXAMPLES)
def test_python_exception_matches(code):
    wanted, line_nr = _get_actual_exception(code)

    errors = _get_error_list(code)
    actual = None
    if errors:
        error, = errors
        actual = error.message
    assert actual in wanted
    # Somehow in Python2.7 the SyntaxError().lineno is sometimes None
    assert line_nr is None or line_nr == error.start_pos[0]


def test_non_async_in_async():
    """
    This example doesn't work with FAILING_EXAMPLES, because the line numbers
    are not always the same / incorrect in Python 3.8.
    """
    # Raises multiple errors in previous versions.
    code = 'async def foo():\n def nofoo():[x async for x in []]'
    wanted, line_nr = _get_actual_exception(code)

    errors = _get_error_list(code)
    if errors:
        error, = errors
        actual = error.message
    assert actual in wanted
    if sys.version_info[:2] not in ((3, 8), (3, 9)):
        assert line_nr == error.start_pos[0]
    else:
        assert line_nr == 0  # For whatever reason this is zero in Python 3.8/3.9


@pytest.mark.parametrize(
    ('code', 'positions'), [
        ('1 +', [(1, 3)]),
        ('1 +\n', [(1, 3)]),
        ('1 +\n2 +', [(1, 3), (2, 3)]),
        ('x + 2', []),
        ('[\n', [(2, 0)]),
        ('[\ndef x(): pass', [(2, 0)]),
        ('[\nif 1: pass', [(2, 0)]),
        ('1+?', [(1, 2)]),
        ('?', [(1, 0)]),
        ('??', [(1, 0)]),
        ('? ?', [(1, 0)]),
        ('?\n?', [(1, 0), (2, 0)]),
        ('? * ?', [(1, 0)]),
        ('1 + * * 2', [(1, 4)]),
        ('?\n1\n?', [(1, 0), (3, 0)]),
    ]
)
def test_syntax_errors(code, positions):
    assert_comparison(code, 901, positions)


@pytest.mark.parametrize(
    ('code', 'positions'), [
        (' 1', [(1, 0)]),
        ('def x():\n    1\n 2', [(3, 0)]),
        ('def x():\n 1\n  2', [(3, 0)]),
        ('def x():\n1', [(2, 0)]),
    ]
)
def test_indentation_errors(code, positions):
    assert_comparison(code, 903, positions)


def _get_actual_exception(code):
    with warnings.catch_warnings():
        # We don't care about warnings where locals/globals misbehave here.
        # It's as simple as either an error or not.
        warnings.filterwarnings('ignore', category=SyntaxWarning)
        try:
            compile(code, '<unknown>', 'exec')
        except (SyntaxError, IndentationError) as e:
            wanted = e.__class__.__name__ + ': ' + e.msg
            line_nr = e.lineno
        except ValueError as e:
            # The ValueError comes from byte literals in Python 2 like '\x'
            # that are oddly enough not SyntaxErrors.
            wanted = 'SyntaxError: (value error) ' + str(e)
            line_nr = None
        else:
            assert False, "The piece of code should raise an exception."

    # SyntaxError
    if wanted == 'SyntaxError: assignment to keyword':
        return [wanted, "SyntaxError: can't assign to keyword",
                'SyntaxError: cannot assign to __debug__'], line_nr
    elif wanted == 'SyntaxError: f-string: unterminated string':
        wanted = 'SyntaxError: EOL while scanning string literal'
    elif wanted == 'SyntaxError: f-string expression part cannot include a backslash':
        return [
            wanted,
            "SyntaxError: EOL while scanning string literal",
            "SyntaxError: unexpected character after line continuation character",
        ], line_nr
    elif wanted == "SyntaxError: f-string: expecting '}'":
        wanted = 'SyntaxError: EOL while scanning string literal'
    elif wanted == 'SyntaxError: f-string: empty expression not allowed':
        wanted = 'SyntaxError: invalid syntax'
    elif wanted == "SyntaxError: f-string expression part cannot include '#'":
        wanted = 'SyntaxError: invalid syntax'
    elif wanted == "SyntaxError: f-string: single '}' is not allowed":
        wanted = 'SyntaxError: invalid syntax'
    return [wanted], line_nr


def test_default_except_error_postition():
    # For this error the position seemed to be one line off in Python < 3.10,
    # but that doesn't really matter.
    code = 'try: pass\nexcept: pass\nexcept X: pass'
    wanted, line_nr = _get_actual_exception(code)
    error, = _get_error_list(code)
    assert error.message in wanted
    if sys.version_info[:2] >= (3, 10):
        assert line_nr == error.start_pos[0]
    else:
        assert line_nr != error.start_pos[0]
    # I think this is the better position.
    assert error.start_pos[0] == 2


def test_statically_nested_blocks():
    def build(code, depth):
        if depth == 0:
            return code

        new_code = 'if 1:\n' + indent(code)
        return build(new_code, depth - 1)

    def get_error(depth, add_func=False):
        code = build('foo', depth)
        if add_func:
            code = 'def bar():\n' + indent(code)
        errors = _get_error_list(code)
        if errors:
            assert errors[0].message == 'SyntaxError: too many statically nested blocks'
            return errors[0]
        return None

    assert get_error(19) is None
    assert get_error(19, add_func=True) is None

    assert get_error(20)
    assert get_error(20, add_func=True)


def test_future_import_first():
    def is_issue(code, *args, **kwargs):
        code = code % args
        return bool(_get_error_list(code, **kwargs))

    i1 = 'from __future__ import division'
    i2 = 'from __future__ import absolute_import'
    i3 = 'from __future__ import annotations'
    assert not is_issue(i1)
    assert not is_issue(i1 + ';' + i2)
    assert not is_issue(i1 + '\n' + i2)
    assert not is_issue('"";' + i1)
    assert not is_issue('"";' + i1)
    assert not is_issue('""\n' + i1)
    assert not is_issue('""\n%s\n%s', i1, i2)
    assert not is_issue('""\n%s;%s', i1, i2)
    assert not is_issue('"";%s;%s ', i1, i2)
    assert not is_issue('"";%s\n%s ', i1, i2)
    assert not is_issue(i3, version="3.7")
    assert is_issue(i3, version="3.6")
    assert is_issue('1;' + i1)
    assert is_issue('1\n' + i1)
    assert is_issue('"";1\n' + i1)
    assert is_issue('""\n%s\nfrom x import a\n%s', i1, i2)
    assert is_issue('%s\n""\n%s', i1, i2)


def test_named_argument_issues(works_not_in_py):
    message = works_not_in_py.get_error_message('def foo(*, **dict): pass')
    message = works_not_in_py.get_error_message('def foo(*): pass')
    if works_not_in_py.version.startswith('2'):
        assert message == 'SyntaxError: invalid syntax'
    else:
        assert message == 'SyntaxError: named arguments must follow bare *'

    works_not_in_py.assert_no_error_in_passing('def foo(*, name): pass')
    works_not_in_py.assert_no_error_in_passing('def foo(bar, *, name=1): pass')
    works_not_in_py.assert_no_error_in_passing('def foo(bar, *, name=1, **dct): pass')


def test_escape_decode_literals(each_version):
    """
    We are using internal functions to assure that unicode/bytes escaping is
    without syntax errors. Here we make a bit of quality assurance that this
    works through versions, because the internal function might change over
    time.
    """
    def get_msg(end, to=1):
        base = "SyntaxError: (unicode error) 'unicodeescape' " \
               "codec can't decode bytes in position 0-%s: " % to
        return base + end

    def get_msgs(escape):
        return (get_msg('end of string in escape sequence'),
                get_msg(r"truncated %s escape" % escape))

    error, = _get_error_list(r'u"\x"', version=each_version)
    assert error.message in get_msgs(r'\xXX')

    error, = _get_error_list(r'u"\u"', version=each_version)
    assert error.message in get_msgs(r'\uXXXX')

    error, = _get_error_list(r'u"\U"', version=each_version)
    assert error.message in get_msgs(r'\UXXXXXXXX')

    error, = _get_error_list(r'u"\N{}"', version=each_version)
    assert error.message == get_msg(r'malformed \N character escape', to=2)

    error, = _get_error_list(r'u"\N{foo}"', version=each_version)
    assert error.message == get_msg(r'unknown Unicode character name', to=6)

    # Finally bytes.
    error, = _get_error_list(r'b"\x"', version=each_version)
    wanted = r'SyntaxError: (value error) invalid \x escape at position 0'
    assert error.message == wanted


def test_too_many_levels_of_indentation():
    assert not _get_error_list(build_nested('pass', 99))
    assert _get_error_list(build_nested('pass', 100))
    base = 'def x():\n if x:\n'
    assert not _get_error_list(build_nested('pass', 49, base=base))
    assert _get_error_list(build_nested('pass', 50, base=base))


def test_paren_kwarg():
    assert _get_error_list("print((sep)=seperator)", version="3.8")
    assert not _get_error_list("print((sep)=seperator)", version="3.7")


@pytest.mark.parametrize(
    'code', [
        "f'{*args,}'",
        r'f"\""',
        r'f"\\\""',
        r'fr"\""',
        r'fr"\\\""',
        r"print(f'Some {x:.2f} and some {y}')",
        # Unparenthesized yield expression
        'def foo(): return f"{yield 1}"',
    ]
)
def test_valid_fstrings(code):
    assert not _get_error_list(code, version='3.6')


@pytest.mark.parametrize(
    'code', [
        'a = (b := 1)',
        '[x4 := x ** 5 for x in range(7)]',
        '[total := total + v for v in range(10)]',
        'while chunk := file.read(2):\n pass',
        'numbers = [y := math.factorial(x), y**2, y**3]',
        '{(a:="a"): (b:=1)}',
        '{(y:=1): 2 for x in range(5)}',
        'a[(b:=0)]',
        'a[(b:=0, c:=0)]',
        'a[(b:=0):1:2]',
    ]
)
def test_valid_namedexpr(code):
    assert not _get_error_list(code, version='3.8')


@pytest.mark.parametrize(
    'code', [
        '{x := 1, 2, 3}',
        '{x4 := x ** 5 for x in range(7)}',
    ]
)
def test_valid_namedexpr_set(code):
    assert not _get_error_list(code, version='3.9')


@pytest.mark.parametrize(
    'code', [
        'a[b:=0]',
        'a[b:=0, c:=0]',
    ]
)
def test_valid_namedexpr_index(code):
    assert not _get_error_list(code, version='3.10')


@pytest.mark.parametrize(
    ('code', 'message'), [
        ("f'{1+}'", ('invalid syntax')),
        (r'f"\"', ('invalid syntax')),
        (r'fr"\"', ('invalid syntax')),
    ]
)
def test_invalid_fstrings(code, message):
    """
    Some fstring errors are handled differntly in 3.6 and other versions.
    Therefore check specifically for these errors here.
    """
    error, = _get_error_list(code, version='3.6')
    assert message in error.message


@pytest.mark.parametrize(
    'code', [
        "from foo import (\nbar,\n rab,\n)",
        "from foo import (bar, rab, )",
    ]
)
def test_trailing_comma(code):
    errors = _get_error_list(code)
    assert not errors


def test_continue_in_finally():
    code = dedent('''\
        for a in [1]:
            try:
                pass
            finally:
                continue
        ''')
    assert not _get_error_list(code, version="3.8")
    assert _get_error_list(code, version="3.7")


@pytest.mark.parametrize(
    'template', [
        "a, b, {target}, c = d",
        "a, b, *{target}, c = d",
        "(a, *{target}), c = d",
        "for x, {target} in y: pass",
        "for x, q, {target} in y: pass",
        "for x, q, *{target} in y: pass",
        "for (x, *{target}), q in y: pass",
    ]
)
@pytest.mark.parametrize(
    'target', [
        "True",
        "False",
        "None",
        "__debug__"
    ]
)
def test_forbidden_name(template, target):
    assert _get_error_list(template.format(target=target), version="3")


def test_repeated_kwarg():
    # python 3.9+ shows which argument is repeated
    assert (
        _get_error_list("f(q=1, q=2)", version="3.8")[0].message
        == "SyntaxError: keyword argument repeated"
    )
    assert (
        _get_error_list("f(q=1, q=2)", version="3.9")[0].message
        == "SyntaxError: keyword argument repeated: q"
    )


@pytest.mark.parametrize(
    ('source', 'no_errors'), [
        ('a(a for a in b,)', False),
        ('a(a for a in b, a)', False),
        ('a(a, a for a in b)', False),
        ('a(a, b, a for a in b, c, d)', False),
        ('a(a for a in b)', True),
        ('a((a for a in b), c)', True),
        ('a(c, (a for a in b))', True),
        ('a(a, b, (a for a in b), c, d)', True),
    ]
)
def test_unparenthesized_genexp(source, no_errors):
    assert bool(_get_error_list(source)) ^ no_errors


@pytest.mark.parametrize(
    ('source', 'no_errors'), [
        ('*x = 2', False),
        ('(*y) = 1', False),
        ('((*z)) = 1', False),
        ('*a,', True),
        ('*a, = 1', True),
        ('(*a,)', True),
        ('(*a,) = 1', True),
        ('[*a]', True),
        ('[*a] = 1', True),
        ('a, *b', True),
        ('a, *b = 1', True),
        ('a, *b, c', True),
        ('a, *b, c = 1', True),
        ('a, (*b, c), d', True),
        ('a, (*b, c), d = 1', True),
        ('*a.b,', True),
        ('*a.b, = 1', True),
        ('*a[b],', True),
        ('*a[b], = 1', True),
        ('*a[b::], c', True),
        ('*a[b::], c = 1', True),
        ('(a, *[b, c])', True),
        ('(a, *[b, c]) = 1', True),
        ('[a, *(b, [*c])]', True),
        ('[a, *(b, [*c])] = 1', True),
        ('[*(1,2,3)]', True),
        ('{*(1,2,3)}', True),
        ('[*(1,2,3),]', True),
        ('[*(1,2,3), *(4,5,6)]', True),
        ('[0, *(1,2,3)]', True),
        ('{*(1,2,3),}', True),
        ('{*(1,2,3), *(4,5,6)}', True),
        ('{0, *(4,5,6)}', True)
    ]
)
def test_starred_expr(source, no_errors):
    assert bool(_get_error_list(source, version="3")) ^ no_errors


@pytest.mark.parametrize(
    'code', [
        'a, (*b), c',
        'a, (*b), c = 1',
        'a, ((*b)), c',
        'a, ((*b)), c = 1',
    ]
)
def test_parenthesized_single_starred_expr(code):
    assert not _get_error_list(code, version='3.8')
    assert _get_error_list(code, version='3.9')


@pytest.mark.parametrize(
    'code', [
        '() = ()',
        '() = []',
        '[] = ()',
        '[] = []',
    ]
)
def test_valid_empty_assignment(code):
    assert not _get_error_list(code)


@pytest.mark.parametrize(
    'code', [
        'del ()',
        'del []',
        'del x',
        'del x,',
        'del x, y',
        'del (x, y)',
        'del [x, y]',
        'del (x, [y, z])',
        'del x.y, x[y]',
        'del f(x)[y::]',
        'del x[[*y]]',
        'del x[[*y]::]',
    ]
)
def test_valid_del(code):
    assert not _get_error_list(code)


@pytest.mark.parametrize(
    ('source', 'version', 'no_errors'), [
        ('[x for x in range(10) if lambda: 1]', '3.8', True),
        ('[x for x in range(10) if lambda: 1]', '3.9', False),
        ('[x for x in range(10) if (lambda: 1)]', '3.9', True),
    ]
)
def test_lambda_in_comp_if(source, version, no_errors):
    assert bool(_get_error_list(source, version=version)) ^ no_errors
