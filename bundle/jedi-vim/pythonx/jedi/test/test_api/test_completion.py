from os.path import join, sep as s, dirname, expanduser
import os
from textwrap import dedent
from itertools import count
from pathlib import Path

import pytest

from ..helpers import root_dir
from jedi.api.helpers import _start_match, _fuzzy_match
from jedi.inference.imports import _load_python_module
from jedi.file_io import KnownContentFileIO
from jedi.inference.base_value import ValueSet


def test_in_whitespace(Script):
    code = dedent('''
    def x():
        pass''')
    assert len(Script(code).complete(column=2)) > 20


def test_empty_init(Script):
    """This was actually an issue."""
    code = dedent('''\
    class X(object): pass
    X(''')
    assert not Script(code).complete()


def test_in_empty_space(Script):
    code = dedent('''\
    class X(object):
        def __init__(self):
            hello
            ''')
    comps = Script(code).complete(3, 7)
    self, = [c for c in comps if c.name == 'self']
    assert self.name == 'self'
    def_, = self.infer()
    assert def_.name == 'X'


def test_indent_value(Script):
    """
    If an INDENT is the next supposed token, we should still be able to
    complete.
    """
    code = 'if 1:\nisinstanc'
    comp, = Script(code).complete()
    assert comp.name == 'isinstance'


def test_keyword_value(Script):
    def get_names(*args, **kwargs):
        return [d.name for d in Script(*args, **kwargs).complete()]

    names = get_names('if 1:\n pass\n')
    assert 'if' in names
    assert 'elif' in names


def test_os_nowait(Script):
    """ github issue #45 """
    s = Script("import os; os.P_").complete()
    assert 'P_NOWAIT' in [i.name for i in s]


def test_points_in_completion(Script):
    """At some point, points were inserted into the completions, this
    caused problems, sometimes.
    """
    c = Script("if IndentationErr").complete()
    assert c[0].name == 'IndentationError'
    assert c[0].complete == 'or'


def test_loading_unicode_files_with_bad_global_charset(Script, monkeypatch, tmpdir):
    dirname = str(tmpdir.mkdir('jedi-test'))
    filename1 = join(dirname, 'test1.py')
    filename2 = join(dirname, 'test2.py')
    data = "# coding: latin-1\nfoo = 'm\xf6p'\n".encode("latin-1")

    with open(filename1, "wb") as f:
        f.write(data)
    s = Script("from test1 import foo\nfoo.", path=filename2)
    s.complete(line=2, column=4)


def test_complete_expanduser(Script):
    possibilities = os.scandir(expanduser('~'))
    non_dots = [p for p in possibilities if not p.name.startswith('.') and len(p.name) > 1]
    item = non_dots[0]
    line = "'~%s%s'" % (os.sep, item.name)
    s = Script(line)
    expected_name = item.name
    if item.is_dir():
        expected_name += os.path.sep
    assert expected_name in [c.name for c in s.complete(column=len(line)-1)]


def test_fake_subnodes(Script):
    """
    Test the number of subnodes of a fake object.

    There was a bug where the number of child nodes would grow on every
    call to :func:``jedi.inference.compiled.fake.get_faked``.

    See Github PR#649 and isseu #591.
    """
    def get_str_completion(values):
        for c in values:
            if c.name == 'str':
                return c
    limit = None
    for i in range(2):
        completions = Script('').complete()
        c = get_str_completion(completions)
        str_value, = c._name.infer()
        n = len(str_value.tree_node.children[-1].children)
        if i == 0:
            limit = n
        else:
            assert n == limit


def test_generator(Script):
    # Did have some problems with the usage of generator completions this
    # way.
    s = "def abc():\n" \
        "    yield 1\n" \
        "abc()."
    assert Script(s).complete()


def test_in_comment(Script):
    assert Script(" # Comment").complete()
    # TODO this is a bit ugly, that the behaviors in comments are different.
    assert not Script("max_attr_value = int(2) # Cast to int for spe").complete()


def test_in_comment_before_string(Script):
    assert not Script(" # Foo\n'asdf'").complete(line=1)


def test_async(Script, environment):
    code = dedent('''
        foo = 3
        async def x():
            hey = 3
              ho''')
    comps = Script(code).complete(column=4)
    names = [c.name for c in comps]
    assert 'foo' in names
    assert 'hey' in names


def test_with_stmt_error_recovery(Script):
    assert Script('with open('') as foo: foo.\na').complete(line=1)


