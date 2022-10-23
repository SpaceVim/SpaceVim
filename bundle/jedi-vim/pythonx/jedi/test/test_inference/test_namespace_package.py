from os.path import join

import pytest
import py

from ..helpers import get_example_dir, example_dir
from jedi import Project


SYS_PATH = [get_example_dir('namespace_package', 'ns1'),
            get_example_dir('namespace_package', 'ns2')]


def script_with_path(Script, *args, **kwargs):
    return Script(project=Project('.', sys_path=SYS_PATH), *args, **kwargs)


def test_goto_definition(Script):
    assert script_with_path(Script, 'from pkg import ns1_file').infer()
    assert script_with_path(Script, 'from pkg import ns2_file').infer()
    assert not script_with_path(Script, 'from pkg import ns3_file').infer()


@pytest.mark.parametrize(
    ('source', 'solution'), [
        ('from pkg.ns2_folder.nested import foo', 'nested!'),
        ('from pkg.ns2_folder import foo', 'ns2_folder!'),
        ('from pkg.ns2_file import foo', 'ns2_file!'),
        ('from pkg.ns1_folder import foo', 'ns1_folder!'),
        ('from pkg.ns1_file import foo', 'ns1_file!'),
        ('from pkg import foo', 'ns1!'),
    ]
)
def test_goto_assignment(Script, source, solution):
    ass = script_with_path(Script, source).goto()
    assert len(ass) == 1
    assert ass[0].description == "foo = '%s'" % solution


def test_simple_completions(Script):
    # completion
    completions = script_with_path(Script, 'from pkg import ').complete()
    names = [c.name for c in completions]
    compare = ['foo', 'ns1_file', 'ns1_folder', 'ns2_folder', 'ns2_file',
               'pkg_resources', 'pkgutil', '__name__', '__path__',
               '__package__', '__file__', '__doc__']
    # must at least contain these items, other items are not important
    assert set(compare) == set(names)


@pytest.mark.parametrize(
    ('source', 'solution'), [
        ('from pkg import ns2_folder as x', 'ns2_folder!'),
        ('from pkg import ns2_file as x', 'ns2_file!'),
        ('from pkg.ns2_folder import nested as x', 'nested!'),
        ('from pkg import ns1_folder as x', 'ns1_folder!'),
        ('from pkg import ns1_file as x', 'ns1_file!'),
        ('import pkg as x', 'ns1!'),
    ]
)
def test_completions(Script, source, solution):
    for c in script_with_path(Script, source + '; x.').complete():
        if c.name == 'foo':
            completion = c
    solution = "foo = '%s'" % solution
    assert completion.description == solution


def test_nested_namespace_package(Script):
    code = 'from nested_namespaces.namespace.pkg import CONST'

    sys_path = [example_dir]
    project = Project('.', sys_path=sys_path)
    result = Script(code, project=project).infer(line=1, column=45)

    assert len(result) == 1


def test_relative_import(Script, environment, tmpdir):
    """
    Attempt a relative import in a very simple namespace package.
    """
    directory = get_example_dir('namespace_package_relative_import')
    # Need to copy the content in a directory where there's no __init__.py.
    py.path.local(directory).copy(tmpdir)
    file_path = join(tmpdir.strpath, "rel1.py")
    script = Script(path=file_path)
    d, = script.infer(line=1)
    assert d.name == 'int'
    d, = script.goto(line=1)
    assert d.name == 'name'
    assert d.module_name == 'rel2'
