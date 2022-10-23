"""
Tests for `api.names`.
"""

from textwrap import dedent

import pytest


def _assert_definition_names(definitions, names):
    assert [d.name for d in definitions] == names


def _check_names(get_names, source, names):
    definitions = get_names(dedent(source))
    _assert_definition_names(definitions, names)
    return definitions


def test_get_definitions_flat(get_names):
    _check_names(get_names, """
        import module
        class Class:
            pass
        def func():
            pass
        data = None
        """, ['module', 'Class', 'func', 'data'])


def test_dotted_assignment(get_names):
    _check_names(get_names, """
    x = Class()
    x.y.z = None
    """, ['x', 'z'])  # TODO is this behavior what we want?


def test_multiple_assignment(get_names):
    _check_names(get_names, "x = y = None", ['x', 'y'])


def test_multiple_imports(get_names):
    _check_names(get_names, """
    from module import a, b
    from another_module import *
    """, ['a', 'b'])


def test_nested_definitions(get_names):
    definitions = _check_names(get_names, """
    class Class:
        def f():
            pass
        def g():
            pass
    """, ['Class'])
    subdefinitions = definitions[0].defined_names()
    _assert_definition_names(subdefinitions, ['f', 'g'])
    assert [d.full_name for d in subdefinitions] == ['__main__.Class.f', '__main__.Class.g']


def test_nested_class(get_names):
    definitions = _check_names(get_names, """
    class L1:
        class L2:
            class L3:
                def f(): pass
            def f(): pass
        def f(): pass
    def f(): pass
    """, ['L1', 'f'])
    subdefs = definitions[0].defined_names()
    subsubdefs = subdefs[0].defined_names()
    _assert_definition_names(subdefs, ['L2', 'f'])
    _assert_definition_names(subsubdefs, ['L3', 'f'])
    _assert_definition_names(subsubdefs[0].defined_names(), ['f'])


def test_class_fields_with_all_scopes_false(get_names):
    definitions = _check_names(get_names, """
    from module import f
    g = f(f)
    class C:
        h = g

    def foo(x=a):
       bar = x
       return bar
    """, ['f', 'g', 'C', 'foo'])
    C_subdefs = definitions[-2].defined_names()
    foo_subdefs = definitions[-1].defined_names()
    _assert_definition_names(C_subdefs, ['h'])
    _assert_definition_names(foo_subdefs, ['x', 'bar'])


def test_async_stmt_with_all_scopes_false(get_names):
    definitions = _check_names(get_names, """
    from module import f
    import asyncio

    g = f(f)
    class C:
        h = g
        def __init__(self):
            pass

        async def __aenter__(self):
            pass

    def foo(x=a):
       bar = x
       return bar

    async def async_foo(duration):
        async def wait():
            await asyncio.sleep(100)
        for i in range(duration//100):
            await wait()
        return duration//100*100

    async with C() as cinst:
        d = cinst
    """, ['f', 'asyncio', 'g', 'C', 'foo', 'async_foo', 'cinst', 'd'])
    C_subdefs = definitions[3].defined_names()
    foo_subdefs = definitions[4].defined_names()
    async_foo_subdefs = definitions[5].defined_names()
    cinst_subdefs = definitions[6].defined_names()
    _assert_definition_names(C_subdefs, ['h', '__init__', '__aenter__'])
    _assert_definition_names(foo_subdefs, ['x', 'bar'])
    _assert_definition_names(async_foo_subdefs, ['duration', 'wait', 'i'])
    # We treat d as a name outside `async with` block
    _assert_definition_names(cinst_subdefs, [])


def test_follow_imports(get_names):
    # github issue #344
    imp = get_names('import datetime')[0]
    assert imp.name == 'datetime'
    datetime_names = [str(d.name) for d in imp.defined_names()]
    assert 'timedelta' in datetime_names


def test_names_twice(get_names):
    code = dedent('''
    def lol():
        pass
    ''')

    defs = get_names(code)
    assert defs[0].defined_names() == []


def test_simple_name(get_names):
    defs = get_names('foo', references=True)
    assert not defs[0]._name.infer()


def test_no_error(get_names):
    code = dedent("""
        def foo(a, b):
            if a == 10:
                if b is None:
                    print("foo")
                a = 20
        """)
    func_name, = get_names(code)
    a, b, a20 = func_name.defined_names()
    assert a.name == 'a'
    assert b.name == 'b'
    assert a20.name == 'a'
    assert a20.goto() == [a20]


@pytest.mark.parametrize(
    'code, index, is_side_effect', [
        ('x', 0, False),
        ('x.x', 0, False),
        ('x.x', 1, False),
        ('x.x = 3', 0, False),
        ('x.x = 3', 1, True),
        ('def x(x): x.x = 3', 1, False),
        ('def x(x): x.x = 3', 3, True),
        ('import sys; sys.path', 0, False),
        ('import sys; sys.path', 1, False),
        ('import sys; sys.path', 2, False),
        ('import sys; sys.path = []', 2, True),
    ]
)
def test_is_side_effect(get_names, code, index, is_side_effect):
    names = get_names(code, references=True, all_scopes=True)
    assert names[index].is_side_effect() == is_side_effect


def test_no_defined_names(get_names):
    definition, = get_names("x = (1, 2)")

    assert not definition.defined_names()