def test_function_param_usage(Script):
    c, = Script('def func(foo_value):\n str(foo_valu').complete()
    assert c.complete == 'e'
    assert c.name == 'foo_value'

    c1, c2 = Script('def func(foo_value):\n func(foo_valu').complete()
    assert c1.complete == 'e'
    assert c1.name == 'foo_value'
    assert c2.complete == 'e='
    assert c2.name == 'foo_value='


@pytest.mark.parametrize(
    'code, has_keywords', (
        ('', True),
        ('x;', True),
        ('1', False),
        ('1 ', True),
        ('1\t', True),
        ('1\n', True),
        ('1\\\n', True),
    )
)
def test_keyword_completion(Script, code, has_keywords):
    assert has_keywords == any(x.is_keyword for x in Script(code).complete())


f1 = join(root_dir, 'example.py')
f2 = join(root_dir, 'test', 'example.py')
os_path = 'from os.path import *\n'
# os.path.sep escaped
se = s * 2 if s == '\\' else s
current_dirname = os.path.basename(dirname(dirname(dirname(__file__))))


@pytest.mark.parametrize(
    'file, code, column, expected', [
        # General tests / relative paths
        (None, '"comp', None, []),  # No files like comp
        (None, '"test', None, [s]),
        (None, '"test', 4, ['t' + s]),
        ('example.py', '"test%scomp' % s, None, ['letion' + s]),
        ('example.py', 'r"comp"', None, []),
        ('example.py', 'r"tes"', None, []),
        ('example.py', '1 + r"tes"', None, []),
        ('example.py', 'r"tes"', 5, ['t' + s]),
        ('example.py', 'r" tes"', 6, []),
        ('test%sexample.py' % se, 'r"tes"', 5, ['t' + s]),
        ('test%sexample.py' % se, 'r"test%scomp"' % s, 5, ['t' + s]),
        ('test%sexample.py' % se, 'r"test%scomp"' % s, 11, ['letion' + s]),
        ('test%sexample.py' % se, '"%s"' % join('test', 'completion', 'basi'), 21, ['c.py']),
        ('example.py', 'rb"' + join('..', current_dirname, 'tes'), None, ['t' + s]),

        # Absolute paths
        (None, f'"{root_dir.joinpath("test", "test_ca")}', None, ['che.py"']),
        (None, f'"{root_dir.joinpath("test", "test_ca")}"', len(str(root_dir)) + 14, ['che.py']),

        # Longer quotes
        ('example.py', 'r"""test', None, [s]),
        ('example.py', 'r"""\ntest', None, []),
        ('example.py', 'u"""tes\n', (1, 7), ['t' + s]),
        ('example.py', '"""test%stest_cache.p"""' % s, 20, ['y']),
        ('example.py', '"""test%stest_cache.p"""' % s, 19, ['py"""']),

        # Adding
        ('example.py', '"test" + "%stest_cac' % se, None, ['he.py"']),
        ('example.py', '"test" + "%s" + "test_cac' % se, None, ['he.py"']),
        ('example.py', 'x = 1 + "test', None, []),
        ('example.py', 'x = f("te" + "st)', 16, [s]),
        ('example.py', 'x = f("te" + "st', 16, [s]),
        ('example.py', 'x = f("te" + "st"', 16, [s]),
        ('example.py', 'x = f("te" + "st")', 16, [s]),
        ('example.py', 'x = f("t" + "est")', 16, [s]),
        ('example.py', 'x = f(b"t" + "est")', 17, []),
        ('example.py', '"test" + "', None, [s]),

        # __file__
        (f1, os_path + 'dirname(__file__) + "%stest' % s, None, [s]),
        (f2, os_path + 'dirname(__file__) + "%stest_ca' % se, None, ['che.py"']),
        (f2, os_path + 'dirname(abspath(__file__)) + sep + "test_ca', None, ['che.py"']),
        (f2, os_path + 'join(dirname(__file__), "completion") + sep + "basi', None, ['c.py"']),
        (f2, os_path + 'join("test", "completion") + sep + "basi', None, ['c.py"']),

        # inside join
        (f2, os_path + 'join(dirname(__file__), "completion", "basi', None, ['c.py"']),
        (f2, os_path + 'join(dirname(__file__), "completion", "basi)', 43, ['c.py"']),
        (f2, os_path + 'join(dirname(__file__), "completion", "basi")', 43, ['c.py']),
        (f2, os_path + 'join(dirname(__file__), "completion", "basi)', 35, ['']),
        (f2, os_path + 'join(dirname(__file__), "completion", "basi)', 33, ['on"']),
        (f2, os_path + 'join(dirname(__file__), "completion", "basi")', 33, ['on"']),

        # join with one argument. join will not get inferred and the result is
        # that directories and in a slash. This is unfortunate, but doesn't
        # really matter.
        (f2, os_path + 'join("tes', 9, ['t"']),
        (f2, os_path + 'join(\'tes)', 9, ["t'"]),
        (f2, os_path + 'join(r"tes"', 10, ['t']),
        (f2, os_path + 'join("""tes""")', 11, ['t']),

        # Almost like join but not really
        (f2, os_path + 'join["tes', 9, ['t' + s]),
        (f2, os_path + 'join["tes"', 9, ['t' + s]),
        (f2, os_path + 'join["tes"]', 9, ['t' + s]),
        (f2, os_path + 'join[dirname(__file__), "completi', 33, []),
        (f2, os_path + 'join[dirname(__file__), "completi"', 33, []),
        (f2, os_path + 'join[dirname(__file__), "completi"]', 33, []),

        # With full paths
        (f2, 'import os\nos.path.join(os.path.dirname(__file__), "completi', 49, ['on"']),
        (f2, 'import os\nos.path.join(os.path.dirname(__file__), "completi"', 49, ['on']),
        (f2, 'import os\nos.path.join(os.path.dirname(__file__), "completi")', 49, ['on']),

        # With alias
        (f2, 'import os.path as p as p\np.join(p.dirname(__file__), "completi', None, ['on"']),
        (f2, 'from os.path import dirname, join as j\nj(dirname(__file__), "completi',
         None, ['on"']),

        # Trying to break it
        (f2, os_path + 'join(["tes', 10, ['t' + s]),
        (f2, os_path + 'join(["tes"]', 10, ['t' + s]),
        (f2, os_path + 'join(["tes"])', 10, ['t' + s]),
        (f2, os_path + 'join("test", "test_cac" + x,', 22, ['he.py']),

        # GH #1528
        (f2, "'a' 'b'", 4, Ellipsis),
    ]
)
def test_file_path_completions(Script, file, code, column, expected):
    line = None
    if isinstance(column, tuple):
        line, column = column
    comps = Script(code, path=file).complete(line=line, column=column)
    if expected is Ellipsis:
        assert len(comps) > 100  # This is basically global completions.
    else:
        assert [c.complete for c in comps] == expected


