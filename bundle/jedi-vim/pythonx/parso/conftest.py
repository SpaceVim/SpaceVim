import re
import tempfile
import shutil
import logging
import os
from pathlib import Path

import pytest

import parso
from parso import cache
from parso.utils import parse_version_string

collect_ignore = ["setup.py"]

_SUPPORTED_VERSIONS = '3.6', '3.7', '3.8', '3.9', '3.10'


@pytest.fixture(scope='session')
def clean_parso_cache():
    """
    Set the default cache directory to a temporary directory during tests.

    Note that you can't use built-in `tmpdir` and `monkeypatch`
    fixture here because their scope is 'function', which is not used
    in 'session' scope fixture.

    This fixture is activated in ../pytest.ini.
    """
    old = cache._default_cache_path
    tmp = tempfile.mkdtemp(prefix='parso-test-')
    cache._default_cache_path = Path(tmp)
    yield
    cache._default_cache_path = old
    shutil.rmtree(tmp)


def pytest_addoption(parser):
    parser.addoption("--logging", "-L", action='store_true',
                     help="Enables the logging output.")


def pytest_generate_tests(metafunc):
    if 'normalizer_issue_case' in metafunc.fixturenames:
        base_dir = os.path.join(os.path.dirname(__file__), 'test', 'normalizer_issue_files')

        cases = list(colllect_normalizer_tests(base_dir))
        metafunc.parametrize(
            'normalizer_issue_case',
            cases,
            ids=[c.name for c in cases]
        )
    elif 'each_version' in metafunc.fixturenames:
        metafunc.parametrize('each_version', _SUPPORTED_VERSIONS)
    elif 'version_ge_py38' in metafunc.fixturenames:
        ge38 = set(_SUPPORTED_VERSIONS) - {'3.6', '3.7'}
        metafunc.parametrize('version_ge_py38', sorted(ge38))


class NormalizerIssueCase:
    """
    Static Analysis cases lie in the static_analysis folder.
    The tests also start with `#!`, like the goto_definition tests.
    """
    def __init__(self, path):
        self.path = path
        self.name = os.path.basename(path)
        match = re.search(r'python([\d.]+)\.py', self.name)
        self.python_version = match and match.group(1)


def colllect_normalizer_tests(base_dir):
    for f_name in os.listdir(base_dir):
        if f_name.endswith(".py"):
            path = os.path.join(base_dir, f_name)
            yield NormalizerIssueCase(path)


def pytest_configure(config):
    if config.option.logging:
        root = logging.getLogger()
        root.setLevel(logging.DEBUG)

        #ch = logging.StreamHandler(sys.stdout)
        #ch.setLevel(logging.DEBUG)
        #formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        #ch.setFormatter(formatter)

        #root.addHandler(ch)


class Checker:
    def __init__(self, version, is_passing):
        self.version = version
        self._is_passing = is_passing
        self.grammar = parso.load_grammar(version=self.version)

    def parse(self, code):
        if self._is_passing:
            return parso.parse(code, version=self.version, error_recovery=False)
        else:
            self._invalid_syntax(code)

    def _invalid_syntax(self, code):
        with pytest.raises(parso.ParserSyntaxError):
            module = parso.parse(code, version=self.version, error_recovery=False)
            # For debugging
            print(module.children)

    def get_error(self, code):
        errors = list(self.grammar.iter_errors(self.grammar.parse(code)))
        assert bool(errors) != self._is_passing
        if errors:
            return errors[0]

    def get_error_message(self, code):
        error = self.get_error(code)
        if error is None:
            return
        return error.message

    def assert_no_error_in_passing(self, code):
        if self._is_passing:
            module = self.grammar.parse(code)
            assert not list(self.grammar.iter_errors(module))


@pytest.fixture
def works_not_in_py(each_version):
    return Checker(each_version, False)


@pytest.fixture
def works_in_py(each_version):
    return Checker(each_version, True)


@pytest.fixture
def works_ge_py38(each_version):
    version_info = parse_version_string(each_version)
    return Checker(each_version, version_info >= (3, 8))


@pytest.fixture
def works_ge_py39(each_version):
    version_info = parse_version_string(each_version)
    return Checker(each_version, version_info >= (3, 9))
