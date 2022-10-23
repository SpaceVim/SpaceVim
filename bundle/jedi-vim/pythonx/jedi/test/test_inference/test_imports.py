"""
Tests of various import related things that could not be tested with "Black Box
Tests".
"""

import os
from pathlib import Path

import pytest

import jedi
from jedi.file_io import FileIO
from jedi.inference import compiled
from jedi.inference import imports
from jedi.api.project import Project
from jedi.inference.gradual.conversion import _stub_to_python_value_set
from jedi.inference.references import get_module_contexts_containing_name
from ..helpers import get_example_dir, test_dir, test_dir_project, root_dir
from jedi.inference.compiled.subprocess.functions import _find_module_py33, _find_module

THIS_DIR = os.path.dirname(__file__)


def test_find_module_basic():
    """Needs to work like the old find_module."""
    assert _find_module_py33('_io') == (None, False)
    with pytest.raises(ImportError):
        assert _find_module_py33('_DOESNTEXIST_') == (None, None)


def test_find_module_package():
    file_io, is_package = _find_module('json')
    assert file_io.path.parts[-2:] == ('json', '__init__.py')
    assert is_package is True


def test_find_module_not_package():
    file_io, is_package = _find_module('io')
    assert file_io.path.name == 'io.py'
    assert is_package is False


pkg_zip_path = Path(get_example_dir('zipped_imports', 'pkg.zip'))


def test_find_module_package_zipped(Script, inference_state, environment):
    sys_path = environment.get_sys_path() + [str(pkg_zip_path)]

    project = Project('.', sys_path=sys_path)
    script = Script('import pkg; pkg.mod', project=project)
    assert len(script.complete()) == 1

    file_io, is_package = inference_state.compiled_subprocess.get_module_info(
        sys_path=sys_path,
        string='pkg',
        full_name='pkg'
    )
    assert file_io is not None
    assert file_io.path.parts[-3:] == ('pkg.zip', 'pkg', '__init__.py')
    assert file_io._zip_path.name == 'pkg.zip'
    assert is_package is True


@pytest.mark.parametrize(
    'code, file, package, path', [
        ('import pkg', '__init__.py', 'pkg', 'pkg'),
        ('import pkg', '__init__.py', 'pkg', 'pkg'),

        ('from pkg import module', 'module.py', 'pkg', None),
        ('from pkg.module', 'module.py', 'pkg', None),

        ('from pkg import nested', os.path.join('nested', '__init__.py'),
         'pkg.nested', os.path.join('pkg', 'nested')),
        ('from pkg.nested', os.path.join('nested', '__init__.py'),
         'pkg.nested', os.path.join('pkg', 'nested')),

        ('from pkg.nested import nested_module',
         os.path.join('nested', 'nested_module.py'), 'pkg.nested', None),
        ('from pkg.nested.nested_module',
         os.path.join('nested', 'nested_module.py'), 'pkg.nested', None),

        ('from pkg.namespace import namespace_module',
         os.path.join('namespace', 'namespace_module.py'), 'pkg.namespace', None),
        ('from pkg.namespace.namespace_module',
         os.path.join('namespace', 'namespace_module.py'), 'pkg.namespace', None),
    ]

)
def test_correct_zip_package_behavior(Script, inference_state, environment, code,
                                      file, package, path):
    sys_path = environment.get_sys_path() + [str(pkg_zip_path)]
    pkg, = Script(code, project=Project('.', sys_path=sys_path)).infer()
    value, = pkg._name.infer()
    assert value.py__file__() == pkg_zip_path.joinpath('pkg', file)
    assert '.'.join(value.py__package__()) == package
    assert value.is_package() is (path is not None)
    if path is not None:
        assert value.py__path__() == [str(pkg_zip_path.joinpath(path))]

    value.string_names = None
    assert value.py__package__() == []


@pytest.mark.parametrize("code,names", [
    ("from pkg.", {"module", "nested", "namespace"}),
    ("from pkg.nested.", {"nested_module"})
])
def test_zip_package_import_complete(Script, environment, code, names):
    sys_path = environment.get_sys_path() + [str(pkg_zip_path)]
    completions = Script(code, project=Project('.', sys_path=sys_path)).complete()
    assert names == {c.name for c in completions}


def test_find_module_not_package_zipped(Script, inference_state, environment):
    path = get_example_dir('zipped_imports', 'not_pkg.zip')
    sys_path = environment.get_sys_path() + [path]
    script = Script('import not_pkg; not_pkg.val', project=Project('.', sys_path=sys_path))
    assert len(script.complete()) == 1

    file_io, is_package = inference_state.compiled_subprocess.get_module_info(
        sys_path=map(str, sys_path),
        string='not_pkg',
        full_name='not_pkg'
    )
    assert file_io.path.parts[-2:] == ('not_pkg.zip', 'not_pkg.py')
    assert is_package is False


