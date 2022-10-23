# -*- coding: utf-8    # This file contains Unicode characters.

from textwrap import dedent

import pytest

from parso.utils import split_lines, parse_version_string
from parso.python.token import PythonTokenTypes
from parso.python import tokenize
from parso import parse
from parso.python.tokenize import PythonToken


# To make it easier to access some of the token types, just put them here.
NAME = PythonTokenTypes.NAME
NEWLINE = PythonTokenTypes.NEWLINE
STRING = PythonTokenTypes.STRING
NUMBER = PythonTokenTypes.NUMBER
INDENT = PythonTokenTypes.INDENT
DEDENT = PythonTokenTypes.DEDENT
ERRORTOKEN = PythonTokenTypes.ERRORTOKEN
OP = PythonTokenTypes.OP
ENDMARKER = PythonTokenTypes.ENDMARKER
ERROR_DEDENT = PythonTokenTypes.ERROR_DEDENT
FSTRING_START = PythonTokenTypes.FSTRING_START
FSTRING_STRING = PythonTokenTypes.FSTRING_STRING
FSTRING_END = PythonTokenTypes.FSTRING_END


def _get_token_list(string, version=None):
    # Load the current version.
    version_info = parse_version_string(version)
    return list(tokenize.tokenize(string, version_info=version_info))


def test_end_pos_one_line():
    parsed = parse(dedent('''
    def testit():
        a = "huhu"
    '''))
    simple_stmt = next(parsed.iter_funcdefs()).get_suite().children[-1]
    string = simple_stmt.children[0].get_rhs()
    assert string.end_pos == (3, 14)


def test_end_pos_multi_line():
    parsed = parse(dedent('''
    def testit():
        a = """huhu
    asdfasdf""" + "h"
    '''))
    expr_stmt = next(parsed.iter_funcdefs()).get_suite().children[1].children[0]
    string_leaf = expr_stmt.get_rhs().children[0]
    assert string_leaf.end_pos == (4, 11)


def test_simple_no_whitespace():
    # Test a simple one line string, no preceding whitespace
    simple_docstring = '"""simple one line docstring"""'
    token_list = _get_token_list(simple_docstring)
    _, value, _, prefix = token_list[0]
    assert prefix == ''
    assert value == '"""simple one line docstring"""'


def test_simple_with_whitespace():
    # Test a simple one line string with preceding whitespace and newline
    simple_docstring = '  """simple one line docstring""" \r\n'
    token_list = _get_token_list(simple_docstring)
    assert token_list[0][0] == INDENT
    typ, value, start_pos, prefix = token_list[1]
    assert prefix == '  '
    assert value == '"""simple one line docstring"""'
    assert typ == STRING
    typ, value, start_pos, prefix = token_list[2]
    assert prefix == ' '
    assert typ == NEWLINE


def test_function_whitespace():
    # Test function definition whitespace identification
    fundef = dedent('''
    def test_whitespace(*args, **kwargs):
        x = 1
        if x > 0:
            print(True)
    ''')
    token_list = _get_token_list(fundef)
    for _, value, _, prefix in token_list:
        if value == 'test_whitespace':
            assert prefix == ' '
        if value == '(':
            assert prefix == ''
        if value == '*':
            assert prefix == ''
        if value == '**':
            assert prefix == ' '
        if value == 'print':
            assert prefix == '        '
        if value == 'if':
            assert prefix == '    '


def test_tokenize_multiline_I():
    # Make sure multiline string having newlines have the end marker on the
    # next line
    fundef = '''""""\n'''
    token_list = _get_token_list(fundef)
    assert token_list == [PythonToken(ERRORTOKEN, '""""\n', (1, 0), ''),
                          PythonToken(ENDMARKER, '', (2, 0), '')]


def test_tokenize_multiline_II():
    # Make sure multiline string having no newlines have the end marker on
    # same line
    fundef = '''""""'''
    token_list = _get_token_list(fundef)
    assert token_list == [PythonToken(ERRORTOKEN, '""""', (1, 0), ''),
                          PythonToken(ENDMARKER, '', (1, 4), '')]


def test_tokenize_multiline_III():
    # Make sure multiline string having newlines have the end marker on the
    # next line even if several newline
    fundef = '''""""\n\n'''
    token_list = _get_token_list(fundef)
    assert token_list == [PythonToken(ERRORTOKEN, '""""\n\n', (1, 0), ''),
                          PythonToken(ENDMARKER, '', (3, 0), '')]


def test_identifier_contains_unicode():
    fundef = dedent('''
    def 我あφ():
        pass
    ''')
    token_list = _get_token_list(fundef)
    unicode_token = token_list[1]
    assert unicode_token[0] == NAME


def test_quoted_strings():
    string_tokens = [
        'u"test"',
        'u"""test"""',
        'U"""test"""',
        "u'''test'''",
        "U'''test'''",
    ]

    for s in string_tokens:
        module = parse('''a = %s\n''' % s)
        simple_stmt = module.children[0]
        expr_stmt = simple_stmt.children[0]
        assert len(expr_stmt.children) == 3
        string_tok = expr_stmt.children[2]
        assert string_tok.type == 'string'
        assert string_tok.value == s


