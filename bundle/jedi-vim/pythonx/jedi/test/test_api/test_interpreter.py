"""
Tests of ``jedi.api.Interpreter``.
"""
import sys
import warnings
import typing

import pytest

import jedi
from jedi.inference.compiled import mixed
from importlib import import_module


class _GlobalNameSpace:
    class SideEffectContainer:
        pass


def get_completion(source, namespace):
    i = jedi.Interpreter(source, [namespace])
    completions = i.complete()
    assert len(completions) == 1
    return completions[0]


def test_builtin_details():
    import keyword

    class EmptyClass:
        pass

    variable = EmptyClass()

    def func():
        pass

    cls = get_completion('EmptyClass', locals())
    var = get_completion('variable', locals())
    f = get_completion('func', locals())
    m = get_completion('keyword', locals())
    assert cls.type == 'class'
    assert var.type == 'instance'
    assert f.type == 'function'
    assert m.type == 'module'


def test_numpy_like_non_zero():
    """
    Numpy-like array can't be caster to bool and need to be compacre with
    `is`/`is not` and not `==`/`!=`
    """

    class NumpyNonZero:

        def __zero__(self):
            raise ValueError('Numpy arrays would raise and tell you to use .any() or all()')
        def __bool__(self):
            raise ValueError('Numpy arrays would raise and tell you to use .any() or all()')

    class NumpyLike:

        def __eq__(self, other):
            return NumpyNonZero()

        def something(self):
            pass

    x = NumpyLike()
    d = {'a': x}

    # just assert these do not raise. They (strangely) trigger different
    # codepath
    get_completion('d["a"].some', {'d': d})
    get_completion('x.some', {'x': x})


def test_nested_resolve():
    class XX:
        def x():
            pass

    cls = get_completion('XX', locals())
    func = get_completion('XX.x', locals())
    assert (func.line, func.column) == (cls.line + 1, 12)


def test_side_effect_completion():
    """
    In the repl it's possible to cause side effects that are not documented in
    Python code, however we want references to Python code as well. Therefore
    we need some mixed kind of magic for tests.
    """
    _GlobalNameSpace.SideEffectContainer.foo = 1
    side_effect = get_completion('SideEffectContainer', _GlobalNameSpace.__dict__)

    # It's a class that contains MixedObject.
    value, = side_effect._name.infer()
    assert isinstance(value, mixed.MixedObject)
    foo = get_completion('SideEffectContainer.foo', _GlobalNameSpace.__dict__)
    assert foo.name == 'foo'


def _assert_interpreter_complete(source, namespace, completions,
                                 **kwds):
    script = jedi.Interpreter(source, [namespace], **kwds)
    cs = script.complete()
    actual = [c.name for c in cs]
    assert sorted(actual) == sorted(completions)


def test_complete_raw_function():
    from os.path import join
    _assert_interpreter_complete('join("").up', locals(), ['upper'])


def test_complete_raw_function_different_name():
    from os.path import join as pjoin
    _assert_interpreter_complete('pjoin("").up', locals(), ['upper'])


def test_complete_raw_module():
    import os
    _assert_interpreter_complete('os.path.join("a").up', locals(), ['upper'])


def test_complete_raw_instance():
    import datetime
    dt = datetime.datetime(2013, 1, 1)
    completions = ['time', 'timetz', 'timetuple', 'timestamp']
    _assert_interpreter_complete('(dt - dt).ti', locals(), completions)


def test_list():
    array = ['haha', 1]
    _assert_interpreter_complete('array[0].uppe', locals(), ['upper'])
    _assert_interpreter_complete('array[0].real', locals(), [])

    # something different, no index given, still just return the right
    _assert_interpreter_complete('array[int].real', locals(), ['real'])
    _assert_interpreter_complete('array[int()].real', locals(), ['real'])
    # inexistent index
    _assert_interpreter_complete('array[2].upper', locals(), ['upper'])


def test_getattr():
    class Foo1:
        bar = []
    baz = 'bar'
    _assert_interpreter_complete('getattr(Foo1, baz).app', locals(), ['append'])


def test_slice():
    class Foo1:
        bar = []
    baz = 'xbarx'
    _assert_interpreter_complete('getattr(Foo1, baz[1:-1]).append', locals(), ['append'])


def test_getitem_side_effects():
    class Foo2:
        def __getitem__(self, index):
            # Possible side effects here, should therefore not call this.
            if True:
                raise NotImplementedError()
            return index

    foo = Foo2()
    _assert_interpreter_complete('foo["asdf"].upper', locals(), ['upper'])