def test_import_not_in_sys_path(Script, environment):
    """
    non-direct imports (not in sys.path)

    This is in the end just a fallback.
    """
    path = get_example_dir()
    module_path = os.path.join(path, 'not_in_sys_path', 'pkg', 'module.py')
    # This project tests the smart path option of Project. The sys_path is
    # explicitly given to make sure that the path is just dumb and only
    # includes non-folder dependencies.
    project = Project(path, sys_path=environment.get_sys_path())
    a = Script(path=module_path, project=project).infer(line=5)
    assert a[0].name == 'int'

    a = Script(path=module_path, project=project).infer(line=6)
    assert a[0].name == 'str'
    a = Script(path=module_path, project=project).infer(line=7)
    assert a[0].name == 'str'


@pytest.mark.parametrize("code,name", [
    ("from flask.ext import foo; foo.", "Foo"),  # flask_foo.py
    ("from flask.ext import bar; bar.", "Bar"),  # flaskext/bar.py
    ("from flask.ext import baz; baz.", "Baz"),  # flask_baz/__init__.py
    ("from flask.ext import moo; moo.", "Moo"),  # flaskext/moo/__init__.py
    ("from flask.ext.", "foo"),
    ("from flask.ext.", "bar"),
    ("from flask.ext.", "baz"),
    ("from flask.ext.", "moo"),
    pytest.param("import flask.ext.foo; flask.ext.foo.", "Foo", marks=pytest.mark.xfail),
    pytest.param("import flask.ext.bar; flask.ext.bar.", "Foo", marks=pytest.mark.xfail),
    pytest.param("import flask.ext.baz; flask.ext.baz.", "Foo", marks=pytest.mark.xfail),
    pytest.param("import flask.ext.moo; flask.ext.moo.", "Foo", marks=pytest.mark.xfail),
])
def test_flask_ext(Script, code, name):
    """flask.ext.foo is really imported from flaskext.foo or flask_foo.
    """
    path = get_example_dir('flask-site-packages')
    completions = Script(code, project=Project('.', sys_path=[path])).complete()
    assert name in [c.name for c in completions]


def test_not_importable_file(Script):
    src = 'import not_importable_file as x; x.'
    assert not Script(src, path='example.py', project=test_dir_project).complete()


def test_import_unique(Script):
    src = "import os; os.path"
    defs = Script(src, path='example.py').infer()
    parent_contexts = [d._name._value for d in defs]
    assert len(parent_contexts) == len(set(parent_contexts))


def test_cache_works_with_sys_path_param(Script, tmpdir):
    foo_path = tmpdir.join('foo')
    bar_path = tmpdir.join('bar')
    foo_path.join('module.py').write('foo = 123', ensure=True)
    bar_path.join('module.py').write('bar = 123', ensure=True)
    foo_completions = Script(
        'import module; module.',
        project=Project('.', sys_path=[foo_path.strpath]),
    ).complete()
    bar_completions = Script(
        'import module; module.',
        project=Project('.', sys_path=[bar_path.strpath]),
    ).complete()
    assert 'foo' in [c.name for c in foo_completions]
    assert 'bar' not in [c.name for c in foo_completions]

    assert 'bar' in [c.name for c in bar_completions]
    assert 'foo' not in [c.name for c in bar_completions]


def test_import_completion_docstring(Script):
    import abc
    s = Script('"""test"""\nimport ab')
    abc_completions = [c for c in s.complete() if c.name == 'abc']
    assert len(abc_completions) == 1
    assert abc_completions[0].docstring(fast=False) == abc.__doc__

    # However for performance reasons not all modules are loaded and the
    # docstring is empty in this case.
    assert abc_completions[0].docstring() == ''


def test_goto_definition_on_import(Script):
    assert Script("import sys_blabla").infer(1, 8) == []
    assert len(Script("import sys").infer(1, 8)) == 1


def test_complete_on_empty_import(ScriptWithProject):
    path = os.path.join(test_dir, 'whatever.py')
    assert ScriptWithProject("from datetime import").complete()[0].name == 'import'
    # should just list the files in the directory
    assert 10 < len(ScriptWithProject("from .", path=path).complete()) < 30

    # Global import
    assert len(ScriptWithProject("from . import", path=path).complete(1, 5)) > 30
    # relative import
    assert 10 < len(ScriptWithProject("from . import", path=path).complete(1, 6)) < 30

    # Global import
    assert len(ScriptWithProject("from . import classes", path=path).complete(1, 5)) > 30
    # relative import
    assert 10 < len(ScriptWithProject("from . import classes", path=path).complete(1, 6)) < 30

    wanted = {'ImportError', 'import', 'ImportWarning'}
    assert {c.name for c in ScriptWithProject("import").complete()} == wanted
    assert len(ScriptWithProject("import import", path=path).complete()) > 0

    # 111
    assert ScriptWithProject("from datetime import").complete()[0].name == 'import'
    assert ScriptWithProject("from datetime import ").complete()