def test_ur_literals():
    """
    Decided to parse `u''` literals regardless of Python version. This makes
    probably sense:

    - Python 3+ doesn't support it, but it doesn't hurt
      not be. While this is incorrect, it's just incorrect for one "old" and in
      the future not very important version.
    - All the other Python versions work very well with it.
    """
    def check(literal, is_literal=True):
        token_list = _get_token_list(literal)
        typ, result_literal, _, _ = token_list[0]
        if is_literal:
            if typ != FSTRING_START:
                assert typ == STRING
                assert result_literal == literal
        else:
            assert typ == NAME

    check('u""')
    check('ur""', is_literal=False)
    check('Ur""', is_literal=False)
    check('UR""', is_literal=False)
    check('bR""')
    check('Rb""')

    check('fr""')
    check('rF""')
    check('f""')
    check('F""')


def test_error_literal():
    error_token, newline, endmarker = _get_token_list('"\n')
    assert error_token.type == ERRORTOKEN
    assert error_token.string == '"'
    assert newline.type == NEWLINE
    assert endmarker.type == ENDMARKER
    assert endmarker.prefix == ''

    bracket, error_token, endmarker = _get_token_list('( """')
    assert error_token.type == ERRORTOKEN
    assert error_token.prefix == ' '
    assert error_token.string == '"""'
    assert endmarker.type == ENDMARKER
    assert endmarker.prefix == ''


def test_endmarker_end_pos():
    def check(code):
        tokens = _get_token_list(code)
        lines = split_lines(code)
        assert tokens[-1].end_pos == (len(lines), len(lines[-1]))

    check('#c')
    check('#c\n')
    check('a\n')
    check('a')
    check(r'a\\n')
    check('a\\')


@pytest.mark.parametrize(
    ('code', 'types'), [
        # Indentation
        (' foo', [INDENT, NAME, DEDENT]),
        ('  foo\n bar', [INDENT, NAME, NEWLINE, ERROR_DEDENT, NAME, DEDENT]),
        ('  foo\n bar \n baz', [INDENT, NAME, NEWLINE, ERROR_DEDENT, NAME,
                                NEWLINE, NAME, DEDENT]),
        (' foo\nbar', [INDENT, NAME, NEWLINE, DEDENT, NAME]),

        # Name stuff
        ('1foo1', [NUMBER, NAME]),
        ('மெல்லினம்', [NAME]),
        ('²', [ERRORTOKEN]),
        ('ä²ö', [NAME, ERRORTOKEN, NAME]),
        ('ää²¹öö', [NAME, ERRORTOKEN, NAME]),
        (' \x00a', [INDENT, ERRORTOKEN, NAME, DEDENT]),
        (dedent('''\
            class BaseCache:
                    a
                def
                    b
                def
                    c
            '''), [NAME, NAME, OP, NEWLINE, INDENT, NAME, NEWLINE,
                   ERROR_DEDENT, NAME, NEWLINE, INDENT, NAME, NEWLINE, DEDENT,
                   NAME, NEWLINE, INDENT, NAME, NEWLINE, DEDENT, DEDENT]),
        ('  )\n foo', [INDENT, OP, NEWLINE, ERROR_DEDENT, NAME, DEDENT]),
        ('a\n b\n  )\n c', [NAME, NEWLINE, INDENT, NAME, NEWLINE, INDENT, OP,
                            NEWLINE, DEDENT, NAME, DEDENT]),
        (' 1 \\\ndef', [INDENT, NUMBER, NAME, DEDENT]),
    ]
)
def test_token_types(code, types):
    actual_types = [t.type for t in _get_token_list(code)]
    assert actual_types == types + [ENDMARKER]


def test_error_string():
    indent, t1, newline, token, endmarker = _get_token_list(' "\n')
    assert t1.type == ERRORTOKEN
    assert t1.prefix == ' '
    assert t1.string == '"'
    assert newline.type == NEWLINE
    assert endmarker.prefix == ''
    assert endmarker.string == ''


def test_indent_error_recovery():
    code = dedent("""\
                        str(
        from x import a
        def
        """)
    lst = _get_token_list(code)
    expected = [
        # `str(`
        INDENT, NAME, OP,
        # `from parso`
        NAME, NAME,
        # `import a` on same line as the previous from parso
        NAME, NAME, NEWLINE,
        # Dedent happens, because there's an import now and the import
        # statement "breaks" out of the opening paren on the first line.
        DEDENT,
        # `b`
        NAME, NEWLINE, ENDMARKER]
    assert [t.type for t in lst] == expected


def test_error_token_after_dedent():
    code = dedent("""\
        class C:
            pass
        $foo
        """)
    lst = _get_token_list(code)
    expected = [
        NAME, NAME, OP, NEWLINE, INDENT, NAME, NEWLINE, DEDENT,
        # $foo\n
        ERRORTOKEN, NAME, NEWLINE, ENDMARKER
    ]
    assert [t.type for t in lst] == expected


