""" Test all things related to the ``jedi.api_classes`` module.
"""

from textwrap import dedent
from inspect import cleandoc

import pytest

import jedi
from jedi import __doc__ as jedi_doc
from jedi.inference.compiled import CompiledValueName
from ..helpers import get_example_dir


def test_is_keyword(Script):
    results = Script('str', path=None).infer(1, 1)
    assert len(results) == 1 and results[0].is_keyword is False


def test_basedefinition_type(Script, get_names):
    def make_definitions():
        """
        Return a list of definitions for parametrized tests.

        :rtype: [jedi.api_classes.BaseName]
        """
        source = dedent("""
        import sys

        class C:
            pass

        x = C()

        def f():
            pass

        def g():
            yield

        h = lambda: None
        """)

        definitions = []
        definitions += get_names(source)

        source += dedent("""
        variable = sys or C or x or f or g or g() or h""")
        lines = source.splitlines()
        script = Script(source, path=None)
        definitions += script.infer(len(lines), len('variable'))

        script2 = Script(source, path=None)
        definitions += script2.get_references(4, len('class C'))

        source_param = "def f(a): return a"
        script_param = Script(source_param, path=None)
        definitions += script_param.goto(1, len(source_param))

        return definitions

    for definition in make_definitions():
        assert definition.type in ('module', 'class', 'instance', 'function',
                                   'generator', 'statement', 'import', 'param')


@pytest.mark.parametrize(
    ('src', 'expected_result', 'column'), [
        # import one level
        ('import t', 'module', None),
        ('import ', 'module', None),
        ('import datetime; datetime', 'module', None),

        # from
        ('from datetime import timedelta', 'class', None),
        ('from datetime import timedelta; timedelta', 'class', None),
        ('from json import tool', 'module', None),
        ('from json import tool; tool', 'module', None),

        # import two levels
        ('import json.tool; json', 'module', None),
        ('import json.tool; json.tool', 'module', None),
        ('import json.tool; json.tool.main', 'function', None),
        ('import json.tool', 'module', None),
        ('import json.tool', 'module', 9),
    ]

)
def test_basedefinition_type_import(Script, src, expected_result, column):
    types = {t.type for t in Script(src).complete(column=column)}
    assert types == {expected_result}


def test_function_signature_in_doc(Script):
    defs = Script("""
    def f(x, y=1, z='a'):
        pass
    f""").infer()
    doc = defs[0].docstring()
    assert "f(x, y=1, z='a')" in str(doc)


def test_param_docstring(get_names):
    param = get_names("def test(parameter): pass", all_scopes=True)[1]
    assert param.name == 'parameter'
    assert param.docstring() == ''


def test_class_signature(Script):
    defs = Script("""
    class Foo:
        def __init__(self, x, y=1, z='a'):
            pass
    Foo""").infer()
    doc = defs[0].docstring()
    assert doc == "Foo(x, y=1, z='a')"


def test_position_none_if_builtin(Script):
    gotos = Script('import sys; sys.path').goto()
    assert gotos[0].in_builtin_module()
    assert gotos[0].line is not None
    assert gotos[0].column is not None


def test_completion_docstring(Script, jedi_path):
    """
    Jedi should follow imports in certain conditions
    """
    def docstr(src, result):
        c = Script(src, project=project).complete()[0]
        assert c.docstring(raw=True, fast=False) == cleandoc(result)

    project = jedi.Project('.', sys_path=[jedi_path])
    c = Script('import jedi\njed', project=project).complete()[0]
    assert c.docstring(fast=False) == cleandoc(jedi_doc)

    docstr('import jedi\njedi.Scr', cleandoc(jedi.Script.__doc__))

    docstr('abcd=3;abcd', '')
    docstr('"hello"\nabcd=3\nabcd', '')
    docstr(
        dedent('''
        def x():
            "hello"
            0
        x'''),
        'hello'
    )
    docstr(
        dedent('''
        def x():
            "hello";0
        x'''),
        'hello'
    )
    # Shouldn't work with a tuple.
    docstr(
        dedent('''
        def x():
            "hello",0
        x'''),
        ''
    )
    # Should also not work if we rename something.
    docstr(
        dedent('''
        def x():
            "hello"
        y = x
        y'''),
        ''
    )


