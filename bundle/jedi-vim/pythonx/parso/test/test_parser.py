# -*- coding: utf-8 -*-
from textwrap import dedent

import pytest

from parso import parse
from parso.python import tree
from parso.utils import split_lines


def test_basic_parsing(each_version):
    def compare(string):
        """Generates the AST object and then regenerates the code."""
        assert parse(string, version=each_version).get_code() == string

    compare('\na #pass\n')
    compare('wblabla* 1\t\n')
    compare('def x(a, b:3): pass\n')
    compare('assert foo\n')


def test_subscope_names(each_version):
    def get_sub(source):
        return parse(source, version=each_version).children[0]

    name = get_sub('class Foo: pass').name
    assert name.start_pos == (1, len('class '))
    assert name.end_pos == (1, len('class Foo'))
    assert name.value == 'Foo'

    name = get_sub('def foo(): pass').name
    assert name.start_pos == (1, len('def '))
    assert name.end_pos == (1, len('def foo'))
    assert name.value == 'foo'


def test_import_names(each_version):
    def get_import(source):
        return next(parse(source, version=each_version).iter_imports())

    imp = get_import('import math\n')
    names = imp.get_defined_names()
    assert len(names) == 1
    assert names[0].value == 'math'
    assert names[0].start_pos == (1, len('import '))
    assert names[0].end_pos == (1, len('import math'))

    assert imp.start_pos == (1, 0)
    assert imp.end_pos == (1, len('import math'))


def test_end_pos(each_version):
    s = dedent('''
               x = ['a', 'b', 'c']
               def func():
                   y = None
               ''')
    parser = parse(s, version=each_version)
    scope = next(parser.iter_funcdefs())
    assert scope.start_pos == (3, 0)
    assert scope.end_pos == (5, 0)


def test_carriage_return_statements(each_version):
    source = dedent('''
        foo = 'ns1!'

        # this is a namespace package
    ''')
    source = source.replace('\n', '\r\n')
    stmt = parse(source, version=each_version).children[0]
    assert '#' not in stmt.get_code()


def test_incomplete_list_comprehension(each_version):
    """ Shouldn't raise an error, same bug as #418. """
    # With the old parser this actually returned a statement. With the new
    # parser only valid statements generate one.
    children = parse('(1 for def', version=each_version).children
    assert [c.type for c in children] == \
        ['error_node', 'error_node', 'endmarker']


def test_newline_positions(each_version):
    endmarker = parse('a\n', version=each_version).children[-1]
    assert endmarker.end_pos == (2, 0)
    new_line = endmarker.get_previous_leaf()
    assert new_line.start_pos == (1, 1)
    assert new_line.end_pos == (2, 0)


def test_end_pos_error_correction(each_version):
    """
    Source code without ending newline are given one, because the Python
    grammar needs it. However, they are removed again. We still want the right
    end_pos, even if something breaks in the parser (error correction).
    """
    s = 'def x():\n .'
    m = parse(s, version=each_version)
    func = m.children[0]
    assert func.type == 'funcdef'
    assert func.end_pos == (2, 2)
    assert m.end_pos == (2, 2)


def test_param_splitting(each_version):
    """
    Jedi splits parameters into params, this is not what the grammar does,
    but Jedi does this to simplify argument parsing.
    """
    def check(src, result):
        m = parse(src, version=each_version)
        assert not list(m.iter_funcdefs())

    check('def x(a, (b, c)):\n pass', ['a'])
    check('def x((b, c)):\n pass', [])


def test_unicode_string():
    s = tree.String(None, 'bö', (0, 0))
    assert repr(s)  # Should not raise an Error!


def test_backslash_dos_style(each_version):
    assert parse('\\\r\n', version=each_version)


def test_started_lambda_stmt(each_version):
    m = parse('lambda a, b: a i', version=each_version)
    assert m.children[0].type == 'error_node'


@pytest.mark.parametrize('code', ['foo "', 'foo """\n', 'foo """\nbar'])
def test_open_string_literal(each_version, code):
    """
    Testing mostly if removing the last newline works.
    """
    lines = split_lines(code, keepends=True)
    end_pos = (len(lines), len(lines[-1]))
    module = parse(code, version=each_version)
    assert module.get_code() == code
    assert module.end_pos == end_pos == module.children[1].end_pos


def test_too_many_params():
    with pytest.raises(TypeError):
        parse('asdf', hello=3)


def test_dedent_at_end(each_version):
    code = dedent('''
        for foobar in [1]:
            foobar''')
    module = parse(code, version=each_version)
    assert module.get_code() == code
    suite = module.children[0].children[-1]
    foobar = suite.children[-1]
    assert foobar.type == 'name'


def test_no_error_nodes(each_version):
    def check(node):
        assert node.type not in ('error_leaf', 'error_node')

        try:
            children = node.children
        except AttributeError:
            pass
        else:
            for child in children:
                check(child)

    check(parse("if foo:\n bar", version=each_version))


def test_named_expression(works_ge_py38):
    works_ge_py38.parse("(a := 1, a + 1)")


def test_extended_rhs_annassign(works_ge_py38):
    works_ge_py38.parse("x: y = z,")
    works_ge_py38.parse("x: Tuple[int, ...] = z, *q, w")


@pytest.mark.parametrize(
    'param_code', [
        'a=1, /',
        'a, /',
        'a=1, /, b=3',
        'a, /, b',
        'a, /, b',
        'a, /, *, b',
        'a, /, **kwargs',
    ]
)
def test_positional_only_arguments(works_ge_py38, param_code):
    works_ge_py38.parse("def x(%s): pass" % param_code)


@pytest.mark.parametrize(
    'expression', [
        'a + a',
        'lambda x: x',
        'a := lambda x: x'
    ]
)
def test_decorator_expression(works_ge_py39, expression):
    works_ge_py39.parse("@%s\ndef x(): pass" % expression)
