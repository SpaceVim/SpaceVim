from textwrap import dedent
import inspect
from unittest import TestCase

import pytest

from jedi import cache
from jedi.parser_utils import get_signature
from jedi import Interpreter


def assert_signature(Script, source, expected_name, expected_index=0, line=None, column=None):
    signatures = Script(source).get_signatures(line, column)

    assert len(signatures) <= 1

    if not signatures:
        assert expected_name is None, \
            'There are no signatures, but `%s` expected.' % expected_name
    else:
        assert signatures[0].name == expected_name
        assert signatures[0].index == expected_index
        return signatures[0]


def test_valid_call(Script):
    assert_signature(Script, 'bool()', 'bool', column=5)


class TestSignatures(TestCase):
    @pytest.fixture(autouse=True)
    def init(self, Script):
        self.Script = Script

    def _run_simple(self, source, name, index=0, column=None, line=1):
        assert_signature(self.Script, source, name, index, line, column)

    def test_simple(self):
        run = self._run_simple

        # simple
        s1 = "tuple(a, bool("
        run(s1, 'tuple', 0, 6)
        run(s1, 'tuple', None, 8)
        run(s1, 'tuple', None, 9)
        run(s1, 'bool', 0, 14)

        s2 = "abs(), "
        run(s2, 'abs', 0, 4)
        run(s2, None, column=5)
        run(s2, None)

        s3 = "abs()."
        run(s3, None, column=5)
        run(s3, None)

    def test_more_complicated(self):
        run = self._run_simple

        s4 = 'abs(bool(), , set,'
        run(s4, None, column=3)
        run(s4, 'abs', 0, 4)
        run(s4, 'bool', 0, 9)
        run(s4, 'abs', 0, 10)
        run(s4, 'abs', None, 11)

        s5 = "tuple(1,\nif 2:\n def a():"
        run(s5, 'tuple', 0, 6)
        run(s5, 'tuple', None, 8)

        s6 = "bool().__eq__("
        run(s6, '__eq__', 0)
        run(s6, 'bool', 0, 5)

        s7 = "str().upper().center("
        s8 = "bool(int[abs("
        run(s7, 'center', 0)
        run(s8, 'abs', 0)
        run(s8, 'bool', 0, 10)

        run("import time; abc = time; abc.sleep(", 'sleep', 0)

    def test_issue_57(self):
        # jedi #57
        s = "def func(alpha, beta): pass\n" \
            "func(alpha='101',"
        self._run_simple(s, 'func', 0, column=13, line=2)

    def test_for(self):
        # jedi-vim #11
        self._run_simple("for tuple(", 'tuple', 0)
        self._run_simple("for s in tuple(", 'tuple', 0)


def test_with(Script):
    # jedi-vim #9
    sigs = Script("with open(").get_signatures()
    assert sigs
    assert all(sig.name == 'open' for sig in sigs)


def test_get_signatures_empty_parentheses_pre_space(Script):
    s = dedent("""\
    def f(a, b):
        pass
    f( )""")
    assert_signature(Script, s, 'f', 0, line=3, column=3)


def test_multiple_signatures(Script):
    s = dedent("""\
    if x:
        def f(a, b):
            pass
    else:
        def f(a, b):
            pass
    f(""")
    assert len(Script(s).get_signatures()) == 2


def test_get_signatures_whitespace(Script):
    # note: trailing space after 'abs'
    s = 'abs( \ndef x():\n    pass\n'
    assert_signature(Script, s, 'abs', 0, line=1, column=5)


def test_decorator_in_class(Script):
    """
    There's still an implicit param, with a decorator.
    Github issue #319.
    """
    s = dedent("""\
    def static(func):
        def wrapped(obj, *args):
            return f(type(obj), *args)
        return wrapped

    class C(object):
        @static
        def test(cls):
            return 10

    C().test(""")

    signatures = Script(s).get_signatures()
    assert len(signatures) == 1
    x = [p.description for p in signatures[0].params]
    assert x == ['param *args']


def test_additional_brackets(Script):
    assert_signature(Script, 'abs((', 'abs', 0)


def test_unterminated_strings(Script):
    assert_signature(Script, 'abs(";', 'abs', 0)