def test_file_path_should_have_completions(Script):
    assert Script('r"').complete()  # See GH #1503


_dict_keys_completion_tests = [
    ('ints[', 5, ['1', '50', Ellipsis]),
    ('ints[]', 5, ['1', '50', Ellipsis]),
    ('ints[1]', 5, ['1', '50', Ellipsis]),
    ('ints[1]', 6, ['']),
    ('ints[1', 5, ['1', '50', Ellipsis]),
    ('ints[1', 6, ['']),

    ('ints[5]', 5, ['1', '50', Ellipsis]),
    ('ints[5]', 6, ['0']),
    ('ints[50', 5, ['1', '50', Ellipsis]),
    ('ints[5', 6, ['0']),
    ('ints[ 5', None, ['0']),
    ('ints [ 5', None, ['0']),
    ('ints[50', 6, ['0']),
    ('ints[50', 7, ['']),

    ('strs[', 5, ["'asdf'", "'fbar'", "'foo'", Ellipsis]),
    ('strs[]', 5, ["'asdf'", "'fbar'", "'foo'", Ellipsis]),
    ("strs['", 6, ["asdf'", "fbar'", "foo'"]),
    ("strs[']", 6, ["asdf'", "fbar'", "foo'"]),
    ('strs["]', 6, ['asdf"', 'fbar"', 'foo"']),
    ('strs["""]', 6, ['asdf', 'fbar', 'foo']),
    ('strs["""]', 8, ['asdf"""', 'fbar"""', 'foo"""']),
    ('strs[b"]', 8, []),
    ('strs[r"asd', 10, ['f"']),
    ('strs[r"asd"', 10, ['f']),
    ('strs[R"asd', 10, ['f"']),
    ('strs[ R"asd', None, ['f"']),
    ('strs[\tR"asd', None, ['f"']),
    ('strs[\nR"asd', None, ['f"']),
    ('strs[f"asd', 10, []),
    ('strs[br"""asd', 13, ['f"""']),
    ('strs[br"""asd"""', 13, ['f']),
    ('strs[ \t"""asd"""', 13, ['f']),

    ('strs["f', 7, ['bar"', 'oo"']),
    ('strs["f"', 7, ['bar', 'oo']),
    ('strs["f]', 7, ['bar"', 'oo"']),
    ('strs["f"]', 7, ['bar', 'oo']),

    ('mixed[', 6, [r"'a\\sdf'", '1', '1.1', "b'foo'", Ellipsis]),
    ('mixed[1', 7, ['', '.1']),
    ('mixed[Non', 9, ['e']),

    ('casted["f', 9, ['3"', 'bar"', 'oo"']),
    ('casted["f"', 9, ['3', 'bar', 'oo']),
    ('casted["f3', 10, ['"']),
    ('casted["f3"', 10, ['']),
    ('casted_mod["f', 13, ['3"', 'bar"', 'oo"', 'ull"', 'uuu"']),

    ('keywords["', None, ['a"']),
    ('keywords[Non', None, ['e']),
    ('keywords[Fa', None, ['lse']),
    ('keywords[Tr', None, ['ue']),
    ('keywords[str', None, ['', 's']),
]


