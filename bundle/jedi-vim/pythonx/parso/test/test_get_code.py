import difflib

import pytest

from parso import parse

code_basic_features = '''
"""A mod docstring"""

def a_function(a_argument, a_default = "default"):
    """A func docstring"""

    a_result = 3 * a_argument
    print(a_result)  # a comment
    b = """
from
to""" + "huhu"


    if a_default == "default":
        return str(a_result)
    else
        return None
'''


def diff_code_assert(a, b, n=4):
    if a != b:
        diff = "\n".join(difflib.unified_diff(
            a.splitlines(),
            b.splitlines(),
            n=n,
            lineterm=""
        ))
        assert False, "Code does not match:\n%s\n\ncreated code:\n%s" % (
            diff,
            b
        )
    pass


def test_basic_parsing():
    """Validate the parsing features"""

    m = parse(code_basic_features)
    diff_code_assert(
        code_basic_features,
        m.get_code()
    )


def test_operators():
    src = '5  * 3'
    module = parse(src)
    diff_code_assert(src, module.get_code())


def test_get_code():
    """Use the same code that the parser also generates, to compare"""
    s = '''"""a docstring"""
class SomeClass(object, mixin):
    def __init__(self):
        self.xy = 3.0
        """statement docstr"""
    def some_method(self):
        return 1
    def yield_method(self):
        while hasattr(self, 'xy'):
            yield True
        for x in [1, 2]:
            yield x
    def empty(self):
        pass
class Empty:
    pass
class WithDocstring:
    """class docstr"""
    pass
def method_with_docstring():
    """class docstr"""
    pass
'''
    assert parse(s).get_code() == s


def test_end_newlines():
    """
    The Python grammar explicitly needs a newline at the end. Jedi though still
    wants to be able, to return the exact same code without the additional new
    line the parser needs.
    """
    def test(source, end_pos):
        module = parse(source)
        assert module.get_code() == source
        assert module.end_pos == end_pos

    test('a', (1, 1))
    test('a\n', (2, 0))
    test('a\nb', (2, 1))
    test('a\n#comment\n', (3, 0))
    test('a\n#comment', (2, 8))
    test('a#comment', (1, 9))
    test('def a():\n pass', (2, 5))

    test('def a(', (1, 6))


@pytest.mark.parametrize(('code', 'types'), [
    ('\r', ['endmarker']),
    ('\n\r', ['endmarker'])
])
def test_carriage_return_at_end(code, types):
    """
    By adding an artificial newline this created weird side effects for
    \r at the end of files.
    """
    tree = parse(code)
    assert tree.get_code() == code
    assert [c.type for c in tree.children] == types
    assert tree.end_pos == (len(code) + 1, 0)


@pytest.mark.parametrize('code', [
    ' ',
    '    F"""',
    '    F"""\n',
    '    F""" \n',
    '    F""" \n3',
    '    f"""\n"""',
    '    f"""\n"""\n',
])
def test_full_code_round_trip(code):
    assert parse(code).get_code() == code
