# -*- coding: utf-8    # This file contains Unicode characters.

from textwrap import dedent

import pytest

from parso import parse
from parso.python import tree
from parso.tree import search_ancestor


class TestsFunctionAndLambdaParsing:

    FIXTURES = [
        ('def my_function(x, y, z) -> str:\n    return x + y * z\n', {
            'name': 'my_function',
            'call_sig': 'my_function(x, y, z)',
            'params': ['x', 'y', 'z'],
            'annotation': "str",
        }),
        ('lambda x, y, z: x + y * z\n', {
            'name': '<lambda>',
            'call_sig': '<lambda>(x, y, z)',
            'params': ['x', 'y', 'z'],
        }),
    ]

    @pytest.fixture(params=FIXTURES)
    def node(self, request):
        parsed = parse(dedent(request.param[0]), version='3.10')
        request.keywords['expected'] = request.param[1]
        child = parsed.children[0]
        if child.type == 'simple_stmt':
            child = child.children[0]
        return child

    @pytest.fixture()
    def expected(self, request, node):
        return request.keywords['expected']

    def test_name(self, node, expected):
        if node.type != 'lambdef':
            assert isinstance(node.name, tree.Name)
            assert node.name.value == expected['name']

    def test_params(self, node, expected):
        assert isinstance(node.get_params(), list)
        assert all(isinstance(x, tree.Param) for x in node.get_params())
        assert [str(x.name.value) for x in node.get_params()] == [x for x in expected['params']]

    def test_is_generator(self, node, expected):
        assert node.is_generator() is expected.get('is_generator', False)

    def test_yields(self, node, expected):
        assert node.is_generator() == expected.get('yields', False)

    def test_annotation(self, node, expected):
        expected_annotation = expected.get('annotation', None)
        if expected_annotation is None:
            assert node.annotation is None
        else:
            assert node.annotation.value == expected_annotation


def test_end_pos_line(each_version):
    # jedi issue #150
    s = "x()\nx( )\nx(  )\nx (  )\n"

    module = parse(s, version=each_version)
    for i, simple_stmt in enumerate(module.children[:-1]):
        expr_stmt = simple_stmt.children[0]
        assert expr_stmt.end_pos == (i + 1, i + 3)


def test_default_param(each_version):
    func = parse('def x(foo=42): pass', version=each_version).children[0]
    param, = func.get_params()
    assert param.default.value == '42'
    assert param.annotation is None
    assert not param.star_count


def test_annotation_param(each_version):
    func = parse('def x(foo: 3): pass', version=each_version).children[0]
    param, = func.get_params()
    assert param.default is None
    assert param.annotation.value == '3'
    assert not param.star_count


def test_annotation_params(each_version):
    func = parse('def x(foo: 3, bar: 4): pass', version=each_version).children[0]
    param1, param2 = func.get_params()

    assert param1.default is None
    assert param1.annotation.value == '3'
    assert not param1.star_count

    assert param2.default is None
    assert param2.annotation.value == '4'
    assert not param2.star_count


def test_default_and_annotation_param(each_version):
    func = parse('def x(foo:3=42): pass', version=each_version).children[0]
    param, = func.get_params()
    assert param.default.value == '42'
    assert param.annotation.value == '3'
    assert not param.star_count


def get_yield_exprs(code, version):
    return list(parse(code, version=version).children[0].iter_yield_exprs())


def get_return_stmts(code):
    return list(parse(code).children[0].iter_return_stmts())


def get_raise_stmts(code, child):
    return list(parse(code).children[child].iter_raise_stmts())


def test_yields(each_version):
    y, = get_yield_exprs('def x(): yield', each_version)
    assert y.value == 'yield'
    assert y.type == 'keyword'

    y, = get_yield_exprs('def x(): (yield 1)', each_version)
    assert y.type == 'yield_expr'

    y, = get_yield_exprs('def x(): [1, (yield)]', each_version)
    assert y.type == 'keyword'


def test_yield_from():
    y, = get_yield_exprs('def x(): (yield from 1)', '3.8')
    assert y.type == 'yield_expr'