def test_completion_params(Script):
    c = Script('import string; string.capwords').complete()[0]
    assert [p.name for p in c.get_signatures()[0].params] == ['s', 'sep']


def test_functions_should_have_params(Script):
    for c in Script('bool.').complete():
        if c.type == 'function':
            if c.name in ('denominator', 'numerator', 'imag', 'real', '__class__'):
                # Properties
                assert not c.get_signatures()
            else:
                assert c.get_signatures()


def test_hashlib_params(Script, environment):
    if environment.version_info < (3,):
        pytest.skip()

    script = Script('from hashlib import sha256')
    c, = script.complete()
    sig, = c.get_signatures()
    assert [p.name for p in sig.params] == ['string']


def test_signature_params(Script):
    def check(defs):
        signature, = defs[0].get_signatures()
        assert len(signature.params) == 1
        assert signature.params[0].name == 'bar'

    s = dedent('''
    def foo(bar):
        pass
    foo''')

    check(Script(s).infer())

    check(Script(s).goto())
    check(Script(s + '\nbar=foo\nbar').goto())


def test_param_endings(Script):
    """
    Params should be represented without the comma and whitespace they have
    around them.
    """
    sig, = Script('def x(a, b=5, c=""): pass\n x(').get_signatures()
    assert [p.description for p in sig.params] == ['param a', 'param b=5', 'param c=""']


@pytest.mark.parametrize(
    'code, index, name, is_definition', [
        ('name', 0, 'name', False),
        ('a = f(x)', 0, 'a', True),
        ('a = f(x)', 1, 'f', False),
        ('a = f(x)', 2, 'x', False),
    ]
)
def test_is_definition(get_names, code, index, name, is_definition):
    d = get_names(
        dedent(code),
        references=True,
        all_scopes=True,
    )[index]
    assert d.name == name
    assert d.is_definition() == is_definition


@pytest.mark.parametrize(
    'code, expected', (
        ('import x as a', [False, True]),
        ('from x import y', [False, True]),
        ('from x.z import y', [False, False, True]),
    )
)
def test_is_definition_import(get_names, code, expected):
    ns = get_names(dedent(code), references=True, all_scopes=True)
    # Assure that names are definitely sorted.
    ns = sorted(ns, key=lambda name: (name.line, name.column))
    assert [name.is_definition() for name in ns] == expected


def test_parent(Script):
    def _parent(source, line=None, column=None):
        def_, = Script(dedent(source)).goto(line, column)
        return def_.parent()

    parent = _parent('foo=1\nfoo')
    assert parent.type == 'module'

    parent = _parent('''
        def spam():
            if 1:
                y=1
                y''')
    assert parent.name == 'spam'
    assert parent.parent().type == 'module'


def test_parent_on_function(Script):
    code = 'def spam():\n pass'
    def_, = Script(code).goto(line=1, column=len('def spam'))
    parent = def_.parent()
    assert parent.name == '__main__'
    assert parent.type == 'module'


def test_parent_on_completion_and_else(Script):
    script = Script(dedent('''\
        class Foo():
            def bar(name): name
        Foo().bar'''))

    bar, = script.complete()
    parent = bar.parent()
    assert parent.name == 'Foo'
    assert parent.type == 'class'

    param, name, = [d for d in script.get_names(all_scopes=True, references=True)
                    if d.name == 'name']
    parent = name.parent()
    assert parent.name == 'bar'
    assert parent.type == 'function'
    parent = name.parent().parent()
    assert parent.name == 'Foo'
    assert parent.type == 'class'

    parent = param.parent()
    assert parent.name == 'bar'
    assert parent.type == 'function'
    parent = param.parent().parent()
    assert parent.name == 'Foo'
    assert parent.type == 'class'

    parent = Script('str.join').complete()[0].parent()
    assert parent.name == 'str'
    assert parent.type == 'class'


