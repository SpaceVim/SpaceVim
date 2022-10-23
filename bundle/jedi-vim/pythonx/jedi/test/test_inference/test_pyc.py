"""
Test completions from *.pyc files:

 - generate a dummy python module
 - compile the dummy module to generate a *.pyc
 - delete the pure python dummy module
 - try jedi on the generated *.pyc
"""
import os
import shutil
import sys

import pytest

import jedi
from jedi.api.environment import SameEnvironment, InterpreterEnvironment


SRC = """class Foo:
    pass

class Bar:
    pass
"""


@pytest.fixture
def pyc_project_path(tmpdir):
    path = tmpdir.strpath
    dummy_package_path = os.path.join(path, "dummy_package")
    os.mkdir(dummy_package_path)
    with open(os.path.join(dummy_package_path, "__init__.py"), 'w', newline=''):
        pass

    dummy_path = os.path.join(dummy_package_path, 'dummy.py')
    with open(dummy_path, 'w', newline='') as f:
        f.write(SRC)
    import compileall
    compileall.compile_file(dummy_path)
    os.remove(dummy_path)

    # To import pyc modules, we must move them out of the __pycache__
    # directory and rename them to remove ".cpython-%s%d"
    # see: http://stackoverflow.com/questions/11648440/python-does-not-detect-pyc-files
    pycache = os.path.join(dummy_package_path, "__pycache__")
    for f in os.listdir(pycache):
        dst = f.replace('.cpython-%s%s' % sys.version_info[:2], "")
        dst = os.path.join(dummy_package_path, dst)
        shutil.copy(os.path.join(pycache, f), dst)
    try:
        yield path
    finally:
        shutil.rmtree(path)


@pytest.mark.parametrize('load_unsafe_extensions', [False, True])
def test_pyc(pyc_project_path, environment, load_unsafe_extensions):
    """
    The list of completion must be greater than 2.
    """
    path = os.path.join(pyc_project_path, 'blub.py')
    if not isinstance(environment, InterpreterEnvironment):
        # We are using the same version for pyc completions here, because it
        # was compiled in that version. However with interpreter environments
        # we also have the same version and it's easier to debug.
        environment = SameEnvironment()
    environment = environment
    project = jedi.Project(pyc_project_path, load_unsafe_extensions=load_unsafe_extensions)
    s = jedi.Script(
        "from dummy_package import dummy; dummy.",
        path=path,
        environment=environment,
        project=project,
    )
    if load_unsafe_extensions:
        assert len(s.complete()) >= 2
    else:
        assert not s.complete()