def test_whitespace_before_bracket(Script):
    assert_signature(Script, 'abs (', 'abs', 0)
    assert_signature(Script, 'abs (";', 'abs', 0)
    assert_signature(Script, 'abs\n(', None)


def test_brackets_in_string_literals(Script):
    assert_signature(Script, 'abs (" (', 'abs', 0)
    assert_signature(Script, 'abs (" )', 'abs', 0)


def test_function_definitions_should_break(Script):
    """
    Function definitions (and other tokens that cannot exist within call
    signatures) should break and not be able to return a signature.
    """
    assert_signature(Script, 'abs(\ndef x', 'abs', 0)
    assert not Script('abs(\ndef x(): pass').get_signatures()


def test_flow_call(Script):
    assert not Script('if (1').get_signatures()


def test_chained_calls(Script):
    source = dedent('''
    class B():
      def test2(self, arg):
        pass

    class A():
      def test1(self):
        return B()

    A().test1().test2(''')

    assert_signature(Script, source, 'test2', 0)


def test_return(Script):
    source = dedent('''
    def foo():
        return '.'.join()''')

    assert_signature(Script, source, 'join', 0, column=len("    return '.'.join("))


def test_find_signature_on_module(Script):
    """github issue #240"""
    s = 'import datetime; datetime('
    # just don't throw an exception (if numpy doesn't exist, just ignore it)
    assert Script(s).get_signatures() == []


def test_complex(Script, environment):
    s = """
            def abc(a,b):
                pass

            def a(self):
                abc(

            if 1:
                pass
        """
    assert_signature(Script, s, 'abc', 0, line=6, column=20)
    s = """
            import re
            def huhu(it):
                re.compile(
                return it * 2
        """
    sig1, sig2 = sorted(Script(s).get_signatures(line=4, column=27), key=lambda s: s.line)
    assert sig1.name == sig2.name == 'compile'
    assert sig1.index == sig2.index == 0
    func1, = sig1._name.infer()
    func2, = sig2._name.infer()

    # Do these checks just for Python 3, I'm too lazy to deal with this
    # legacy stuff. ~ dave.
    assert get_signature(func1.tree_node) \
        == 'compile(pattern: AnyStr, flags: _FlagsType = ...) -> Pattern[AnyStr]'
    assert get_signature(func2.tree_node) \
        == 'compile(pattern: Pattern[AnyStr], flags: _FlagsType = ...) ->\nPattern[AnyStr]'

    # jedi-vim #70
    s = """def foo("""
    assert Script(s).get_signatures() == []

    # jedi-vim #116
    s = """import itertools; test = getattr(itertools, 'chain'); test("""
    assert_signature(Script, s, 'chain', 0)


def _params(Script, source, line=None, column=None):
    signatures = Script(source).get_signatures(line, column)
    assert len(signatures) == 1
    return signatures[0].params


def test_int_params(Script):
    sig1, sig2 = Script('int(').get_signatures()
    # int is defined as: `int(x[, base])`
    assert len(sig1.params) == 1
    assert sig1.params[0].name == 'x'
    assert len(sig2.params) == 2
    assert sig2.params[0].name == 'x'
    assert sig2.params[1].name == 'base'


def test_pow_params(Script):
    # See Github #1357.
    for sig in Script('pow(').get_signatures():
        param_names = [p.name for p in sig.params]
        assert param_names in (['base', 'exp'], ['base', 'exp', 'mod'])


def test_param_name(Script):
    sigs = Script('open(something,').get_signatures()
    for sig in sigs:
        # All of the signatures (in Python the function is overloaded),
        # contain the same param names.
        assert sig.params[0].name in ['file', 'name']
        assert sig.params[1].name == 'mode'
        assert sig.params[2].name == 'buffering'


def test_builtins(Script):
    """
    The self keyword should be visible even for builtins, if not
    instantiated.
    """
    p = _params(Script, 'str.endswith(')
    assert p[0].name == 'self'
    assert p[1].name == 'suffix'
    p = _params(Script, 'str().endswith(')
    assert p[0].name == 'suffix'