@pytest.mark.parametrize('stacklevel', [1, 2])
@pytest.mark.filterwarnings("error")
def test_property_warnings(stacklevel, allow_unsafe_getattr):
    class Foo3:
        @property
        def prop(self):
            # Possible side effects here, should therefore not call this.
            warnings.warn("foo", DeprecationWarning, stacklevel=stacklevel)
            return ''

    foo = Foo3()
    expected = ['upper'] if allow_unsafe_getattr else []
    _assert_interpreter_complete('foo.prop.uppe', locals(), expected)


@pytest.mark.parametrize('class_is_findable', [False, True])
def test__getattr__completions(allow_unsafe_getattr, class_is_findable):
    class CompleteGetattr(object):
        def __getattr__(self, name):
            if name == 'foo':
                return self
            if name == 'fbar':
                return ''
            raise AttributeError(name)

        def __dir__(self):
            return ['foo', 'fbar'] + object.__dir__(self)

    if not class_is_findable:
        CompleteGetattr.__name__ = "something_somewhere"
    namespace = {'c': CompleteGetattr()}
    expected = ['foo', 'fbar']
    _assert_interpreter_complete('c.f', namespace, expected)

    # Completions don't work for class_is_findable, because __dir__ is checked
    # for interpreter analysis, but if the static analysis part tries to help
    # it will not work. However static analysis is pretty good and understands
    # how gettatr works (even the ifs/comparisons).
    if not allow_unsafe_getattr:
        expected = []
    _assert_interpreter_complete('c.foo.f', namespace, expected)
    _assert_interpreter_complete('c.foo.foo.f', namespace, expected)
    _assert_interpreter_complete('c.foo.uppe', namespace, [])

    expected_int = ['upper'] if allow_unsafe_getattr or class_is_findable else []
    _assert_interpreter_complete('c.foo.fbar.uppe', namespace, expected_int)


@pytest.fixture(params=[False, True])
def allow_unsafe_getattr(request, monkeypatch):
    monkeypatch.setattr(jedi.Interpreter, '_allow_descriptor_getattr_default', request.param)
    return request.param


def test_property_error_oldstyle(allow_unsafe_getattr):
    lst = []

    class Foo3:
        @property
        def bar(self):
            lst.append(1)
            raise ValueError

    foo = Foo3()
    _assert_interpreter_complete('foo.bar', locals(), ['bar'])
    _assert_interpreter_complete('foo.bar.baz', locals(), [])

    if allow_unsafe_getattr:
        assert lst == [1]
    else:
        # There should not be side effects
        assert lst == []


def test_property_error_newstyle(allow_unsafe_getattr):
    lst = []

    class Foo3(object):
        @property
        def bar(self):
            lst.append(1)
            raise ValueError

    foo = Foo3()
    _assert_interpreter_complete('foo.bar', locals(), ['bar'])
    _assert_interpreter_complete('foo.bar.baz', locals(), [])

    if allow_unsafe_getattr:
        assert lst == [1]
    else:
        # There should not be side effects
        assert lst == []


def test_property_content():
    class Foo3(object):
        @property
        def bar(self):
            return 1

    foo = Foo3()
    def_, = jedi.Interpreter('foo.bar', [locals()]).infer()
    assert def_.name == 'int'


def test_param_completion():
    def foo(bar):
        pass

    lambd = lambda xyz: 3

    _assert_interpreter_complete('foo(bar', locals(), ['bar='])
    _assert_interpreter_complete('lambd(xyz', locals(), ['xyz='])


def test_endless_yield():
    lst = [1] * 10000
    # If iterating over lists it should not be possible to take an extremely
    # long time.
    _assert_interpreter_complete('list(lst)[9000].rea', locals(), ['real'])


def test_completion_params():
    foo = lambda a, b=3: None

    script = jedi.Interpreter('foo', [locals()])
    c, = script.complete()
    sig, = c.get_signatures()
    assert [p.name for p in sig.params] == ['a', 'b']
    assert sig.params[0].infer() == []
    t, = sig.params[1].infer()
    assert t.name == 'int'


def test_completion_param_annotations():
    # Need to define this function not directly in Python. Otherwise Jedi is too
    # clever and uses the Python code instead of the signature object.
    code = 'def foo(a: 1, b: str, c: int = 1.0) -> bytes: pass'
    exec(code, locals())
    script = jedi.Interpreter('foo', [locals()])
    c, = script.complete()
    sig, = c.get_signatures()
    a, b, c = sig.params
    assert a.infer() == []
    assert [d.name for d in b.infer()] == ['str']
    assert {d.name for d in c.infer()} == {'int', 'float'}

    assert a.description == 'param a: 1'
    assert b.description == 'param b: str'
    assert c.description == 'param c: int=1.0'

    d, = jedi.Interpreter('foo()', [locals()]).infer()
    assert d.name == 'bytes'