def test_parent_on_closure(Script):
    script = Script(dedent('''\
        class Foo():
            def bar(name):
                def inner(): foo
                return inner'''))

    names = script.get_names(all_scopes=True, references=True)
    inner_func, inner_reference = filter(lambda d: d.name == 'inner', names)
    foo, = filter(lambda d: d.name == 'foo', names)

    assert foo.parent().name == 'inner'
    assert foo.parent().parent().name == 'bar'
    assert foo.parent().parent().parent().name == 'Foo'
    assert foo.parent().parent().parent().parent().name == '__main__'

    assert inner_func.parent().name == 'bar'
    assert inner_func.parent().parent().name == 'Foo'
    assert inner_reference.parent().name == 'bar'
    assert inner_reference.parent().parent().name == 'Foo'


def test_parent_on_comprehension(Script):
    ns = Script('''\
    def spam():
        return [i for i in range(5)]
    ''').get_names(all_scopes=True)

    assert [name.name for name in ns] == ['spam', 'i']

    assert ns[0].parent().name == '__main__'
    assert ns[0].parent().type == 'module'
    assert ns[1].parent().name == 'spam'
    assert ns[1].parent().type == 'function'


def test_type(Script):
    for c in Script('a = [str()]; a[0].').complete():
        if c.name == '__class__' and False:  # TODO fix.
            assert c.type == 'class'
        else:
            assert c.type in ('function', 'statement')

    for c in Script('list.').complete():
        assert c.type

    # Github issue #397, type should never raise an error.
    for c in Script('import os; os.path.').complete():
        assert c.type


def test_type_II(Script):
    """
    GitHub Issue #833, `keyword`s are seen as `module`s
    """
    for c in Script('f').complete():
        if c.name == 'for':
            assert c.type == 'keyword'


@pytest.mark.parametrize(
    'added_code, expected_type, expected_infer_type', [
        ('Foo().x', 'property', 'instance'),
        ('Foo.x', 'property', 'property'),
        ('Foo().y', 'function', 'function'),
        ('Foo.y', 'function', 'function'),
        ('Foo().z', 'function', 'function'),
        ('Foo.z', 'function', 'function'),
    ]
)
def test_class_types(goto_or_help_or_infer, added_code, expected_type,
                     expected_infer_type):
    code = dedent('''\
        class Foo:
            @property
            def x(self): return 1
            @staticmethod
            def y(self): ...
            @classmethod
            def z(self): ...
        ''')
    d, = goto_or_help_or_infer(code + added_code)
    if goto_or_help_or_infer.type == 'infer':
        assert d.type == expected_infer_type
    else:
        assert d.type == expected_type


"""
This tests the BaseName.goto function, not the jedi
function. They are not really different in functionality, but really
different as an implementation.
"""


def test_goto_repetition(get_names):
    defs = get_names('a = 1; a', references=True, definitions=False)
    # Repeat on the same variable. Shouldn't change once we're on a
    # definition.
    for _ in range(3):
        assert len(defs) == 1
        ass = defs[0].goto()
        assert ass[0].description == 'a = 1'


def test_goto_named_params(get_names):
    src = """\
            def foo(a=1, bar=2):
                pass
            foo(bar=1)
          """
    bar = get_names(dedent(src), references=True)[-1]
    param = bar.goto()[0]
    assert (param.line, param.column) == (1, 13)
    assert param.type == 'param'


def test_class_call(get_names):
    src = 'from threading import Thread; Thread(group=1)'
    n = get_names(src, references=True)[-1]
    assert n.name == 'group'
    param_def = n.goto()[0]
    assert param_def.name == 'group'
    assert param_def.type == 'param'


def test_parentheses(get_names):
    n = get_names('("").upper', references=True)[-1]
    assert n.goto()[0].name == 'upper'