def test_signature_is_definition(Script):
    """
    Through inheritance, a signature is a sub class of Name.
    Check if the attributes match.
    """
    s = """class Spam(): pass\nSpam"""
    signature = Script(s + '(').get_signatures()[0]
    definition = Script(s + '(').infer(column=0)[0]
    signature.line == 1
    signature.column == 6

    # Now compare all the attributes that a Signature must also have.
    for attr_name in dir(definition):
        dont_scan = ['defined_names', 'parent', 'goto_assignments', 'infer',
                     'params', 'get_signatures', 'execute', 'goto',
                     'desc_with_module']
        if attr_name.startswith('_') or attr_name in dont_scan:
            continue

        attribute = getattr(definition, attr_name)
        signature_attribute = getattr(signature, attr_name)
        if inspect.ismethod(attribute):
            assert attribute() == signature_attribute()
        else:
            assert attribute == signature_attribute


def test_no_signature(Script):
    # str doesn't have a __call__ method
    assert Script('str()(').get_signatures() == []

    s = dedent("""\
    class X():
        pass
    X()(""")
    assert Script(s).get_signatures() == []
    assert len(Script(s).get_signatures(column=2)) == 1
    assert Script('').get_signatures() == []


def test_dict_literal_in_incomplete_call(Script):
    source = """\
    import json

    def foo():
        json.loads(

        json.load.return_value = {'foo': [],
                                  'bar': True}

        c = Foo()
    """

    script = Script(dedent(source))
    assert script.get_signatures(line=4, column=15)


def test_completion_interference(Script):
    """Seems to cause problems, see also #396."""
    cache.parser_cache.pop(None, None)
    assert Script('open(').get_signatures()

    # complete something usual, before doing the same get_signatures again.
    assert Script('from datetime import ').complete()

    assert Script('open(').get_signatures()


def test_keyword_argument_index(Script, environment):
    def get(source, column=None):
        return Script(source).get_signatures(column=column)[0]

    assert get('sorted([], key=a').index == 1
    assert get('sorted([], key=').index == 1
    assert get('sorted([], no_key=a').index is None

    kw_func = 'def foo(a, b): pass\nfoo(b=3, a=4)'
    assert get(kw_func, column=len('foo(b')).index == 0
    assert get(kw_func, column=len('foo(b=')).index == 1
    assert get(kw_func, column=len('foo(b=3, a=')).index == 0

    kw_func_simple = 'def foo(a, b): pass\nfoo(b=4)'
    assert get(kw_func_simple, column=len('foo(b')).index == 0
    assert get(kw_func_simple, column=len('foo(b=')).index == 1

    args_func = 'def foo(*kwargs): pass\n'
    assert get(args_func + 'foo(a').index == 0
    assert get(args_func + 'foo(a, b').index == 0

    kwargs_func = 'def foo(**kwargs): pass\n'
    assert get(kwargs_func + 'foo(a=2').index == 0
    assert get(kwargs_func + 'foo(a=2, b=2').index == 0

    both = 'def foo(*args, **kwargs): pass\n'
    assert get(both + 'foo(a=2').index == 1
    assert get(both + 'foo(a=2, b=2').index == 1
    assert get(both + 'foo(a=2, b=2)', column=len('foo(b=2, a=2')).index == 1
    assert get(both + 'foo(a, b, c').index == 0


code1 = 'def f(u, /, v=3, *, abc, abd, xyz): pass'
code2 = 'def g(u, /, v=3, *, abc, abd, xyz, **kwargs): pass'
code3 = 'def h(u, /, v, *args, x=1, y): pass'
code4 = 'def i(u, /, v, *args, x=1, y, **kwargs): pass'