def test_imports_on_global_namespace_without_path(Script):
    """If the path is None, there shouldn't be any import problem"""
    completions = Script("import operator").complete()
    assert [c.name for c in completions] == ['operator']
    completions = Script("import operator", path='example.py').complete()
    assert [c.name for c in completions] == ['operator']

    # the first one has a path the second doesn't
    completions = Script("import keyword", path='example.py').complete()
    assert [c.name for c in completions] == ['keyword']
    completions = Script("import keyword").complete()
    assert [c.name for c in completions] == ['keyword']


def test_named_import(Script):
    """named import - jedi-vim issue #8"""
    s = "import time as dt"
    assert len(Script(s, path='/').infer(1, 15)) == 1
    assert len(Script(s, path='/').infer(1, 10)) == 1


def test_nested_import(Script):
    s = "import multiprocessing.dummy; multiprocessing.dummy"
    g = Script(s).goto()
    assert len(g) == 1
    assert (g[0].line, g[0].column) != (0, 0)


def test_goto(Script):
    sys, = Script("import sys").goto(follow_imports=True)
    assert sys.type == 'module'


def test_os_after_from(Script):
    def check(source, result, column=None):
        completions = Script(source).complete(column=column)
        assert [c.name for c in completions] == result

    check('\nfrom os. ', ['path'])
    check('\nfrom os ', ['import'])
    check('from os ', ['import'])
    check('\nfrom os import whatever', ['import'], len('from os im'))

    check('from os\\\n', ['import'])
    check('from os \\\n', ['import'])


def test_os_issues(Script):
    def import_names(*args, **kwargs):
        return [d.name for d in Script(*args).complete(**kwargs)]

    # Github issue #759
    s = 'import os, s'
    assert 'sys' in import_names(s)
    assert 'path' not in import_names(s, column=len(s) - 1)
    assert 'os' in import_names(s, column=len(s) - 3)

    # Some more checks
    s = 'from os import path, e'
    assert 'environ' in import_names(s)
    assert 'json' not in import_names(s, column=len(s) - 1)
    assert 'environ' in import_names(s, column=len(s) - 1)
    assert 'path' in import_names(s, column=len(s) - 3)


def test_path_issues(Script):
    """
    See pull request #684 for details.
    """
    source = '''from datetime import '''
    assert Script(source).complete()


def test_compiled_import_none(monkeypatch, Script):
    """
    Related to #1079. An import might somehow fail and return None.
    """
    script = Script('import sys')
    monkeypatch.setattr(compiled, 'load_module', lambda *args, **kwargs: None)
    def_, = script.infer()
    assert def_.type == 'module'
    value, = def_._name.infer()
    assert not _stub_to_python_value_set(value)


@pytest.mark.parametrize(
    ('path', 'is_package', 'goal'), [
        # Both of these tests used to return relative paths to the module
        # context that was initially given, but now we just work with the file
        # system.
        (os.path.join(THIS_DIR, 'test_docstring.py'), False,
         ('test_inference', 'test_imports')),
        (os.path.join(THIS_DIR, '__init__.py'), True,
         ('test_inference', 'test_imports')),
    ]
)
def test_get_modules_containing_name(inference_state, path, goal, is_package):
    inference_state.project = Project(test_dir)
    module = imports._load_python_module(
        inference_state,
        FileIO(path),
        import_names=('ok', 'lala', 'x'),
        is_package=is_package,
    )
    assert module
    module_context = module.as_context()
    input_module, found_module = get_module_contexts_containing_name(
        inference_state,
        [module_context],
        'string_that_only_exists_here'
    )
    assert input_module is module_context
    assert found_module.string_names == goal


@pytest.mark.parametrize(
    'path', ('api/whatever/test_this.py', 'api/whatever/file'))
@pytest.mark.parametrize('empty_sys_path', (False, True))
def test_relative_imports_with_multiple_similar_directories(Script, path, empty_sys_path):
    dir = get_example_dir('issue1209')
    if empty_sys_path:
        project = Project(dir, sys_path=(), smart_sys_path=False)
    else:
        project = Project(dir)
    script = Script(
        "from . ",
        path=os.path.join(dir, path),
        project=project,
    )
    name, import_ = script.complete()
    assert import_.name == 'import'
    assert name.name == 'api_test1'