def test_import(get_names):
    nms = get_names('from json import load', references=True)
    assert nms[0].name == 'json'
    assert nms[0].type == 'module'
    n = nms[0].goto()[0]
    assert n.name == 'json'
    assert n.type == 'module'

    assert nms[1].name == 'load'
    assert nms[1].type == 'function'
    n = nms[1].goto()[0]
    assert n.name == 'load'
    assert n.type == 'function'

    nms = get_names('import os; os.path', references=True)
    assert nms[0].name == 'os'
    assert nms[0].type == 'module'
    n = nms[0].goto()[0]
    assert n.name == 'os'
    assert n.type == 'module'

    nms = nms[2].goto()
    assert nms
    assert all(n.type == 'module' for n in nms)
    assert 'posixpath' in {n.name for n in nms}

    nms = get_names('import os.path', references=True)
    n = nms[0].goto()[0]
    assert n.name == 'os'
    assert n.type == 'module'
    n = nms[1].goto()[0]
    # This is very special, normally the name doesn't change, but since
    # os.path is a sys.modules hack, it does.
    assert n.name in ('macpath', 'ntpath', 'posixpath', 'os2emxpath')
    assert n.type == 'module'


def test_import_alias(get_names):
    nms = get_names('import json as foo', references=True)
    assert nms[0].name == 'json'
    assert nms[0].type == 'module'
    assert nms[0]._name.tree_name.parent.type == 'dotted_as_name'
    n = nms[0].goto()[0]
    assert n.name == 'json'
    assert n.type == 'module'
    assert n._name._value.tree_node.type == 'file_input'

    assert nms[1].name == 'foo'
    assert nms[1].type == 'module'
    assert nms[1]._name.tree_name.parent.type == 'dotted_as_name'
    ass = nms[1].goto()
    assert len(ass) == 1
    assert ass[0].name == 'json'
    assert ass[0].type == 'module'
    assert ass[0]._name._value.tree_node.type == 'file_input'


def test_added_equals_to_params(Script):
    def run(rest_source):
        source = dedent("""
        def foo(bar, baz):
            pass
        """)
        results = Script(source + rest_source).complete()
        assert len(results) == 1
        return results[0]

    assert run('foo(bar').name_with_symbols == 'bar='
    assert run('foo(bar').complete == '='
    assert run('foo(bar').get_completion_prefix_length() == 3
    assert run('foo(bar, baz').complete == '='
    assert run('foo(bar, baz').get_completion_prefix_length() == 3
    assert run('    bar').name_with_symbols == 'bar'
    assert run('    bar').complete == ''
    assert run('    bar').get_completion_prefix_length() == 3
    x = run('foo(bar=isins').name_with_symbols
    assert run('foo(bar=isins').get_completion_prefix_length() == 5
    assert x == 'isinstance'


def test_builtin_module_with_path(Script):
    """
    This test simply tests if a module from /usr/lib/python3.8/lib-dynload/ has
    a path or not. It shouldn't have a module_path, because that is just
    confusing.
    """
    semlock, = Script('from _multiprocessing import SemLock').infer()
    assert isinstance(semlock._name, CompiledValueName)
    assert semlock.module_path is None
    assert semlock.in_builtin_module() is True
    assert semlock.name == 'SemLock'
    assert semlock.line is None
    assert semlock.column is None


@pytest.mark.parametrize(
    'code, description', [
        ('int', 'instance int'),
        ('str.index', 'instance int'),
        ('1', None),
    ]
)
def test_execute(Script, code, description):
    definition, = Script(code).goto()
    definitions = definition.execute()
    if description is None:
        assert not definitions
    else:
        d, = definitions
        assert d.description == description


@pytest.mark.parametrize('goto', [False, True, None])
@pytest.mark.parametrize(
    'code, name, file_name', [
        ('from pkg import Foo; Foo.foo', 'foo', '__init__.py'),
        ('from pkg import Foo; Foo().foo', 'foo', '__init__.py'),
        ('from pkg import Foo; Foo.bar', 'bar', 'module.py'),
        ('from pkg import Foo; Foo().bar', 'bar', 'module.py'),
    ])
def test_inheritance_module_path(Script, goto, code, name, file_name):
    base_path = get_example_dir('inheritance', 'pkg')
    whatever_path = base_path.joinpath('NOT_EXISTING.py')

    script = Script(code, path=whatever_path)
    if goto is None:
        func, = script.infer()
    else:
        func, = script.goto(follow_imports=goto)
    assert func.type == 'function'
    assert func.name == name
    assert func.module_path == base_path.joinpath(file_name)


