import tempfile
import shutil
import os
import sys
from functools import partial

import pytest

import jedi
from jedi.api.environment import get_system_environment, InterpreterEnvironment
from test.helpers import test_dir

collect_ignore = [
    'setup.py',
    'jedi/__main__.py',
    'jedi/inference/compiled/subprocess/__main__.py',
    'build/',
    'test/examples',
    'sith.py',
]


# The following hooks (pytest_configure, pytest_unconfigure) are used
# to modify `jedi.settings.cache_directory` because `clean_jedi_cache`
# has no effect during doctests.  Without these hooks, doctests uses
# user's cache (e.g., ~/.cache/jedi/).  We should remove this
# workaround once the problem is fixed in pytest.
#
# See:
# - https://github.com/davidhalter/jedi/pull/168
# - https://bitbucket.org/hpk42/pytest/issue/275/

jedi_cache_directory_orig = None
jedi_cache_directory_temp = None


def pytest_addoption(parser):
    parser.addoption("--jedi-debug", "-D", action='store_true',
                     help="Enables Jedi's debug output.")

    parser.addoption("--warning-is-error", action='store_true',
                     help="Warnings are treated as errors.")

    parser.addoption("--env", action='store',
                     help="Execute the tests in that environment (e.g. 39 for python3.9).")
    parser.addoption("--interpreter-env", "-I", action='store_true',
                     help="Don't use subprocesses to guarantee having safe "
                          "code execution. Useful for debugging.")


def pytest_configure(config):
    global jedi_cache_directory_orig, jedi_cache_directory_temp
    jedi_cache_directory_orig = jedi.settings.cache_directory
    jedi_cache_directory_temp = tempfile.mkdtemp(prefix='jedi-test-')
    jedi.settings.cache_directory = jedi_cache_directory_temp

    if config.option.jedi_debug:
        jedi.set_debug_function()

    if config.option.warning_is_error:
        import warnings
        warnings.simplefilter("error")


def pytest_unconfigure(config):
    global jedi_cache_directory_orig, jedi_cache_directory_temp
    jedi.settings.cache_directory = jedi_cache_directory_orig
    shutil.rmtree(jedi_cache_directory_temp)


@pytest.fixture(scope='session')
def clean_jedi_cache(request):
    """
    Set `jedi.settings.cache_directory` to a temporary directory during test.

    Note that you can't use built-in `tmpdir` and `monkeypatch`
    fixture here because their scope is 'function', which is not used
    in 'session' scope fixture.

    This fixture is activated in ../pytest.ini.
    """
    from jedi import settings
    old = settings.cache_directory
    tmp = tempfile.mkdtemp(prefix='jedi-test-')
    settings.cache_directory = tmp

    @request.addfinalizer
    def restore():
        settings.cache_directory = old
        shutil.rmtree(tmp)


@pytest.fixture(scope='session')
def environment(request):
    version = request.config.option.env
    if version is None:
        v = str(sys.version_info[0]) + str(sys.version_info[1])
        version = os.environ.get('JEDI_TEST_ENVIRONMENT', v)

    if request.config.option.interpreter_env or version == 'interpreter':
        return InterpreterEnvironment()

    if '.' not in version:
        version = version[0] + '.' + version[1:]
    return get_system_environment(version)


@pytest.fixture(scope='session')
def Script(environment):
    return partial(jedi.Script, environment=environment)


@pytest.fixture(scope='session')
def ScriptWithProject(Script):
    project = jedi.Project(test_dir)
    return partial(jedi.Script, project=project)


@pytest.fixture(scope='session')
def get_names(Script):
    return lambda code, **kwargs: Script(code).get_names(**kwargs)


@pytest.fixture(scope='session', params=['goto', 'infer'])
def goto_or_infer(request, Script):
    return lambda code, *args, **kwargs: getattr(Script(code), request.param)(*args, **kwargs)


@pytest.fixture(scope='session', params=['goto', 'help'])
def goto_or_help(request, Script):
    return lambda code, *args, **kwargs: getattr(Script(code), request.param)(*args, **kwargs)


@pytest.fixture(scope='session', params=['goto', 'help', 'infer'])
def goto_or_help_or_infer(request, Script):
    def do(code, *args, **kwargs):
        return getattr(Script(code), request.param)(*args, **kwargs)

    do.type = request.param
    return do


@pytest.fixture(scope='session', params=['goto', 'complete', 'help'])
def goto_or_complete(request, Script):
    return lambda code, *args, **kwargs: getattr(Script(code), request.param)(*args, **kwargs)


@pytest.fixture(scope='session')
def has_django(environment):
    script = jedi.Script('import django', environment=environment)
    return bool(script.infer())


@pytest.fixture(scope='session')
def jedi_path():
    return os.path.dirname(__file__)


@pytest.fixture()
def skip_pre_python38(environment):
    if environment.version_info < (3, 8):
        # This if is just needed to avoid that tests ever skip way more than
        # they should for all Python versions.
        pytest.skip()


@pytest.fixture()
def skip_pre_python37(environment):
    if environment.version_info < (3, 7):
        # This if is just needed to avoid that tests ever skip way more than
        # they should for all Python versions.
        pytest.skip()