def test_relative_imports_with_outside_paths(Script):
    dir = get_example_dir('issue1209')
    project = Project(dir, sys_path=[], smart_sys_path=False)
    script = Script(
        "from ...",
        path=os.path.join(dir, 'api/whatever/test_this.py'),
        project=project,
    )
    assert [c.name for c in script.complete()] == ['api', 'whatever']

    script = Script(
        "from " + '.' * 100,
        path=os.path.join(dir, 'api/whatever/test_this.py'),
        project=project,
    )
    assert not script.complete()


def test_relative_imports_without_path(Script):
    path = get_example_dir('issue1209', 'api', 'whatever')
    project = Project(path, sys_path=[], smart_sys_path=False)
    script = Script("from . ", project=project)
    assert [c.name for c in script.complete()] == ['api_test1', 'import']

    script = Script("from .. ", project=project)
    assert [c.name for c in script.complete()] == ['import', 'whatever']

    script = Script("from ... ", project=project)
    assert [c.name for c in script.complete()] == ['api', 'import', 'whatever']


def test_relative_import_out_of_file_system(Script):
    code = "from " + '.' * 100
    assert not Script(code).complete()
    script = Script(code + ' ')
    import_, = script.complete()
    assert import_.name == 'import'

    script = Script("from " + '.' * 100 + 'abc import ABCMeta')
    assert not script.infer()
    assert not script.complete()


@pytest.mark.parametrize(
    'level, directory, project_path, result', [
        (1, '/a/b/c', '/a', (['b', 'c'], '/a')),
        (2, '/a/b/c', '/a', (['b'], '/a')),
        (3, '/a/b/c', '/a', ([], '/a')),
        (4, '/a/b/c', '/a', (None, '/')),
        (5, '/a/b/c', '/a', (None, None)),
        (1, '/', '/', ([], '/')),
        (2, '/', '/', (None, None)),
        (1, '/a/b', '/a/b/c', (None, '/a/b')),
        (2, '/a/b', '/a/b/c', (None, '/a')),
        (3, '/a/b', '/a/b/c', (None, '/')),
    ]
)
def test_level_to_import_path(level, directory, project_path, result):
    assert imports._level_to_base_import_path(project_path, directory, level) == result


def test_import_name_calculation(Script):
    s = Script(path=os.path.join(test_dir, 'completion', 'isinstance.py'))
    m = s._get_module_context()
    assert m.string_names == ('test', 'completion', 'isinstance')


@pytest.mark.parametrize('name', ('builtins', 'typing'))
def test_pre_defined_imports_module(Script, environment, name):
    path = os.path.join(root_dir, name + '.py')
    module = Script('', path=path)._get_module_context()
    assert module.string_names == (name,)

    assert str(module.inference_state.builtins_module.py__file__()) != path
    assert str(module.inference_state.typing_module.py__file__()) != path


@pytest.mark.parametrize('name', ('builtins', 'typing'))
def test_import_needed_modules_by_jedi(Script, environment, tmpdir, name):
    module_path = tmpdir.join(name + '.py')
    module_path.write('int = ...')
    script = Script(
        'import ' + name,
        path=tmpdir.join('something.py').strpath,
        project=Project('.', sys_path=[tmpdir.strpath] + environment.get_sys_path()),
    )
    module, = script.infer()
    assert str(module._inference_state.builtins_module.py__file__()) != module_path
    assert str(module._inference_state.typing_module.py__file__()) != module_path


def test_import_with_semicolon(Script):
    names = [c.name for c in Script('xzy; from abc import ').complete()]
    assert 'ABCMeta' in names
    assert 'abc' not in names


def test_relative_import_star(Script):
    # Coming from github #1235
    source = """
    from . import *
    furl.c
    """
    script = Script(source, path='export.py')

    assert script.complete(3, len("furl.c"))


@pytest.mark.parametrize('with_init', [False, True])
def test_relative_imports_without_path_and_setup_py(
        Script, inference_state, environment, tmpdir, with_init):
    # Contrary to other tests here we create a temporary folder that is not
    # part of a folder with a setup.py that signifies
    tmpdir.join('file1.py').write('do_foo = 1')
    other_path = tmpdir.join('other_files')
    other_path.join('file2.py').write('def do_nothing():\n pass', ensure=True)
    if with_init:
        other_path.join('__init__.py').write('')

    for name, code in [('file2', 'from . import file2'),
                       ('file1', 'from .. import file1')]:
        for func in (jedi.Script.goto, jedi.Script.infer):
            n, = func(Script(code, path=other_path.join('test1.py').strpath))
            assert n.name == name
            assert n.type == 'module'
            assert n.line == 1


def test_import_recursion(Script):
    path = get_example_dir('import-recursion', "cq_example.py")
    for c in Script(path=path).complete(3, 3):
        c.docstring()