def test_definition_goto_follow_imports(Script):
    dumps = Script('from json import dumps\ndumps').get_names(references=True)[-1]
    assert dumps.description == 'dumps'
    no_follow, = dumps.goto()
    assert no_follow.description == 'def dumps'
    assert no_follow.line == 1
    assert no_follow.column == 17
    assert no_follow.module_name == '__main__'
    follow, = dumps.goto(follow_imports=True)
    assert follow.description == 'def dumps'
    assert follow.line != 1
    assert follow.module_name == 'json'


@pytest.mark.parametrize(
    'code, expected', [
        ('1', 'int'),
        ('x = None; x', 'None'),
        ('n: Optional[str]; n', 'Optional[str]'),
        ('n = None if xxxxx else ""; n', 'Optional[str]'),
        ('n = None if xxxxx else str(); n', 'Optional[str]'),
        ('n = None if xxxxx else str; n', 'Optional[Type[str]]'),
        ('class Foo: pass\nFoo', 'Type[Foo]'),
        ('class Foo: pass\nFoo()', 'Foo'),

        ('n: Type[List[int]]; n', 'Type[List[int]]'),
        ('n: Type[List]; n', 'Type[list]'),
        ('n: List; n', 'list'),
        ('n: List[int]; n', 'List[int]'),
        ('n: Iterable[int]; n', 'Iterable[int]'),

        ('n = [1]; n', 'List[int]'),
        ('n = [1, ""]; n', 'List[Union[int, str]]'),
        ('n = [1, str(), None]; n', 'List[Optional[Union[int, str]]]'),
        ('n = {1, str()}; n', 'Set[Union[int, str]]'),
        ('n = (1,); n', 'Tuple[int]'),
        ('n = {1: ""}; n', 'Dict[int, str]'),
        ('n = {1: "", 1.0: b""}; n', 'Dict[Union[float, int], Union[bytes, str]]'),

        ('n = next; n', 'Union[next(__i: Iterator[_T]) -> _T, '
         'next(__i: Iterator[_T], default: _VT) -> Union[_T, _VT]]'),
        ('abs', 'abs(__x: SupportsAbs[_T]) -> _T'),
        ('def foo(x, y): return x if xxxx else y\nfoo(str(), 1)\nfoo',
         'foo(x: str, y: int) -> Union[int, str]'),
        ('def foo(x, y = None): return x if xxxx else y\nfoo(str(), 1)\nfoo',
         'foo(x: str, y: int=None) -> Union[int, str]'),
    ]
)
def test_get_type_hint(Script, code, expected):
    code = 'from typing import *\n' + code
    d, = Script(code).goto()
    assert d.get_type_hint() == expected


def test_pseudotreenameclass_type(Script):
    assert Script('from typing import Any\n').get_names()[0].type == 'class'


cls_code = '''\
class AClass:
    """my class"""
    @staticmethod
    def hello():
        func_var = 1
        return func_var
'''


@pytest.mark.parametrize(
    'code, pos, start, end', [
        ('def a_func():\n    return "bar"\n', (1, 4), (1, 0), (2, 16)),
        ('var1 = 12', (1, 0), (1, 0), (1, 9)),
        ('var1 + 1', (1, 0), (1, 0), (1, 4)),
        ('class AClass: pass', (1, 6), (1, 0), (1, 18)),
        ('class AClass: pass\n', (1, 6), (1, 0), (1, 18)),
        (cls_code, (1, 6), (1, 0), (6, 23)),
        (cls_code, (4, 8), (4, 4), (6, 23)),
        (cls_code, (5, 8), (5, 8), (5, 20)),
    ]
)
def test_definition_start_end_position(Script, code, pos, start, end):
    '''Tests for definition_start_position and definition_end_position'''
    name = next(
        n for n in Script(code=code).get_names(all_scopes=True, references=True)
        if n._name.tree_name.start_pos <= pos <= n._name.tree_name.end_pos
    )
    assert name.get_definition_start_position() == start
    assert name.get_definition_end_position() == end
