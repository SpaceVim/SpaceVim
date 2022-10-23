import os
from glob import glob
import sys
import shutil
from pathlib import Path

import pytest

from ..helpers import skip_if_windows, skip_if_not_windows, get_example_dir
from jedi.inference import sys_path
from jedi.api.environment import create_environment


def test_paths_from_assignment(Script):
    def paths(src):
        script = Script(src, path='/foo/bar.py')
        expr_stmt = script._module_node.children[0]
        return set(sys_path._paths_from_assignment(script._get_module_context(), expr_stmt))

    # Normalize paths for Windows.
    path_a = Path('/foo/a').absolute()
    path_b = Path('/foo/b').absolute()
    path_c = Path('/foo/c').absolute()

    assert paths('sys.path[0:0] = ["a"]') == {path_a}
    assert paths('sys.path = ["b", 1, x + 3, y, "c"]') == {path_b, path_c}
    assert paths('sys.path = a = ["a"]') == {path_a}

    # Fail for complicated examples.
    assert paths('sys.path, other = ["a"], 2') == set()


def test_venv_and_pths(venv_path):
    pjoin = os.path.join

    site_pkg_path = pjoin(venv_path, 'lib')
    if os.name == 'nt':
        site_pkg_path = pjoin(site_pkg_path, 'site-packages')
    else:
        site_pkg_path = glob(pjoin(site_pkg_path, 'python*', 'site-packages'))[0]
    shutil.rmtree(site_pkg_path)
    shutil.copytree(get_example_dir('sample_venvs', 'pth_directory'), site_pkg_path)

    virtualenv = create_environment(venv_path)
    venv_paths = virtualenv.get_sys_path()

    ETALON = [
        # For now disable egg-links. I have no idea how they work... ~ dave
        #pjoin('/path', 'from', 'egg-link'),
        #pjoin(site_pkg_path, '.', 'relative', 'egg-link', 'path'),
        site_pkg_path,
        pjoin(site_pkg_path, 'dir-from-foo-pth'),
        '/foo/smth.py:module',
        # Not sure why it's added twice. It has to do with site.py which is not
        # something we can change. However this obviously also doesn't matter.
        '/foo/smth.py:from_func',
        '/foo/smth.py:from_func',
    ]

    # Ensure that pth and egg-link paths were added.
    assert venv_paths[-len(ETALON):] == ETALON

    # Ensure that none of venv dirs leaked to the interpreter.
    assert not set(sys.path).intersection(ETALON)


_s = ['/a', '/b', '/c/d/']


@pytest.mark.parametrize(
    'sys_path_, module_path, expected, is_package', [
        (_s, '/a/b', ('b',), False),
        (_s, '/a/b/c', ('b', 'c'), False),
        (_s, '/a/b.py', ('b',), False),
        (_s, '/a/b/c.py', ('b', 'c'), False),
        (_s, '/x/b.py', None, False),
        (_s, '/c/d/x.py', ('x',), False),
        (_s, '/c/d/x.py', ('x',), False),
        (_s, '/c/d/x/y.py', ('x', 'y'), False),
        # If dots are in there they also resolve. These are obviously illegal
        # in Python, but Jedi can handle them. Give the user a bit more freedom
        # that he will have to correct eventually.
        (_s, '/a/b.c.py', ('b.c',), False),
        (_s, '/a/b.d/foo.bar.py', ('b.d', 'foo.bar'), False),

        (_s, '/a/.py', None, False),
        (_s, '/a/c/.py', None, False),

        (['/foo'], '/foo/bar/__init__.py', ('bar',), True),
        (['/foo'], '/foo/bar/baz/__init__.py', ('bar', 'baz'), True),

        skip_if_windows(['/foo'], '/foo/bar.so', ('bar',), False),
        skip_if_windows(['/foo'], '/foo/bar/__init__.so', ('bar',), True),
        skip_if_not_windows(['/foo'], '/foo/bar.pyd', ('bar',), False),
        skip_if_not_windows(['/foo'], '/foo/bar/__init__.pyd', ('bar',), True),

        (['/foo'], '/x/bar.py', None, False),
        (['/foo'], '/foo/bar.xyz', ('bar.xyz',), False),

        (['/foo', '/foo/bar'], '/foo/bar/baz', ('baz',), False),
        (['/foo/bar', '/foo'], '/foo/bar/baz', ('baz',), False),

        (['/'], '/bar/baz.py', ('bar', 'baz',), False),
    ])
def test_transform_path_to_dotted(sys_path_, module_path, expected, is_package):
    # transform_path_to_dotted expects normalized absolute paths.
    sys_path_ = [os.path.abspath(path) for path in sys_path_]
    module_path = os.path.abspath(module_path)
    assert sys_path.transform_path_to_dotted(sys_path_, Path(module_path)) \
        == (expected, is_package)
