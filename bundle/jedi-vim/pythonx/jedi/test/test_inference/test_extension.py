"""
Test compiled module
"""
import os

import jedi
from ..helpers import get_example_dir
import pytest


def test_completions(Script):
    s = Script('import _ctypes; _ctypes.')
    assert len(s.complete()) >= 15


def test_get_signatures_extension(Script, environment):
    if os.name == 'nt':
        func = 'LoadLibrary'
    else:
        func = 'dlopen'
    s = Script('import _ctypes; _ctypes.%s(' % (func,))
    sigs = s.get_signatures()
    assert len(sigs) == 1
    assert len(sigs[0].params) in (1, 2)


def test_get_signatures_stdlib(Script):
    s = Script('import math; math.cos(')
    sigs = s.get_signatures()
    assert len(sigs) == 1
    assert len(sigs[0].params) == 1


# Check only on linux 64 bit platform and Python3.8.
@pytest.mark.parametrize('load_unsafe_extensions', [False, True])
@pytest.mark.skipif('sys.platform != "linux" or sys.maxsize <= 2**32 or sys.version_info[:2] != (3, 8)')
def test_init_extension_module(Script, load_unsafe_extensions):
    """
    ``__init__`` extension modules are also packages and Jedi should understand
    that.

    Originally coming from #472.

    This test was built by the module.c and setup.py combination you can find
    in the init_extension_module folder. You can easily build the
    `__init__.cpython-38m.so` by compiling it (create a virtualenv and run
    `setup.py install`.

    This is also why this test only runs on certain systems and Python 3.8.
    """

    project = jedi.Project(get_example_dir(), load_unsafe_extensions=load_unsafe_extensions)
    s = jedi.Script(
        'import init_extension_module as i\ni.',
        path='not_existing.py',
        project=project,
    )
    if load_unsafe_extensions:
        assert 'foo' in [c.name for c in s.complete()]
    else:
        assert 'foo' not in [c.name for c in s.complete()]

    s = jedi.Script(
        'from init_extension_module import foo\nfoo',
        path='not_existing.py',
        project=project,
    )
    c, = s.complete()
    assert c.name == 'foo'
    if load_unsafe_extensions:
        assert c.infer()
    else:
        assert not c.infer()
