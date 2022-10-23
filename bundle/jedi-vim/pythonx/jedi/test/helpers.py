"""
A helper module for testing, improves compatibility for testing (as
``jedi._compatibility``) as well as introducing helper functions.
"""

from contextlib import contextmanager

import os
import pytest
from functools import partial, wraps
from jedi import Project
from pathlib import Path

test_dir = Path(__file__).absolute().parent
test_dir_project = Project(test_dir)
root_dir = test_dir.parent
example_dir = test_dir.joinpath('examples')

sample_int = 1  # This is used in completion/imports.py

skip_if_windows = partial(pytest.param,
                          marks=pytest.mark.skipif("sys.platform=='win32'"))
skip_if_not_windows = partial(pytest.param,
                              marks=pytest.mark.skipif("sys.platform!='win32'"))


def get_example_dir(*names):
    return example_dir.joinpath(*names)


def cwd_at(path):
    """
    Decorator to run function at `path`.

    :type path: str
    :arg  path: relative path from repository root (e.g., ``'jedi'``).
    """
    def decorator(func):
        @wraps(func)
        def wrapper(Script, **kwargs):
            with set_cwd(path):
                return func(Script, **kwargs)
        return wrapper
    return decorator


@contextmanager
def set_cwd(path, absolute_path=False):
    repo_root = test_dir.parent

    oldcwd = Path.cwd()
    os.chdir(repo_root.joinpath(path))
    try:
        yield
    finally:
        os.chdir(oldcwd)