def test_keyword_argument():
    def f(some_keyword_argument):
        pass

    c, = jedi.Interpreter("f(some_keyw", [{'f': f}]).complete()
    assert c.name == 'some_keyword_argument='
    assert c.complete == 'ord_argument='

    # Make it impossible for jedi to find the source of the function.
    f.__name__ = 'xSOMETHING'
    c, = jedi.Interpreter("x(some_keyw", [{'x': f}]).complete()
    assert c.name == 'some_keyword_argument='


def test_more_complex_instances():
    class Something:
        def foo(self, other):
            return self

    class Base:
        def wow(self):
            return Something()

    script = jedi.Interpreter('Base().wow().foo', [locals()])
    c, = script.complete()
    assert c.name == 'foo'

    x = Base()
    script = jedi.Interpreter('x.wow().foo', [locals()])
    c, = script.complete()
    assert c.name == 'foo'


def test_repr_execution_issue():
    """
    Anticipate inspect.getfile executing a __repr__ of all kinds of objects.
    See also #919.
    """
    class ErrorRepr:
        def __repr__(self):
            raise Exception('xyz')

    er = ErrorRepr()

    script = jedi.Interpreter('er', [locals()])
    d, = script.infer()
    assert d.name == 'ErrorRepr'
    assert d.type == 'instance'


def test_dir_magic_method(allow_unsafe_getattr):
    class CompleteAttrs(object):
        def __getattr__(self, name):
            if name == 'foo':
                return 1
            if name == 'bar':
                return 2
            raise AttributeError(name)

        def __dir__(self):
            return ['foo', 'bar'] + object.__dir__(self)

    itp = jedi.Interpreter("ca.", [{'ca': CompleteAttrs()}])
    completions = itp.complete()
    names = [c.name for c in completions]
    assert ('__dir__' in names) is True
    assert '__class__' in names
    assert 'foo' in names
    assert 'bar' in names

    foo = [c for c in completions if c.name == 'foo'][0]
    if allow_unsafe_getattr:
        inst, = foo.infer()
        assert inst.name == 'int'
        assert inst.type == 'instance'
    else:
        assert foo.infer() == []


def test_name_not_findable():
    class X():
        if 0:
            NOT_FINDABLE

        def hidden(self):
            return

        hidden.__name__ = 'NOT_FINDABLE'

    setattr(X, 'NOT_FINDABLE', X.hidden)

    assert jedi.Interpreter("X.NOT_FINDA", [locals()]).complete()


def test_stubs_working():
    from multiprocessing import cpu_count
    defs = jedi.Interpreter("cpu_count()", [locals()]).infer()
    assert [d.name for d in defs] == ['int']


def test_sys_path_docstring():  # Was an issue in #1298
    import jedi
    s = jedi.Interpreter("from sys import path\npath", namespaces=[locals()])
    s.complete(line=2, column=4)[0].docstring()


@pytest.mark.parametrize(
    'code, completions', [
        ('x[0].uppe', ['upper']),
        ('x[1337].uppe', ['upper']),
        ('x[""].uppe', ['upper']),
        ('x.appen', ['append']),

        ('y.add', ['add']),
        ('y[0].', []),
        ('list(y)[0].', []),  # TODO use stubs properly to improve this.

        ('z[0].uppe', ['upper']),
        ('z[0].append', ['append']),
        ('z[1].uppe', ['upper']),
        ('z[1].append', []),

        ('collections.deque().app', ['append', 'appendleft']),
        ('deq.app', ['append', 'appendleft']),
        ('deq.pop', ['pop', 'popleft']),
        ('deq.pop().', []),

        ('collections.Counter("asdf").setdef', ['setdefault']),
        ('collections.Counter("asdf").pop().imag', ['imag']),
        ('list(collections.Counter("asdf").keys())[0].uppe', ['upper']),
        ('counter.setdefa', ['setdefault']),
        ('counter.pop().imag', []),  # TODO stubs could make this better
        ('counter.keys())[0].uppe', []),

        ('string.upper().uppe', ['upper']),
        ('"".upper().uppe', ['upper']),
    ]
)
def test_simple_completions(code, completions):
    x = [str]
    y = {1}
    z = {1: str, 2: list}
    import collections
    deq = collections.deque([1])
    counter = collections.Counter(['asdf'])
    string = ''

    defs = jedi.Interpreter(code, [locals()]).complete()
    assert [d.name for d in defs] == completions