_calls = [
    # No *args, **kwargs
    (code1, 'f(', 0),
    (code1, 'f(a', 0),
    (code1, 'f(a,', 1),
    (code1, 'f(a,b', 1),
    (code1, 'f(a,b,', 2),
    (code1, 'f(a,b,c', None),
    (code1, 'f(a,b,a', 2),
    (code1, 'f(a,b,a=', None),
    (code1, 'f(a,b,abc', 2),
    (code1, 'f(a,b,abc=(', 2),
    (code1, 'f(a,b,abc=(f,1,2,3', 2),
    (code1, 'f(a,b,abd', 3),
    (code1, 'f(a,b,x', 4),
    (code1, 'f(a,b,xy', 4),
    (code1, 'f(a,b,xyz=', 4),
    (code1, 'f(a,b,xy=', None),
    (code1, 'f(u=', (0, None)),
    (code1, 'f(v=', 1),

    # **kwargs
    (code2, 'g(a,b,a', 2),
    (code2, 'g(a,b,abc', 2),
    (code2, 'g(a,b,abd', 3),
    (code2, 'g(a,b,arr', 5),
    (code2, 'g(a,b,xy', 4),
    (code2, 'g(a,b,xyz=', 4),
    (code2, 'g(a,b,xy=', 5),
    (code2, 'g(a,b,abc=1,abd=4,', 4),
    (code2, 'g(a,b,abc=1,xyz=3,abd=4,', 5),
    (code2, 'g(a,b,abc=1,abd=4,lala', 5),
    (code2, 'g(a,b,abc=1,abd=4,lala=', 5),
    (code2, 'g(a,b,abc=1,abd=4,abd=', 5),
    (code2, 'g(a,b,kw', 5),
    (code2, 'g(a,b,kwargs=', 5),
    (code2, 'g(u=', (0, 5)),
    (code2, 'g(v=', 1),

    # *args
    (code3, 'h(a,b,c', 2),
    (code3, 'h(a,b,c,', 2),
    (code3, 'h(a,b,c,d', 2),
    (code3, 'h(a,b,c,d[', 2),
    (code3, 'h(a,b,c,(3,', 2),
    (code3, 'h(a,b,c,(3,)', 2),
    (code3, 'h(a,b,args=', None),
    (code3, 'h(u,v=', 1),
    (code3, 'h(u=', (0, None)),
    (code3, 'h(u,*xxx', 1),
    (code3, 'h(u,*xxx,*yyy', 1),
    (code3, 'h(u,*[]', 1),
    (code3, 'h(u,*', 1),
    (code3, 'h(u,*, *', 1),
    (code3, 'h(u,1,**', 3),
    (code3, 'h(u,**y', 1),
    (code3, 'h(u,x=2,**', 1),
    (code3, 'h(u,x=2,**y', 1),
    (code3, 'h(u,v=2,**y', 3),
    (code3, 'h(u,x=2,**vv', 1),

    # *args, **kwargs
    (code4, 'i(a,b,c,d', 2),
    (code4, 'i(a,b,c,d,e', 2),
    (code4, 'i(a,b,c,d,e=', 5),
    (code4, 'i(a,b,c,d,e=3', 5),
    (code4, 'i(a,b,c,d=,x=', 3),
    (code4, 'i(a,b,c,d=5,x=4', 3),
    (code4, 'i(a,b,c,d=5,x=4,y', 4),
    (code4, 'i(a,b,c,d=5,x=4,y=3,', 5),
    (code4, 'i(a,b,c,d=5,y=4,x=3,', 5),
    (code4, 'i(a,b,c,d=4,', 3),
    (code4, 'i(a,b,c,x=1,d=,', 4),

    # Error nodes
    (code4, 'i(1, [a,b', 1),
    (code4, 'i(1, [a,b=,', 2),
    (code4, 'i(1, [a?b,', 2),
    (code4, 'i(1, [a?b,*', 2),
    (code4, 'i(?b,*r,c', 1),
    (code4, 'i(?*', 0),
    (code4, 'i(?**', (0, 1)),

    # Random
    (code4, 'i(()', 0),
    (code4, 'i((),', 1),
    (code4, 'i([(),', 0),
    (code4, 'i([(,', 1),
    (code4, 'i(x,()', 1),
]


@pytest.mark.parametrize('ending', ['', ')'])
@pytest.mark.parametrize('code, call, expected_index', _calls)
def test_signature_index(Script, environment, code, call, expected_index, ending):
    if isinstance(expected_index, tuple):
        expected_index = expected_index[environment.version_info > (3, 8)]
    if environment.version_info < (3, 8):
        code = code.replace('/,', '')

    sig, = Script(code + '\n' + call + ending).get_signatures(column=len(call))
    index = sig.index
    assert expected_index == index