def test_returns():
    r, = get_return_stmts('def x(): return')
    assert r.value == 'return'
    assert r.type == 'keyword'

    r, = get_return_stmts('def x(): return 1')
    assert r.type == 'return_stmt'


def test_raises():
    code = """
def single_function():
    raise Exception
def top_function():
    def inner_function():
        raise NotImplementedError()
    inner_function()
    raise Exception
def top_function_three():
    try:
        raise NotImplementedError()
    except NotImplementedError:
        pass
    raise Exception
    """

    r = get_raise_stmts(code, 0)  # Lists in a simple Function
    assert len(list(r)) == 1

    r = get_raise_stmts(code, 1)  # Doesn't Exceptions list in closures
    assert len(list(r)) == 1

    r = get_raise_stmts(code, 2)  # Lists inside try-catch
    assert len(list(r)) == 2


@pytest.mark.parametrize(
    'code, name_index, is_definition, include_setitem', [
        ('x = 3', 0, True, False),
        ('x.y = 3', 0, False, False),
        ('x.y = 3', 1, True, False),
        ('x.y = u.v = z', 0, False, False),
        ('x.y = u.v = z', 1, True, False),
        ('x.y = u.v = z', 2, False, False),
        ('x.y = u.v, w = z', 3, True, False),
        ('x.y = u.v, w = z', 4, True, False),
        ('x.y = u.v, w = z', 5, False, False),

        ('x, y = z', 0, True, False),
        ('x, y = z', 1, True, False),
        ('x, y = z', 2, False, False),
        ('x, y = z', 2, False, False),
        ('x[0], y = z', 2, False, False),
        ('x[0] = z', 0, False, False),
        ('x[0], y = z', 0, False, False),
        ('x[0], y = z', 2, False, True),
        ('x[0] = z', 0, True, True),
        ('x[0], y = z', 0, True, True),
        ('x: int = z', 0, True, False),
        ('x: int = z', 1, False, False),
        ('x: int = z', 2, False, False),
        ('x: int', 0, True, False),
        ('x: int', 1, False, False),
    ]
)
def test_is_definition(code, name_index, is_definition, include_setitem):
    module = parse(code, version='3.8')
    name = module.get_first_leaf()
    while True:
        if name.type == 'name':
            if name_index == 0:
                break
            name_index -= 1
        name = name.get_next_leaf()

    assert name.is_definition(include_setitem=include_setitem) == is_definition


def test_iter_funcdefs():
    code = dedent('''
        def normal(): ...
        async def asyn(): ...
        @dec
        def dec_normal(): ...
        @dec1
        @dec2
        async def dec_async(): ...
        def broken
        ''')
    module = parse(code, version='3.8')
    func_names = [f.name.value for f in module.iter_funcdefs()]
    assert func_names == ['normal', 'asyn', 'dec_normal', 'dec_async']


def test_with_stmt_get_test_node_from_name():
    code = "with A as X.Y, B as (Z), C as Q[0], D as Q['foo']: pass"
    with_stmt = parse(code, version='3').children[0]
    tests = [
        with_stmt.get_test_node_from_name(name).value
        for name in with_stmt.get_defined_names(include_setitem=True)
    ]
    assert tests == ["A", "B", "C", "D"]


sample_module = parse('x + y')
sample_node = sample_module.children[0]
sample_leaf = sample_node.children[0]


@pytest.mark.parametrize(
    'node,node_types,expected_ancestor', [
        (sample_module, ('file_input',), None),
        (sample_node, ('arith_expr',), None),
        (sample_node, ('file_input', 'eval_input'), sample_module),
        (sample_leaf, ('name',), None),
        (sample_leaf, ('arith_expr',), sample_node),
        (sample_leaf, ('file_input',), sample_module),
        (sample_leaf, ('file_input', 'arith_expr'), sample_node),
        (sample_leaf, ('shift_expr',), None),
        (sample_leaf, ('name', 'shift_expr',), None),
        (sample_leaf, (), None),
    ]
)
def test_search_ancestor(node, node_types, expected_ancestor):
    assert node.search_ancestor(*node_types) is expected_ancestor
    assert search_ancestor(node, *node_types) is expected_ancestor  # deprecated