def test__wrapped__():
    from functools import lru_cache

    @lru_cache(maxsize=128)
    def syslogs_to_df():
        pass

    c, = jedi.Interpreter('syslogs_to_df', [locals()]).complete()
    # Apparently the function starts on the line where the decorator starts.
    assert c.line == syslogs_to_df.__wrapped__.__code__.co_firstlineno + 1


def test_illegal_class_instance():
    class X:
        __class__ = 1
    X.__name__ = 'asdf'
    d, = jedi.Interpreter('foo', [{'foo': X()}]).infer()
    v, = d._name.infer()
    assert not v.is_instance()


@pytest.mark.parametrize('module_name', ['sys', 'time', 'unittest.mock'])
def test_core_module_completes(module_name):
    module = import_module(module_name)
    assert jedi.Interpreter('module.', [locals()]).complete()


@pytest.mark.parametrize(
    'code, expected, index', [
        ('a(', ['a', 'b', 'c'], 0),
        ('b(', ['b', 'c'], 0),
        # Might or might not be correct, because c is given as a keyword
        # argument as well, but that is just what inspect.signature returns.
        ('c(', ['b', 'c'], 0),
    ]
)
def test_partial_signatures(code, expected, index):
    import functools

    def func(a, b, c):
        pass

    a = functools.partial(func)
    b = functools.partial(func, 1)
    c = functools.partial(func, 1, c=2)

    sig, = jedi.Interpreter(code, [locals()]).get_signatures()
    assert sig.name == 'partial'
    assert [p.name for p in sig.params] == expected
    assert index == sig.index


def test_type_var():
    """This was an issue before, see Github #1369"""
    import typing
    x = typing.TypeVar('myvar')
    def_, = jedi.Interpreter('x', [locals()]).infer()
    assert def_.name == 'TypeVar'


@pytest.mark.parametrize('class_is_findable', [False, True])
def test_param_annotation_completion(class_is_findable):
    class Foo:
        bar = 3

    if not class_is_findable:
        Foo.__name__ = 'asdf'

    code = 'def CallFoo(x: Foo):\n x.ba'
    def_, = jedi.Interpreter(code, [locals()]).complete()
    assert def_.name == 'bar'


@pytest.mark.parametrize(
    'code, column, expected', [
        ('strs[', 5, ["'asdf'", "'fbar'", "'foo'", Ellipsis]),
        ('strs[]', 5, ["'asdf'", "'fbar'", "'foo'", Ellipsis]),
        ("strs['", 6, ["asdf'", "fbar'", "foo'"]),
        ("strs[']", 6, ["asdf'", "fbar'", "foo'"]),
        ('strs["]', 6, ['asdf"', 'fbar"', 'foo"']),

        ('mixed[', 6, [r"'a\\sdf'", '1', '1.1', "b'foo'", Ellipsis]),
        ('mixed[1', 7, ['', '.1']),
        ('mixed[Non', 9, ['e']),

        ('implicit[10', None, ['00']),

        ('inherited["', None, ['blablu"']),
    ]
)
def test_dict_completion(code, column, expected):
    strs = {'asdf': 1, """foo""": 2, r'fbar': 3}
    mixed = {1: 2, 1.10: 4, None: 6, r'a\sdf': 8, b'foo': 9}

    class Inherited(dict):
        pass
    inherited = Inherited(blablu=3)

    namespaces = [locals(), {'implicit': {1000: 3}}]
    comps = jedi.Interpreter(code, namespaces).complete(column=column)
    if Ellipsis in expected:
        # This means that global completions are part of this, so filter all of
        # that out.
        comps = [c for c in comps if not c._name.is_value_name and not c.is_keyword]
        expected = [e for e in expected if e is not Ellipsis]

    assert [c.complete for c in comps] == expected


@pytest.mark.parametrize(
    'code, types', [
        ('dct[1]', ['int']),
        ('dct["asdf"]', ['float']),
        ('dct[r"asdf"]', ['float']),
        ('dct["a"]', ['float', 'int']),
    ]
)
def test_dict_getitem(code, types):
    dct = {1: 2, "asdf": 1.0}

    comps = jedi.Interpreter(code, [locals()]).infer()
    assert [c.name for c in comps] == types