@pytest.mark.parametrize('code', ['foo', 'instance.foo'])
def test_arg_defaults(Script, environment, code):
    def foo(arg="bla", arg1=1):
        pass

    class Klass:
        def foo(self, arg="bla", arg1=1):
            pass

    instance = Klass()

    src = dedent("""
        def foo2(arg="bla", arg1=1):
            pass

        class Klass2:
            def foo2(self, arg="bla", arg1=1):
                pass

        instance = Klass2()
        """)

    executed_locals = dict()
    exec(src, None, executed_locals)
    locals_ = locals()

    def iter_scripts():
        yield Interpreter(code + '(', namespaces=[locals_])
        yield Script(src + code + "2(")
        yield Interpreter(code + '2(', namespaces=[executed_locals])

    for script in iter_scripts():
        signatures = script.get_signatures()
        assert signatures[0].params[0].description in ('param arg="bla"', "param arg='bla'")
        assert signatures[0].params[1].description == 'param arg1=1'


def test_bracket_start(Script):
    def bracket_start(src):
        signatures = Script(src).get_signatures()
        assert len(signatures) == 1
        return signatures[0].bracket_start

    assert bracket_start('abs(') == (1, 3)


def test_different_caller(Script):
    """
    It's possible to not use names, but another function result or an array
    index and then get the signature of it.
    """

    assert_signature(Script, '[abs][0](', 'abs', 0)
    assert_signature(Script, '[abs][0]()', 'abs', 0, column=len('[abs][0]('))

    assert_signature(Script, '(abs)(', 'abs', 0)
    assert_signature(Script, '(abs)()', 'abs', 0, column=len('(abs)('))


def test_in_function(Script):
    code = dedent('''\
    class X():
        @property
        def func(''')
    assert not Script(code).get_signatures()


def test_lambda_params(Script):
    code = dedent('''\
    my_lambda = lambda x: x+1
    my_lambda(1)''')
    sig, = Script(code).get_signatures(column=11)
    assert sig.index == 0
    assert sig.name == '<lambda>'
    assert [p.name for p in sig.params] == ['x']


CLASS_CODE = dedent('''\
class X():
    def __init__(self, foo, bar):
        self.foo = foo
''')


def test_class_creation(Script):

    sig, = Script(CLASS_CODE + 'X(').get_signatures()
    assert sig.index == 0
    assert sig.name == 'X'
    assert [p.name for p in sig.params] == ['foo', 'bar']


def test_call_init_on_class(Script):
    sig, = Script(CLASS_CODE + 'X.__init__(').get_signatures()
    assert [p.name for p in sig.params] == ['self', 'foo', 'bar']


def test_call_init_on_instance(Script):
    sig, = Script(CLASS_CODE + 'X().__init__(').get_signatures()
    assert [p.name for p in sig.params] == ['foo', 'bar']


def test_call_magic_method(Script):
    code = dedent('''\
    class X():
        def __call__(self, baz):
            pass
    ''')
    sig, = Script(code + 'X()(').get_signatures()
    assert sig.index == 0
    assert sig.name == 'X'
    assert [p.name for p in sig.params] == ['baz']

    sig, = Script(code + 'X.__call__(').get_signatures()
    assert [p.name for p in sig.params] == ['self', 'baz']
    sig, = Script(code + 'X().__call__(').get_signatures()
    assert [p.name for p in sig.params] == ['baz']


@pytest.mark.parametrize('column', [6, 9])
def test_cursor_after_signature(Script, column):
    source = dedent("""
        def foo(*args):
            pass
        foo()  # _
        """)

    script = Script(source)

    assert not script.get_signatures(4, column)


@pytest.mark.parametrize(
    'code, line, column, name, index', [
        ('abs(()\ndef foo(): pass', 1, None, 'abs', 0),
        ('abs(chr()  \ndef foo(): pass', 1, 10, 'abs', 0),
        ('abs(chr()\ndef foo(): pass', 1, None, 'abs', 0),
        ('abs(chr()\ndef foo(): pass', 1, 8, 'chr', 0),
        ('abs(chr()\ndef foo(): pass', 1, 7, 'abs', 0),
        ('abs(chr  ( \nclass y: pass', 1, None, 'chr', 0),
        ('abs(chr  ( \nclass y: pass', 1, 8, 'abs', 0),
        ('abs(chr  ( \nclass y: pass', 1, 9, 'abs', 0),
        ('abs(chr  ( \nclass y: pass', 1, 10, 'chr', 0),
    ]
)
def test_base_signatures(Script, code, line, column, name, index):
    sig, = Script(code).get_signatures(line=line, column=column)

    assert sig.name == name
    assert sig.index == index