def test_brackets_no_indentation():
    """
    There used to be an issue that the parentheses counting would go below
    zero. This should not happen.
    """
    code = dedent("""\
        }
        {
          }
        """)
    lst = _get_token_list(code)
    assert [t.type for t in lst] == [OP, NEWLINE, OP, OP, NEWLINE, ENDMARKER]


def test_form_feed():
    indent, error_token, dedent_, endmarker = _get_token_list(dedent('''\
        \f"""'''))
    assert error_token.prefix == '\f'
    assert error_token.string == '"""'
    assert endmarker.prefix == ''
    assert indent.type == INDENT
    assert dedent_.type == DEDENT


def test_carriage_return():
    lst = _get_token_list(' =\\\rclass')
    assert [t.type for t in lst] == [INDENT, OP, NAME, DEDENT, ENDMARKER]


def test_backslash():
    code = '\\\n# 1 \n'
    endmarker, = _get_token_list(code)
    assert endmarker.prefix == code


@pytest.mark.parametrize(
    ('code', 'types'), [
        # f-strings
        ('f"', [FSTRING_START]),
        ('f""', [FSTRING_START, FSTRING_END]),
        ('f" {}"', [FSTRING_START, FSTRING_STRING, OP, OP, FSTRING_END]),
        ('f" "{}', [FSTRING_START, FSTRING_STRING, FSTRING_END, OP, OP]),
        (r'f"\""', [FSTRING_START, FSTRING_STRING, FSTRING_END]),
        (r'f"\""', [FSTRING_START, FSTRING_STRING, FSTRING_END]),

        # format spec
        (r'f"Some {x:.2f}{y}"', [FSTRING_START, FSTRING_STRING, OP, NAME, OP,
                                 FSTRING_STRING, OP, OP, NAME, OP, FSTRING_END]),

        # multiline f-string
        ('f"""abc\ndef"""', [FSTRING_START, FSTRING_STRING, FSTRING_END]),
        ('f"""abc{\n123}def"""', [
            FSTRING_START, FSTRING_STRING, OP, NUMBER, OP, FSTRING_STRING,
            FSTRING_END
        ]),

        # a line continuation inside of an fstring_string
        ('f"abc\\\ndef"', [
            FSTRING_START, FSTRING_STRING, FSTRING_END
        ]),
        ('f"\\\n{123}\\\n"', [
            FSTRING_START, FSTRING_STRING, OP, NUMBER, OP, FSTRING_STRING,
            FSTRING_END
        ]),

        # a line continuation inside of an fstring_expr
        ('f"{\\\n123}"', [FSTRING_START, OP, NUMBER, OP, FSTRING_END]),

        # a line continuation inside of an format spec
        ('f"{123:.2\\\nf}"', [
            FSTRING_START, OP, NUMBER, OP, FSTRING_STRING, OP, FSTRING_END
        ]),

        # a newline without a line continuation inside a single-line string is
        # wrong, and will generate an ERRORTOKEN
        ('f"abc\ndef"', [
            FSTRING_START, FSTRING_STRING, NEWLINE, NAME, ERRORTOKEN
        ]),

        # a more complex example
        (r'print(f"Some {x:.2f}a{y}")', [
            NAME, OP, FSTRING_START, FSTRING_STRING, OP, NAME, OP,
            FSTRING_STRING, OP, FSTRING_STRING, OP, NAME, OP, FSTRING_END, OP
        ]),
        # issue #86, a string-like in an f-string expression
        ('f"{ ""}"', [
            FSTRING_START, OP, FSTRING_END, STRING
        ]),
        ('f"{ f""}"', [
            FSTRING_START, OP, NAME, FSTRING_END, STRING
        ]),
    ]
)
def test_fstring_token_types(code, types, each_version):
    actual_types = [t.type for t in _get_token_list(code, each_version)]
    assert types + [ENDMARKER] == actual_types


@pytest.mark.parametrize(
    ('code', 'types'), [
        # issue #87, `:=` in the outest paratheses should be tokenized
        # as a format spec marker and part of the format
        ('f"{x:=10}"', [
            FSTRING_START, OP, NAME, OP, FSTRING_STRING, OP, FSTRING_END
        ]),
        ('f"{(x:=10)}"', [
            FSTRING_START, OP, OP, NAME, OP, NUMBER, OP, OP, FSTRING_END
        ]),
    ]
)
def test_fstring_assignment_expression(code, types, version_ge_py38):
    actual_types = [t.type for t in _get_token_list(code, version_ge_py38)]
    assert types + [ENDMARKER] == actual_types


def test_fstring_end_error_pos(version_ge_py38):
    f_start, f_string, bracket, f_end, endmarker = \
        _get_token_list('f" { "', version_ge_py38)
    assert f_start.start_pos == (1, 0)
    assert f_string.start_pos == (1, 2)
    assert bracket.start_pos == (1, 3)
    assert f_end.start_pos == (1, 5)
    assert endmarker.start_pos == (1, 6)