@pytest.mark.parametrize('class_is_findable', [False, True])
@pytest.mark.parametrize(
    'code, expected', [
        ('DunderCls()[0]', 'int'),
        ('dunder[0]', 'int'),
        ('next(DunderCls())', 'float'),
        ('next(dunder)', 'float'),
        ('for x in DunderCls(): x', 'str'),
        #('for x in dunder: x', 'str'),
    ]
)
def test_dunders(class_is_findable, code, expected):
    from typing import Iterator

    class DunderCls:
        def __getitem__(self, key) -> int:
            pass

        def __iter__(self, key) -> Iterator[str]:
            pass

        def __next__(self, key) -> float:
            pass

    if not class_is_findable:
        DunderCls.__name__ = 'asdf'

    dunder = DunderCls()

    n, = jedi.Interpreter(code, [locals()]).infer()
    assert n.name == expected


def foo():
    raise KeyError


def bar():
    return float


@pytest.mark.parametrize(
    'annotations, result, code', [
        ({}, [], ''),
        (None, [], ''),
        ({'asdf': 'str'}, [], ''),

        ({'return': 'str'}, ['str'], ''),
        ({'return': 'None'}, ['NoneType'], ''),
        ({'return': 'str().upper'}, [], ''),
        ({'return': 'foo()'}, [], ''),
        ({'return': 'bar()'}, ['float'], ''),

        # typing is available via globals.
        ({'return': 'typing.Union[str, int]'}, ['int', 'str'], ''),
        ({'return': 'typing.Union["str", int]'},
         ['int', 'str'] if sys.version_info >= (3, 9) else ['int'], ''),
        ({'return': 'typing.Union["str", 1]'}, [], ''),
        ({'return': 'typing.Optional[str]'}, ['NoneType', 'str'], ''),
        ({'return': 'typing.Optional[str, int]'}, [], ''),  # Takes only one arg
        ({'return': 'typing.Any'}, [], ''),

        ({'return': 'typing.Tuple[int, str]'},
         ['Tuple' if sys.version_info[:2] == (3, 6) else 'tuple'], ''),
        ({'return': 'typing.Tuple[int, str]'}, ['int'], 'x()[0]'),
        ({'return': 'typing.Tuple[int, str]'}, ['str'], 'x()[1]'),
        ({'return': 'typing.Tuple[int, str]'}, [], 'x()[2]'),

        ({'return': 'typing.List'}, ['list'], 'list'),
        ({'return': 'typing.List[int]'}, ['list'], 'list'),
        ({'return': 'typing.List[int]'}, ['int'], 'x()[0]'),
        ({'return': 'typing.List[int, str]'}, [], 'x()[0]'),

        ({'return': 'typing.Iterator[int]'}, [], 'x()[0]'),
        ({'return': 'typing.Iterator[int]'}, ['int'], 'next(x())'),
        ({'return': 'typing.Iterable[float]'}, ['float'], 'list(x())[0]'),

        ({'return': 'decimal.Decimal'}, [], ''),
        ({'return': 'lalalalallalaa'}, [], ''),
        ({'return': 'lalalalallalaa.lala'}, [], ''),
    ]
)
def test_string_annotation(annotations, result, code):
    x = lambda foo: 1
    x.__annotations__ = annotations
    defs = jedi.Interpreter(code or 'x()', [locals()]).infer()
    assert [d.name for d in defs] == result


def test_name_not_inferred_properly():
    """
    In IPython notebook it is typical that some parts of the code that is
    provided was already executed. In that case if something is not properly
    inferred, it should still infer from the variables it already knows.
    """
    x = 1
    d, = jedi.Interpreter('x = UNDEFINED; x', [locals()]).infer()
    assert d.name == 'int'


def test_variable_reuse():
    x = 1
    d, = jedi.Interpreter('y = x\ny', [locals()]).infer()
    assert d.name == 'int'


def test_negate():
    code = "x = -y"
    x, = jedi.Interpreter(code, [{'y': 3}]).infer(1, 0)
    assert x.name == 'int'
    value, = x._name.infer()
    assert value.get_safe_value() == -3


def test_complete_not_findable_class_source():
    class TestClass():
        ta=1
        ta1=2

    # Simulate the environment where the class is defined in
    # an interactive session and therefore inspect module
    # cannot find its source code and raises OSError (Py 3.10+) or TypeError.
    TestClass.__module__ = "__main__"
    # There is a pytest __main__ module we have to remove temporarily.
    module = sys.modules.pop("__main__")
    try:
        interpreter = jedi.Interpreter("TestClass.", [locals()])
        completions = interpreter.complete(column=10, line=1)
    finally:
        sys.modules["__main__"] = module

    assert "ta" in [c.name for c in completions]
    assert "ta1" in [c.name for c in completions]


def test_param_infer_default():
    abs_sig, = jedi.Interpreter('abs(', [{'abs': abs}]).get_signatures()
    param, = abs_sig.params
    assert param.name == 'x'
    assert param.infer_default() == []