@pytest.mark.parametrize(
    'added_code, column, expected', _dict_keys_completion_tests
)
def test_dict_keys_completions(Script, added_code, column, expected):
    code = dedent(r'''
        ints = {1: ''}
        ints[50] = 3.0
        strs = {'asdf': 1, u"""foo""": 2, r'fbar': 3}
        mixed = {1: 2, 1.10: 4, None: 6, r'a\sdf': 8, b'foo': 9}
        casted = dict(strs, f3=4, r'\\xyz')
        casted_mod = dict(casted)
        casted_mod["fuuu"] = 8
        casted_mod["full"] = 8
        keywords = {None: 1, False: 2, "a": 3}
        ''')
    comps = Script(code + added_code).complete(column=column)
    if Ellipsis in expected:
        # This means that global completions are part of this, so filter all of
        # that out.
        comps = [c for c in comps if not c._name.is_value_name and not c.is_keyword]
        expected = [e for e in expected if e is not Ellipsis]

    assert [c.complete for c in comps] == expected


def test_dict_keys_in_weird_case(Script):
    assert Script('a[\n# foo\nx]').complete(line=2, column=0)


def test_start_match():
    assert _start_match('Condition', 'C')


def test_fuzzy_match():
    assert _fuzzy_match('Condition', 'i')
    assert not _fuzzy_match('Condition', 'p')
    assert _fuzzy_match('Condition', 'ii')
    assert not _fuzzy_match('Condition', 'Ciito')
    assert _fuzzy_match('Condition', 'Cdiio')


def test_ellipsis_completion(Script):
    assert Script('...').complete() == []


@pytest.fixture
def module_injector():
    counter = count()

    def module_injector(inference_state, names, code):
        assert isinstance(names, tuple)
        file_io = KnownContentFileIO(
            Path('foo/bar/module-injector-%s.py' % next(counter)).absolute(),
            code
        )
        v = _load_python_module(inference_state, file_io, names)
        inference_state.module_cache.add(names, ValueSet([v]))

    return module_injector


def test_completion_cache(Script, module_injector):
    """
    For some modules like numpy, tensorflow or pandas we cache docstrings and
    type to avoid them slowing us down, because they are huge.
    """
    script = Script('import numpy; numpy.foo')
    module_injector(script._inference_state, ('numpy',), 'def foo(a): "doc"')
    c, = script.complete()
    assert c.name == 'foo'
    assert c.type == 'function'
    assert c.docstring() == 'foo(a)\n\ndoc'

    code = dedent('''\
        class foo:
            'doc2'
            def __init__(self):
                pass
        ''')
    script = Script('import numpy; numpy.foo')
    module_injector(script._inference_state, ('numpy',), code)
    # The outpus should still be the same
    c, = script.complete()
    assert c.name == 'foo'
    assert c.type == 'function'
    assert c.docstring() == 'foo(a)\n\ndoc'
    cls, = c.infer()
    assert cls.type == 'class'
    assert cls.docstring() == 'foo()\n\ndoc2'


@pytest.mark.parametrize('module', ['typing', 'os'])
def test_module_completions(Script, module):
    for c in Script('import {module}; {module}.'.format(module=module)).complete():
        # Just make sure that there are no errors
        c.type
        c.docstring()


def test_whitespace_at_end_after_dot(Script):
    assert 'strip' in [c.name for c in Script('str. ').complete()]
